defmodule DevicePresence.Repo.Migrations.AddSlackMentionNameSlackUserIdAndGithubUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slack_mention_name, :string
      add :slack_user_id, :string
      add :github_username, :string
    end
  end
end
