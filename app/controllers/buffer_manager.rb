require 'kafka_manager'

class BufferManager
  def self.put_in_buffer(message)
    KafkaManager.put_in_kafka(message)
  end
end