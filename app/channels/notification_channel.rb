class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'hoge'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def display(data)
    # 更新処理
    current_user.update_solved_problems(data['email'], data['password'])
    ActionCable.server.broadcast 'hoge', status: 'success'
  end
end
