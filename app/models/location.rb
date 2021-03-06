class Location < ActiveRecord::Base

  has_many :stops, :dependent => :destroy
  has_many :routes, :through => :stops

  acts_as_mappable  :default_units => :kms

  def route_arrivals
    url = URI.parse(AppConfig.urls.arrivals % emt_code)

    string = Net::HTTP.get(url).strip_tags
    
    pairs = string.scan(/L\s([^:]+):([^,]+)'?/)
    arrivals = {}
    routes.each do |route|
      arrivals[route.line.name] = transform_response(pairs.assoc(route.line.name).try(:last).try(:strip) || 'no disponible')
    end
    arrivals
  end

  def search
    
  end
  
  private

    # Ent.Par. => Lllegando
    # \d.+ min. => Llega en
    # Autobus entorno parada. => Llegando
    # sup. \d+ min. =>
    def transform_response(response)
      puts "#{response}"
      response.gsub!('Autobus entorno parada.', 'Llegando...')
      response.gsub!('Ent.Par', 'Llegando...')
      response.gsub!(/sup\.\s(\d+)'/, 'Llega en más de \1\'')
      response
    end
end
