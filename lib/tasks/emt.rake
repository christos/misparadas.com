namespace :emt do

  desc 'Reset ALL database data'
  task :reset_db => :environment do
    Location.delete_all
    Line.delete_all
    Route.delete_all
    Stop.delete_all
  end

  desc 'Import Lines from GetListLines.xml'
  task :import_lines => :environment do
    today =  Date.today.strftime('%d/%m/%Y')
    url = URI.parse(AppConfig.urls.lines % today)
    # Line, Label, NameA, NameB

    puts "-"*80
    puts "Importing Lines from: #{url}"
    doc = Hpricot.XML(Net::HTTP.get(url))
    (doc/:REG).each do |element|
      # ignore lines EMT
      next if (element/:Label).inner_html == "EMT"
      attrs = {
        :emt_code => (element/:Line).inner_html.to_i,
        :name => (element/:Label).inner_html.strip,
        :terminal_a => (element/:NameA).inner_html.strip,
        :terminal_b => (element/:NameB).inner_html.strip
      }
      line = Line.find_or_create_by_emt_code(attrs[:emt_code])
      line.update_attributes(attrs)
      puts "\tLine #{line.name} (#{line.emt_code}): #{line.terminal_a} -> #{line.terminal_b}"
    end
    puts "Imported #{Line.count} lines."

  end

  desc 'Import Locations from GetNodeLines.xml'
  task :import_locations => :environment do
    today =  Date.today.strftime('%d/%m/%Y')

    url = URI.parse(AppConfig.urls.locations % today)

    # Node/emt_code, Name
    puts "-"*80
    puts "Importing Locations from: #{url}"
    doc = Hpricot.XML(Net::HTTP.get(url))
    (doc/:REG).each do |element|
      # ignore lines EMT
      # next if (line/:Label).inner_html == "EMT"
      attrs = {
        :emt_code => (element/:Node).inner_html,
        :name => (element/:Name).inner_html.strip
      }
      location = Location.find_or_create_by_emt_code(attrs[:emt_code])
      location.update_attributes(attrs)
      puts "\tLocation #{location.emt_code}-#{location.name}"
    end
    puts "Imported #{Location.count} locations."
  end

  desc 'Import Locations coordinates from emt.sqlite'
  task :import_location_coordinates => :environment do
    require 'sqlite3'

    db = SQLite3::Database.new(File.join(Rails.root, 'db', 'emt.sqlite'))
    rows = db.execute("select * from BUSSTOP")

    puts "-"*80
    puts "Importing Location coordinates for #{rows.size} entries"
    # lat, lng
    rows.each do |row|
      begin
        location = Location.find_by_emt_code!(row[0].to_s)
        location.update_attributes(:lat => row[2].to_f, :lng => row[3].to_f)
      rescue
        puts "#{$!}"
        puts "\t #{row.inspect}:"
      end
    end

  end

  desc 'Import Stops from GetRouteLines.xml'
  task :import_stops => :environment do
    today =  Date.today.strftime('%d/%m/%Y')

    puts "-"*80


    Line.all.each do |line|
      url = URI.parse(AppConfig.urls.routes % [today, line.emt_code])
      puts "Importing Line #{line.emt_code} from: #{url}"

      doc = Hpricot.XML(Net::HTTP.get(url))

      begin
        (doc/:REG).each_with_index do |section, i|
          direction = ((section/:SecDetail).inner_html.to_i) == 10 ? 'normal' : 'reverse'

          line = Line.find_by_emt_code!((section/:Line).inner_html.to_i)
          location = Location.find_by_emt_code!((section/:Node).inner_html.to_i)

          route = line.routes.find_or_create_by_direction(direction)
          stop = route.stops.find_or_create_by_location_id(location.id)
          stop.update_attributes(:total_distance => (section/:Distance).inner_html.to_i, 
          :prev_distance => (section/:DistStopPrev).inner_html.to_i )
        end
      rescue
        puts "#{$!}"
      end

    end
  end

  desc 'Remove unused Locations/Routes/Stops'
  task :cleanup => :environment do
    
    Location.find_each do |location|
      if location.routes.empty?
        puts "\t Routeless location #{location.emt_code}-#{location.name} - DELETE"
      elsif location.lat.blank? && location.lng.blank?
        puts "\t Unlocatable Location #{location.emt_code}-#{location.name} - DELETE"
      end
    end
  end
  
end
