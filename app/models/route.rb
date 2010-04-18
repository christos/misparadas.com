class Route < ActiveRecord::Base
  has_many :stops
  belongs_to :line

  validates_presence_of :direction, :line_id

  require 'net/http'
  require 'uri'

  def expected_at(location)
    location.route_arrivals(line.name)
  end

end
