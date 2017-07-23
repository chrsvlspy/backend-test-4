# frozen_string_literal: true
module CallsHelper
  def direction_and_date(call)
    reception_date = call.updated_at.strftime('%e %b %Y at %H:%M%P')
    message = "One of your team members %s a call on #{reception_date}"
    if call.outbound?
      message % 'initiated'
    elsif call.inbound?
      message % 'received'
    else
      'Could not determine call direction'
    end
  end

  def duration(call)
    if call.status.completed?
      Time.at(call.duration).utc.strftime('%H:%M:%S')
    else
      '-'
    end
  end

  def link_to_voicemail(call)
    link_to("The caller left a voicemail (#{call.voicemail_duration} seconds)", call.voicemail_file_url, target: '_blank')
  end
end