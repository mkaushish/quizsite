### config/initializers/omniauth.rb ###
 
OmniAuth.config.full_host = "http://localhost:3000"
 
Rails.application.config.middleware.use OmniAuth::Builder do
	# OAuth 2.0 result, # Access token starts with ya29.xxxx
 	# get it from https://code.google.com/apis/console/
 	# See https://github.com/zquestz/omniauth-google-oauth2/issues/20
 	# This explain OAuth2 for Google. Note, OAuth, does not return token_secret.
 	#     Provider                 Uid Access        Token                   Secret
 	#    google_oauth2   102425343454127939656   ya29.<rest of the stuff>    <none>
 	provider :google_oauth2, '346830066121-c81ldbv7pgu5fhmj7fep69lo1tk3sfo5.apps.googleusercontent.com', 'pLFG-O495oPMFTGNuPsHpigA'
end