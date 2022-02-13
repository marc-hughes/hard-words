defmodule HardWordsEx.Gameplay.ScoreLog do
  use Ecto.Schema
  alias HardWordsEx.Repo
  # import Ecto.Changeset

  schema "scorelog" do
    field :word, :string
    field :correct, :boolean
    field :tries, :integer
    belongs_to :user, HardWordsEx.Accounts.User
    timestamps()
  end

  def insertScore(word, correct, tries, user) do
    Repo.insert(%HardWordsEx.Gameplay.ScoreLog{
      word: word,
      correct: correct,
      tries: tries,
      user: user
    })
  end
end
