# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Aptamer.Repo.insert!(%Aptamer.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Aptamer.Auth.User.changeset(%Aptamer.Auth.User{}, %{name: "Test User", email: "testuser@example.com", password: "welcome", password_confirmation: "welcome"}) |> Aptamer.Repo.insert!
