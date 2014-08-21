require 'buffer_manager.rb'

RaRbBuffer.controllers :buffer do
  post '/' do
    if !ENABLE_ET
      RaslLogger.info 'Disabled buffering. Ignoring events.'
      return "{\"message\":\"Success\"}"
    end

    begin
      message = Message.new(JSON.parse(request.body.read.to_s))
      BufferManager.put_in_buffer(message)
      return "{\"message\":\"Success\"}"
    rescue NameError => e
      RaslLogger.error "Not processing event: #{message.message}, due to: #{e.inspect}"
      raise e
    end
  end
end