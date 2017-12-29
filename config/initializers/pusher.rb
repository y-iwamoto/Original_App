require 'pusher'

Pusher.app_id = ENV['PUSHER_API_ID']
Pusher.key = ENV['PUSHER_ACCESS_KEY']
Pusher.secret = ENV['PUSHER_ACCESS_KEY_SECRET']
Pusher.cluster = ENV['PUSHER_API_CLUSTER']
Pusher.logger = Rails.logger
Pusher.encrypted = true
