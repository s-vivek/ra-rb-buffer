require 'poseidon'

class KafkaManager
  def self.put_in_kafka(message)

    puts "partition=#{message.get_partition}"
    partition = Proc.new{message.get_partition}
    producer = Poseidon::Producer.new([BUFFER_APP], CLIENT_NAME, :type => :sync, :partitioner => partition, :required_acks => -1)

    messages = []
    messages << Poseidon::MessageToSend.new(message.get_topic, message.message.to_s)
    producer.send_messages(messages)
    puts "successfully sent message #{message.message.to_s} #{message.get_partition} #{message.get_topic} "
  end
end