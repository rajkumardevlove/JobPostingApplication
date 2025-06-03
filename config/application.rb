require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JobPostingApplication
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

# 16. Remove Deprecates 'mysql' => 'mysql -u root -p'
    config.dbconsole = { 'mysql' => 'mysql -u root -p' }

    #17(i) ActionDispatch::Response - Using return_only_media_type_on_content_type
    response = ActionDispatch::Response.new(200)
    response.content_type = "text/html; charset=utf-8"
    puts response.return_only_media_type_on_content_type # Expected output: "text/html"

    #17(ii) Configuration - Using action_dispatch.hosts_response_app
    Rails.application.config.action_dispatch.hosts_response_app = ->(env) { [403, {}, ["Forbidden"]] }

    # 18 Deprecated raise_on_missing_translations
    config.action_view.raise_on_missing_translations = true

    # config.i18n.raise_on_missing_translations = true

    # 50 Removed below deprecate code and no longer supported
    # config.active_support.use_sha1_digests = true

    # 51 URI.parser removed
    puts URI.parser

    # uri = URI.parse("https://example.com/path?query=value")

  end
end
