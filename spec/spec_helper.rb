load('boot.rb') #FIXME won't load if try load this file not from app root folder

Rake::Task['data:load:industries'].invoke
