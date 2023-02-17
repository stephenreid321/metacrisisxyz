require 'dotenv/load'
require 'markdown_record'
require_relative 'project_constants'
Dir["#{File.dirname(__FILE__)}/models/*.rb"].each do |path|
  require_relative path
end
