
CONTEXT = 'as if written by Daniel Schmachtenberger'

require 'dotenv/load'
require 'markdown_record'
Dir["#{File.dirname(__FILE__)}/models/*.rb"].each do |path|
  require_relative path
end
