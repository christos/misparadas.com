class Line < ActiveRecord::Base
  
  has_many :routes, :dependent => :destroy
  
  validates_uniqueness_of :name, :emt_code
    
end
