import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :hard_words_ex, HardWordsEx.Repo,
  username: "hardwords",
  password: "learningelixir",
  hostname: "localhost",
  database: "hard_words_ex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hard_words_ex, HardWordsExWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "GzHduglRGbSkcr7bM20q+imSq6X27WEWjTK/zEQpYAnxT+Iyo7rdT3oNBdqhx5ji",
  server: false

# In test we don't send emails.
config :hard_words_ex, HardWordsEx.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
