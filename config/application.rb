require File.expand_path('../boot', __FILE__)

class RdioDisplay::App < Sinatra::Base
  set :root, File.expand_path('../../app',  __FILE__)
  set :public_folder, File.expand_path('../../public',  __FILE__)
  set :erb, :layout => :'layouts/application'
  set :sessions, true
  set :session_secret, ENV['SESSION_KEY']

  helpers Sinatra::JSON

  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    LAST_MODIFIED = Time.now

    before do
      cache_control :public, max_age: 86400
      last_modified LAST_MODIFIED
    end
  end
end

require File.expand_path('../../app/app', __FILE__)
