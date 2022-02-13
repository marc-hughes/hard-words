defmodule HardWordsEx.Repo.Migrations.CreateScorelog do
  use Ecto.Migration

  def change do
    create table(:scorelog) do
      add :word, :string
      add :correct, :boolean
      add :tries, :integer
      add :user_id, references(:users)
      timestamps()
    end
  end
end
