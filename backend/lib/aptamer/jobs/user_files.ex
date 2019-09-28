defmodule Aptamer.Jobs.UserFiles do
  alias Aptamer.Auth.User

  def topic(%User{} = user) do
    topic(user.id)
  end

  def topic(user_id) when is_binary(user_id) do
    "user:" <> user_id <> ":files"
  end

  def broadcast_file_generated(file) do
    Phoenix.PubSub.broadcast(
      AptamerWeb.PubSub,
      topic(file.owner_id),
      {:generated_file, file}
    )
  end
end
