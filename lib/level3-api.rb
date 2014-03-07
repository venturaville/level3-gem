#!/usr/bin/ruby

require 'hmac-sha1'
require 'rest-client'
require 'base64'
require 'xmlsimple'

# --TODO use nokogiri w/ xsi?

class Level3Api
  # key_id = Level 3 API Key
  # secret = Level 3 API Secret
  def initialize(key_id,secret)
    @api_url_base = "https://ws.level3.com"
    @key_id = key_id # required
    @secret = secret # required
    raise 'No key_id' unless @key_id
    raise 'No secret' unless @secret
    @content_type = 'text/xml'
  end
  # Time is only considered valid for authentication for 15 minutes on level3... 
  # We reset it once each pass just to make sure it does not expire
  def set_date
    @current_date = Time.now
  end
  def formatted_date
    return @current_date.gmtime.strftime("%a, %d %b %Y %H:%M:%S GMT") 
  end
  def generate_auth_string(service,resource,method)
    authstring = "%s\n%s%s\n%s\n%s\n" % [
      formatted_date,
      service.chomp('/'),
      resource.chomp('/'),
      @content_type,
      method
    ]
    hmac = HMAC::SHA1.new(@secret)
    hmac.update(authstring)
    return "MPA %s:%s" % [@key_id, Base64.encode64(hmac.digest)]
  end
  # Attempt to mash XML into a parseable ruby structure
  def _from_xml(xml)
    return XmlSimple.xml_in(xml, {
      'ForceArray'=>['accessGroup'],
      'GroupTags'=>{
        'services'=>'service',
        'metros'=>'metro',
        'networkIdentifiers'=>'ni'
      },
      'KeyAttr'=>['id','name']
    })
  end
  def request(service="/accessGroups",resource="/v1.0",method="GET",params={})
    set_date
    authstr = generate_auth_string(service,resource,method)
    url = "#{@api_url_base}#{service}#{resource}"
    puts "request: url=#{url}"
    xml = RestClient.get url,
      :content_type => @content_type,
      :authorization => authstr,
      :date => formatted_date,
      :verify_ssl => OpenSSL::SSL::VERIFY_PEER,
      :params => params
    return _from_xml(xml)
  end

end

