# frozen_string_literal: true
# This module cleans the webhooks parameters by converting them to the Call model's attributes
module TwilioParams
  include ActiveSupport::Concern

  private

  def webhook_params
    @converted_params ||= convert_params
  end

  CALL_ATTRIBUTES_MAPPING = {
    From: :from,
    To: :to,
    FromCountry: :from_country,
    ToCountry: :to_country,
    Direction: :direction,
    CallSid: :sid,
    CallStatus: :status,
    RecordingUrl: :voicemail_file_url,
    RecordingDuration: :voicemail_duration,
    CallDuration: :duration
  }.freeze
  def convert_params
    unconverted_params = params.permit(:From, :To, :CallDuration,
                                       :FromCountry, :ToCountry,
                                       :Direction, :CallSid, :CallStatus,
                                       :RecordingUrl, :RecordingDuration)
    CALL_ATTRIBUTES_MAPPING.each do |webhook_key, call_key|
      next if unconverted_params[webhook_key].blank?
      value = unconverted_params.delete(webhook_key)
      unconverted_params[call_key] = value.underscore
    end
    unconverted_params
  end
end
