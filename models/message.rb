require 'digest/md5'
require 'digest'
#require 'md5'

class Message

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def get_partition
    id = message[PARTITION_ID]
    Digest::MD5.hexdigest(id).to_i % PARTITION_COUNT
  end

  def get_topic
    #data[TOPIC_ID]

    #MERGING ALL THE TOPICS IN ONE
    TOPIC_ID
  end
end