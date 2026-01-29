# frozen_string_literal: true

module FeedsHelper
  # Escape special characters for iCal format (RFC 5545)
  def ical_escape(text)
    return "" if text.blank?
    
    text.to_s
        .gsub("\\", "\\\\")
        .gsub(",", "\\,")
        .gsub(";", "\\;")
        .gsub("\n", "\\n")
        .gsub("\r", "")
  end

  # Render event description for RSS feed
  def render_event_description(event)
    parts = []
    
    # Date and time
    parts << "<p><strong>📅 #{l(event.starts_at, format: :long)}</strong></p>"
    
    # Location
    if event.location
      location_text = [event.location.name, event.location.street, "#{event.location.zip} #{event.location.city.name}"].join(", ")
      parts << "<p><strong>📍 #{h(location_text)}</strong></p>"
    end
    
    # Category
    parts << "<p><em>#{h(event.category.name)}</em></p>" if event.category
    
    # Description
    parts << "<p>#{simple_format(h(event.description.to_s.truncate(500)))}</p>" if event.description.present?
    
    parts.join("\n")
  end
end
