require 'mechanize'
require 'elasticsearch'
require 'elasticsearch/model'
require 'elasticsearch/persistence'
require 'singleton'
require 'rake'
require 'stuff-classifier'
require 'byebug' #TODO move to development/test mode

Dir[File.dirname(__FILE__) + '/lib/helpers/*rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/lib/*rb'].each { |file| require file }

load './Rakefile.rb'

