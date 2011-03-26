class LocationsController < ApplicationController

  def index
    if params[:slug].present?
      session[:slug] = params[:slug]
    end
    
    if session[:slug].present? && params[:slug].blank? && params[:q].blank?
      redirect_to slug_path(:slug => session[:slug])
    end
    
    @choices = session[:slug] && Choice.find_all_by_slug(session[:slug], :include => :location) || []
    @choices_by_location = @choices.group_by{|choice| choice.location}
    
    if @choices.empty?
      session[:slug] = nil
    end

    if params[:q].present?
        args = interpret_search_params(params)
        @locations = Location.find(:all, args)
        @origin = args[:origin] || [@locations.first.lat, @locations.first.lng].join(',')
        @markers = @locations.collect {|l| {:lat => l.lat, :lng => l.lng, :label => l.emt_code}}
    else      
      @locations = []
      @markers = []
      @origin = ""
      flash[:alert] = "Debes de indicar una dirección física. Por ejemplo: Paseo Recoletos"
    end

    @show_intro = @choices.empty? && @locations.empty?

  end

  def arrivals
    @location = Location.find(params[:id])
    respond_to do |wants|
      wants.json {  render :json => @location.route_arrivals.to_json }
    end
  end

  private
    def interpret_search_params(params)
      if params[:q] =~ /^\s*\d{1,4}\s*$/
        return { :conditions => { :emt_code => params[:q].strip } }
      else
        return :origin => geocode(parsed_address(params[:q])), :within => 0.25, :order => 'distance ASC'
      end
    end
    
    def parsed_address(address)
      address.strip!
      if address =~ /(.*)\s*,\s*Madrid\s*/i
        address
      else
        "#{address}, Madrid"
      end
    end
    
    def geocode(address)
      url = URI.parse("http://maps.google.com/maps/api/geocode/json?address=#{CGI.escape(address)}&sensor=false")
      req = Net::HTTP::Get.new(url.request_uri)
      res = Net::HTTP.start(url.host, url.port){ |http| http.request(req) }
      json_googlemaps = ActiveSupport::JSON.decode(res.body)
      lon = json_googlemaps['results'][0]['geometry']['location']['lng']
      lat = json_googlemaps['results'][0]['geometry']['location']['lat']
      [lat, lon]
    end
end
