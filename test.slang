
type panic <message: string>

impl <effect> for <panic>
  def default <self>
    std:print:error self.message
    std:system:exit fail

type maybe <infer T>
  | some <T>
  | none <empty>

impl <infer T> unwrap
  def unwrap <self: self> -> <Effect<T, [Panic:Effect]>>

// multiple types elided here because it should be able to figure it out
// Maybe.unwrap <Maybe:None> -> Effect<_, [Panic.effect]>
// Maybe.unwrap <Maybe:None> -> Effect<T, []>
impl <unwrap> for <Maybe>
  def unwrap <self: Maybe:Some>
    self.inner
  
  def unwrap <self: Maybe:None>
    panic "Unable to unwrap Maybe type!"

def fib <n: int.expect {n < 2}>
  ret n

def fib <n: int>
  fib {n - 1} + fib {n - 2}
