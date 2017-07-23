# frozen_string_literal: true
class Twilio::WebhooksController < ApplicationController
  include TwilioParams

  CONNECT_TO_AGENT_KEY = '1'
  LEAVE_VOICEMAIL_KEY = '2'
  AUTHORIZER_CONNECTION_KEYS = [CONNECT_TO_AGENT_KEY, LEAVE_VOICEMAIL_KEY].freeze

  def connect_to_agent_request
    Call.create(webhook_params)
    gather = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Hi there')
      r.gather(
        numDigits: CONNECT_TO_AGENT_KEY,
        action: connect_to_agent_twilio_webhooks_path,
        method: 'get') do |connect_gather|
        connect_gather.say("To connect to an agent, press #{CONNECT_TO_AGENT_KEY}.")
        connect_gather.say("To leave a voicemail, press #{LEAVE_VOICEMAIL_KEY}.")
      end
    end
    render xml: gather.to_s
  end

  TESTING_NUMBER = '+33123456789'
  def connect_to_agent
    pressed_digit = params['Digits']
    unless AUTHORIZER_CONNECTION_KEYS.include?(pressed_digit)
      return redirect_to connect_to_agent_twilio_webhooks_path
    end
    call_from_sid.update_attributes(status: Call::IN_PROGRESS_STATUS)
    connect = if pressed_digit == CONNECT_TO_AGENT_KEY
                Twilio::TwiML::VoiceResponse.new do |r|
                  r.dial(number: TESTING_NUMBER)
                  r.say('The call failed or the remote party hung up. Goodbye.')
                end
              else
                Twilio::TwiML::VoiceResponse.new do |r|
                  r.say('You may now leave a 30 second message after the tone.')
                  r.record(max_length: '30', action: record_voicemail_twilio_webhooks_path, method: 'get')
                end
              end
    render xml: connect.to_s
  end

  def record_voicemail
    call_from_sid.update_attributes(
      voicemail_file_url: webhook_params.fetch(:voicemail_file_url),
      voicemail_duration: webhook_params.fetch(:voicemail_duration)
    )
    head :ok
  end

  def call_status
    call_from_sid.update_attributes(
      status: webhook_params.fetch(:status),
      duration: webhook_params.fetch(:duration)
    )
    head :ok
  end

  private

  def call_from_sid
    Call.find_by(sid: webhook_params.fetch(:sid))
  end
end
