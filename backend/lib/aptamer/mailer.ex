defmodule Aptamer.Mailer do
  require Bamboo.Mailer

  @spec deliver_now(Bamboo.Email.t()) :: Bamboo.Email.t()
  def deliver_now(email) do
    config = build_config()
    Bamboo.Mailer.deliver_now(config.adapter, email, config)
  end

  @spec deliver_later(Bamboo.Email.t()) :: Bamboo.Email.t()
  def deliver_later(email) do
    config = build_config()
    Bamboo.Mailer.deliver_later(config.adapter, email, config)
  end

  defp build_config() do 
    opts = Bamboo.Mailer.build_config(__MODULE__, :aptamer)
    Aptamer.EnvConfig.override_smtp_config(System.get_env(), opts)
  end

  @spec deliver(any()) :: no_return()
  def deliver(_email) do
    raise """
    you called deliver/1, but it has been renamed to deliver_now/1 to add clarity.
    Use deliver_now/1 to send right away, or deliver_later/1 to send in the background.
    """
  end
end
