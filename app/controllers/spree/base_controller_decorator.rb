Spree::BaseController.class_eval do
  def store_location
    # disallow return to login, logout, signup pages
    disallowed_urls = [spree.signup_url, spree.login_url, spree.destroy_user_session_path]
    disallowed_urls.map!{ |url| url[/\/\w+$/] }
    unless disallowed_urls.include?(request.fullpath)
      session['user_return_to'] = request.fullpath.gsub('//', '/')
    end
  end
end
