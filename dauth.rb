require 'sinatra/base'
require 'warden'
require 'omniauth-cas'
require 'sequel'
require 'sqlite3'
require 'slim'
require 'clogger'

# setup an in-memory sqlite database
DB = Sequel.sqlite
DB.create_table? :users do
  primary_key :id
  String :ugid
end

require_relative 'app.rb'

builder = Rack::Builder.new do
  use Clogger
  use Rack::MethodOverride
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :cas, :host => "login.kth.se", :ssl => true
  end

  Warden::Manager.serialize_into_session {|user| user.id }
  Warden::Manager.serialize_from_session {|id| User[id] }

  use Warden::Manager do |manager|
    manager.failure_app = self
  end

  map "/auth" do
    run App::Sessions
  end

  map "/" do
    run App::Main
  end
end

Rack::Handler::Thin.run builder
