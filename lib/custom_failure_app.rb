 class CustomFailureApp < Devise::FailureApp
    def redirect_url
       new_user_session_url(:subdomain => 'secure')
    end

    # You need to override respond to eliminate recall
    def respond
      if http_auth?
        http_auth
      else
        if request.format == 'application/json'
          self.status = 401 
          self.content_type = 'json'
          self.response_body = {error: I18n.t('devise.failure.inactive')}.to_json
        else
          redirect          
        end
      end
    end
  end