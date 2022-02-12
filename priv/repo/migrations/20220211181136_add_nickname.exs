defmodule HardWordsEx.Repo.Migrations.AddNickname do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :nickname, :text, null: false
    end
  end
end
