class Stop < ActiveRecord::Base
  belongs_to :route
  belongs_to :location

  def end_of_route?
    route.stops.last == self
  end
  
end
