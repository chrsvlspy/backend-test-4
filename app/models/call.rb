# frozen_string_literal: true
class Call < ApplicationRecord
  validates_presence_of :from, :to, :from_country, :to_country

  enum status: %i(initiated ringing in_progress answered completed).freeze
  enum direction: %i(inbound outbound).freeze

  IN_PROGRESS_STATUS = 'in_progress'

  def has_voicemail?
    voicemail_file_url.present?
  end
end
