class Route < ActiveRecord::Base
  
  has_many :stops, :order => 'total_distance ASC', :dependent => :destroy
  has_many :locations, :through => :stops

  belongs_to :line

  validates_presence_of :direction, :line_id

  def expected_at(location)
    "<span class='expected' id='estimate_route_#{line.name}'>...</span>"
  end
  
  def destination
    direction == 'normal' ? line.terminal_b : line.terminal_a
  end
end
