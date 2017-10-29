# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require 'sse_server'

describe 'SSE Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'has a root page' do
    get '/'
    expect(last_response).to be_ok
  end
end
