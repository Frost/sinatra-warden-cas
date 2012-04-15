module App
  class Sessions < Sinatra::Base
    enable :logging 

    get "/cas" do
      env["warden"].login
    end

    %w[get post].each do |method|
      self.send(method, "/cas/callback") do
        puts request.env["omniauth.auth"].inspect

        ugid = request.env["omniauth.auth"]["uid"]
        user = User.find_or_create_from_cas(ugid)
        env["warden"].set_user user

        redirect "/"
      end
    end
    # get "/cas/callback" do
    # end

    get "/failure" do
      "fail"
    end

    delete "/logout" do
      env["warden"].logout
      redirect "/"
    end
  end
end
