module App
  class Main < Sinatra::Base
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do

      @user = env["warden"].user
      slim "| hejsan #{@user}"
    end
  end
end

