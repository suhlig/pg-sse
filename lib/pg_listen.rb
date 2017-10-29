# frozen_string_literal: true

require 'sequel'
require 'json'
require 'rest-client'

# rubocop:disable Lint/RescueWithoutErrorClass
url = begin
  elephantsql = JSON.parse(ENV.fetch('VCAP_SERVICES'))['elephantsql']
  elephantsql.first['credentials']['uri']
rescue
  ENV.fetch('DB_URL')
end

warn "Establishing connection to DB at #{url}"
DB = Sequel.connect(url)

DB.listen(:entry_updates, loop: true) do |_, _, payload|
  warn payload

  RestClient.post(
    ENV.fetch('SSE_URL'),
    msg: payload,
    content_type: 'json',
    accept: 'json'
  )
end
