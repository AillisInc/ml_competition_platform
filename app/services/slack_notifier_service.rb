class SlackNotifierService

  class << self

    def notify(message, emoji)

      webhook_url = Rails.application.config.x.slack_webhook_url

      return if webhook_url.blank?

      notifier = Slack::Notifier.new(webhook_url)
      notifier.post(text: message, icon_emoji: emoji)
    end

  end

end