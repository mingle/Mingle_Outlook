require 'mail' 
require 'net/https'
require 'time'
require 'api-auth'
require 'json'

def http_post(url, params, options={})
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true 
  body = params.to_json

  request = Net::HTTP::Post.new(uri.request_uri)
  request.body = body
  request['Content-Type'] = 'application/json'
  request['Content-Length'] = body.bytesize

  ApiAuth.sign!(request, options[:access_key_id], options[:access_secret_key])

  response = http.request(request)
  card = response.body
  
  card 
end

Mail.defaults do
  delivery_method :smtp, { 
                           :address              => '<your_smtp_address>',
                           :port                 => <smtp_port>,
                           :domain               => '<your_domain>',
                           :user_name            => '<your_email_id@domain.com>',
                           :password             => '<your_password>',
                           :authentication       => :login,
                           :enable_starttls_auto => true  
                           }


 retriever_method :imap, { :address    => '<your_imap_address>',
                          :port       => <imap_port>,
                          :user_name  => '<your_email_id@domain.com>',
                          :password   => '<your_password>',
                          :enable_ssl => true    }
end



emails = Mail.find(keys: ['NOT','SEEN','<user_email_ID>'])





URL = 'https://<your_instance_name>.mingle-api.thoughtworks.com/api/v2/projects/<project_name>/cards.xml'
OPTIONS = {:access_key_id => '<access key>', :access_secret_key => '<secret key>'}

emails.each do |email|
	PARAMS = { 
	  :card => { 
	    :type => "Feedback", :name => email.subject, :description => email.body.decoded
	    }
	  }

	http_post(URL, PARAMS, OPTIONS)
end
