defmodule HardWordsEx.Gameplay.ScoreLog do
  use Ecto.Schema
  import Ecto.Query, warn: false
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

    if correct do
      newUser = Ecto.Changeset.change(user, score: user.score + 1)
      Repo.update(newUser)
    end
  end

  def recentWords(userId) do
    Repo.all(
      from(s in HardWordsEx.Gameplay.ScoreLog,
        where: s.user_id == ^userId,
        order_by: [desc: s.inserted_at]
      )
    )
  end

  def recentScores() do
    Repo.all(from u in HardWordsEx.Gameplay.ScoreLog, order_by: [desc: :inserted_at], limit: 20)
  end
end
