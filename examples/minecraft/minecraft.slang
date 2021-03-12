/// uuid of a user
type UUID <string>

/// username of a user
/// a username must be less than 16 characters and only contain ascii alphanumeric characters and underscores
type Username <string.expect {
  self <= 16 && string.all? { def <char>: char === /[a-zA-Z0-9_]/ } 
}>

/// converts a username or uuid into a uuid 
impl <Username> into <UUID>
  def from <user>: uuid {user}

// Utility type that's the same as UUID
/// either a Username or UUID
type User <into UUID> 

// A unix timestamp in milliseconds
type Timestamp <time:ms>

/// gets uuid of a username
def user uuid <user: Username>
  | api profile {user}
  | _.id

/// gets the profile of user
/// @param {user} the user to get the profile from
def api profile <user: User>
  | http api.mojang.com/users/profiles/{user}
  | json { id: UUID, username: Username }

/// gets the username history of a user
def api profile names <user: User>
  | http api.mojang.com/user/profiles/{user}/names
  | json [ { name: Username }, { name: Username, changedToAt: Timestamp }... ]
  | struct.each.rename case camel

/// gets the skin url of a user
def api profile skin url <user: User>
  | api session {user}
  | _.textures.skin.url

/// gets the skin type of a user
def api profile skin type <user: User>
  | api session {user}
  | _.textures.skin.metadata.map {def <meta>: meta.model}
  | _ || "classic"

/// gets the cape url of a user
def api profile cape url <user: User>
  | api session {user}
  | _.textures.cape.url

/// gets the session information of a profile
def api session <user: User>
  | http sessionserver.mojang.com/session/minecraft/profile/{user}
  | json { id: UUID, name: Username, properties: [ { name: "textures", value: string } ] }
  | base64 decode _.properties.0.value
  | json {
      timestamp: Timestamp,
      profileId: UUID,
      profileName: Username,
      textures: {
        SKIN: { 
          url: URL
          metadata: Maybe { metadata: { model: "slim" } }
        },
        CAPE: { url: URL }
      }
    }
  | def <self>: struct.each_key self
      def <key: string.mut>
        key.mut.change_case camel
        key.mut.change_case lower