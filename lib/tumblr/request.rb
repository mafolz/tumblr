class Tumblr
  class Request
    
    # a GET request to http://[YOURUSERNAME].tumblr.com/api/read
    def self.read(options = {})        
        options[:base_uri] = "http://#{Tumblr::blog}"
        response = HTTParty.get("/api/read", options)
      return response unless raise_errors(response)
    end
    
    # a POST request to http://www.tumblr.com/api/write
    def self.write(options = {})
      response = HTTParty.post('/api/write', :query => options, :base_uri => "http://www.tumblr.com")
      return(response) unless raise_errors(response)
    end
    
    # a POST request to http://www.tumblr.com/api/delete
    def self.delete(options = {})
      response = HTTParty.post('/api/delete', :query => options, :base_uri => "http://www.tumblr.com")
      return(response) unless raise_errors(response)
    end
    
    # a POST request to http://www.tumblr.com/api/authenticate
    def self.authenticate(email, password)
      HTTParty.post('/api/authenticate', :query => {:email => email, :password => password}, :base_uri => "http://www.tumblr.com")
    end
    
    # raise tumblr response errors.
    def self.raise_errors(response)
      if(response.is_a?(Hash))
        message = "#{response[:code]}: #{response[:body]}"
        code = response[:code].to_i
      else
        message = "#{response.code}: #{response.body}"
        code = response.code.to_i
      end
      
      case code
        when 403
          raise(Forbidden.new, message)
        when 400
          raise(BadRequest.new, message)
        when 404
          raise(NotFound.new, message)
        when 201
          return false
      end        
    end
    
  end
end
