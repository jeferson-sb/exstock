defmodule Tracker.Mailers.WatcherMailer do
  @mailer_api_key Application.compile_env(:tracker, :resend_api_key)
  @user_email Application.compile_env(:tracker, :user_email)
  @client Resend.client(api_key: @mailer_api_key)

  def mail(""), do: nil

  def mail(message) do
    Resend.Emails.send(@client, %{
      from: "exstock@exstock.com",
      to: @user_email,
      subject: "Exstock: Watchlist alert!",
      html: message
    })
  end
end
