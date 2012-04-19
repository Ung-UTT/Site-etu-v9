Dir["#{Rails.root}/lib/**/*.rb"].each do |library|
  require_dependency library
end
