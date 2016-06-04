require 'sinatra'

set server: 'thin'
set connections: []
set events: []

class Event
  def initialize(msg)
    @msg = msg
    @timestamp = Time.now
  end

  def to_s
    [@timestamp, @msg].join(' ')
  end
end

get '/' do
  markdown(:README,
    layout: true,
    layout_engine: 'erb',
    locals: {
      title: 'pg-sse - Relays Database Updates to an SSE stream',
    },
    input: 'GFM',
  )
end

get '/events' do
  erb :events, layout: true, locals: {
    title: 'Haushaltsbuch - letzte Ereignisse',
    events: settings.events.reverse,
  }
end

get '/stream', provides: 'text/event-stream' do
  warn "New client connecting to stream: #{request.ip} - #{request.user_agent}"
  headers 'Access-Control-Allow-Origin' => '*'

  stream :keep_open do |out|
    settings.connections << out
    out.callback { settings.connections.delete(out) }
  end
end

post '/' do
  msg = params[:msg]

  warn "New message from: #{request.ip}: #{msg}"
  settings.events << Event.new(msg)

  settings.connections.each do |out|
    out << "data: #{msg}\n\n" unless out.closed?
  end

  204 # response without entity body
end
