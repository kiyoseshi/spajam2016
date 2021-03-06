require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Spajam
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #config.wit_token = Y3SKN3OLWR3LT57GRVRR6EZNAQF7MMMG

    config.wit_actions = {
      :say => -> (session_id, context, msg) {
        p msg
      },
      :merge => -> (session_id, context, entities, msg) {

        loc = nil if entities.has_key?('location')
        val = entities['location'][0]['value'] unless loc.nil?
        loc =  nil if val.nil?
        unless val.nil?
          loc =  val.is_a?(Hash) ? val['value'] : val
        end

        context['loc'] = loc unless loc.nil?
        return context
      },
      :error => -> (session_id, context, error) {
        p error.message
      },
      :'fetch-weather' => -> (session_id, context) {
        context['forecast'] = 'sunny'
        return context
      },
    }
  end
end
