import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lights_out, LightsOutWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "o0bX6PrP2byBOXC8bsE2Gjv8G+QtjT12wGt6zlUQiCwqv0hF+xP/hL85eCQig2iO",
  server: false

# In test we don't send emails.
config :lights_out, LightsOut.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
