class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'hoge'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def display(data)
    ActionCable.server.broadcast 'hoge', email: data['email'], password: data['password']
  end
end
