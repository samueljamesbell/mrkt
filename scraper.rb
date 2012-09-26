require 'rubygems'
require 'java'

Dir[File.dirname(__FILE__) + '/lib/*.jar'].each {|jar| require jar}

java_import 'com.bloomberglp.blpapi.Session'
java_import 'com.bloomberglp.blpapi.SessionOptions'

session = Session.new SessionOptions.new
if !session.start
    puts "Could not start session"
    exit
end
if !session.openService "//blp/refdata"
    puts "Could not start service " + "//blp/refdata"
end
