%w[models app].each do |dir|
  Dir.glob("#{dir}/*").map { |f| require_relative f }
end

