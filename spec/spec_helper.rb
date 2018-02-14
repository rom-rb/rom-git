# encoding: utf-8

if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.3.1'
  require "simplecov"
  SimpleCov.start
end

require 'rom-git'

begin
  require 'byebug'
rescue LoadError
end

root = Pathname(__FILE__).dirname

Dir[root.join('shared/*.rb').to_s].each { |f| require f }
