# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def google_map(lat, lng, opts = {})
    opts.reverse_merge!({
      :center => "#{lat},#{lng}",
      :zoom => "16",
      :markers => "size:small|color:black|#{lat},#{lng}",
      :size => "378x200",
      :sensor => "false"
    })
    (wd, ht) = opts[:size].split('x')
    image_tag("http://maps.google.com/maps/api/staticmap?" + opts.map{|k,v| k.to_s+"="+v}.join('&'),
      :width => wd, :height => ht)
  end

  def map_with_markers(origin, markers)
    map = GoogleMap::Map.new
    map.controls = []
    map.center = GoogleMap::Point.new(origin.split(',').first, origin.split(',').last)
    map.zoom = 16
    markers.each do |m|
      map.markers << GoogleMap::Marker.new (
      :map => map,
                                           :lat => m[:lat],
                                           :lng => m[:lng],
                                           :html => "#{m[:label]}",
                                           :icon => GoogleMap::Icon.new(:map => map, 
                                                          :image_url => "http://dl.dropbox.com/u/31017/bus.png",
                                                          :width => 22, :height => 22, :shadow_url => nil
                                                          )
                        
      )
    end
    map
  end
  
  def fifteen_minutes_of_fame
    [
      '<a href="http://fernando.blat.es/">Fernando Blat</a>',
      '<a href="http://samlown.com">Sam Lown</a>',
      '<a href="http://blog.duopixel.com/">Mark MacKay</a>',
      '<a href="http://42linesofcode.com/">Christos Zisopoulos</a>'
    ].sort_by{rand}.to_sentence(:last_word_connector => ' y ')
  end
end
