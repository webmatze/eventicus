xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.rss version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Eventicus - #{@category.name} Events"
    xml.description "Upcoming #{@category.name} events"
    xml.link category_url(@category)
    xml.language I18n.locale.to_s
    xml.lastBuildDate @events.first&.updated_at&.to_fs(:rfc822) || Time.current.to_fs(:rfc822)
    xml.tag! "atom:link", href: feeds_category_url(@category.slug, format: :rss), rel: "self", type: "application/rss+xml"

    @events.each do |event|
      xml.item do
        xml.title event.title
        xml.description do
          xml.cdata! render_event_description(event)
        end
        xml.link event_url(event)
        xml.guid event_url(event), isPermaLink: "true"
        xml.pubDate event.created_at.to_fs(:rfc822)
        
        xml.category event.category.name if event.category
        
        if event.cover_image.attached?
          xml.enclosure url: url_for(event.cover_image), type: event.cover_image.content_type, length: event.cover_image.byte_size
        end
      end
    end
  end
end
