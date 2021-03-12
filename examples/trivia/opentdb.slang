type Difficulty <enum {
  Easy,
  Medium,
  Hard,
}>

type QuestionType <enum {
  MultipleChoice,
  TrueFalse,
}>

type Encoding <enum {
  Url3986,
  Base64,
}>

type Category <(
  | http https://opentdb.com/api_category.php
  | json { trivia_categories: { id: int, name: string }[] }
  | enum.from { object: _.trivia_categories, id: (_.id), atom: (_.name.rename case camel_case) }
)>

type FetchParams <{
  amount: 0..=50 = 1
  category: Maybe<Category>
  difficulty: Maybe<Difficulty>
  type: Maybe<QuestionType>
  encoding: Maybe<Encoding>
}>

type Question <{
  category: Category:From<string>
  type: QuestionType:From<string>
  difficulty: Difficulty:From<string>
  quesion: string
  correct_answer: string
  incorrect_answers: string[]
}> 

impl <FetchParams> into <URL:Encoding>
  def from <params>
    URL:Encoding {
      amount: params.amount,
      category: params.category,
      difficulty: params.difficulty,
      type: params.type,
      encode: params.encoding
    }

impl <URL:Encoding> for <Difficulty>
  def encode <self: Self:Easy>: "easy"
  def encode <self: Self:Medium>: "medium"
  def encode <self: Self:Hard>: "hard"

impl <URL:Encoding> for <QuestionType>
  def encode <self: Self:MultipleChoice>: "multiple"
  def encode <self: Self:TrueFalse>: "boolean"

impl <URL:Encoding> for <Encoding>
  def encode <self: Self:Url3986>: "url3986"
  def encode <self: Self:Base64>: "base64"

def fetch <params: FetchParams>
  | http https://opentdb.com/api.php?{params}
  | json { response_code: int, results: list<size: 10, type: Question> }

test "fetch: works"
  def test_fetch
    fetch { amount: 5, difficulty: Difficulty:Hard }