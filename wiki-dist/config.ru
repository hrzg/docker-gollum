require 'rubygems'
require 'gollum/app'
require 'rack'
require 'rack/cache'

### start gollum with `rackup`

set :environment, :production

gollum_path = File.expand_path(File.dirname(__FILE__))
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:base_path, 'wiki')
Precious::App.set(
    :wiki_options,
    {
        :css => true,
        :js => true,
	    :live_preview => false
    }
)


# Add in commit user/email
class Precious::App
    before do
        session['gollum.author'] = {
            :name       => "%s" % [env['HTTP_X_PROXY_REMOTE_USER_NAME']],
            :email      => "%s" % env['HTTP_X_PROXY_REMOTE_USER_MAIL'],
        }
    end
end


# since --base-path does not work with rack
map '/wiki' do
    run Precious::App
end
