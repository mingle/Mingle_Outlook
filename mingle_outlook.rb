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
                           :address              => '<your_smtp_address>',  #'smtp.live.com'
                           :port                 => <smtp_port>,            # port = 25 or 587
                           :domain               => '<your_domain>',
                           :user_name            => '<your_email_id@domain.com>',
                           :password             => '<your_password>',
                           :authentication       => :login,
                           :enable_starttls_auto => true  
                           }


 retriever_method :imap, { :address    => '<your_imap_address>',           #'imap-mail.outlook.com'
                          :port       => <imap_port>,                     # port = 993
                          :user_name  => '<your_email_id@domain.com>',
                          :password   => '<your_password>',
                          :enable_ssl => true    }
end



emails = Mail.find(keys: ['NOT','SEEN','FROM','<user_email_ID>'])





URL = 'https://<your_instance_name>.mingle-api.thoughtworks.com/api/v2/projects/<project_name>/cards.xml'
OPTIONS = {:access_key_id => '<access key>', :access_secret_key => '<secret key>'}

emails.each do |email|
	PARAMS = { 
	  :card => { 
	    :card_type_name => "<card_type>", :name => email.subject, :description => email.body.decoded
	    }
	  }

	http_post(URL, PARAMS, OPTIONS)
end
