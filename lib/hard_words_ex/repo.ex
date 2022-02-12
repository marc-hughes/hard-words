defmodule HardWordsEx.Repo do
  use Ecto.Repo,
    otp_app: :hard_words_ex,
    adapter: Ecto.Adapters.Postgres
end
