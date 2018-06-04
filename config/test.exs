use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :squash_scores, SquashScoresWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :squash_scores, scores_dir: "priv/static/test_scores"
config :squash_scores, scores_file_location: "priv/static/test_scores/scores"
