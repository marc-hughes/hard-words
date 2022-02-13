defmodule HardWordsEx.Repo.Migrations.AddScoreField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :score, :integer, default: 0
    end
  end
end
