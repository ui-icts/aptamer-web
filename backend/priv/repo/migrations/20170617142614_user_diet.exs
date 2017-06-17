defmodule Aptamer.Repo.Migrations.UserDiet do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :reset_password_token
      remove :reset_password_sent_at
      remove :failed_attempts
      remove :locked_at
      remove :sign_in_count
      remove :current_sign_in_at
      remove :last_sign_in_at
      remove :current_sign_in_ip
      remove :last_sign_in_ip
      remove :unlock_token
    end
    rename table(:users), :password_hash, to: :password
  end
end
