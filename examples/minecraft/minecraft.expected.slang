$ ./bin user api profile --help
[0.0.1] bin api profile

TYPES:
	<Username into UUID>
    User:             either a Username or UUID
  <string>
    Username:         username of a user 
    UUID:             uuid of a user

COMMANDS:
  names <user: User>  gets the username history of a user
  skin <...>          subcommand group
  cape <...>          subcommand group

OPTIONS:
  -h, --help          prints help information

ARGS:
  user: User          the user to get the profile from

returns json { id: UUID, username: Username }
$ ./bin api profile brecert
{ id: "7a8084cd1f444a159bb1eef8d5b535a1", username: "Brecert" }


