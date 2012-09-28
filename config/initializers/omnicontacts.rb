require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "24514668274.apps.googleusercontent.com", "479blV5OlkOIzF3ISuJ8_JNZ", :ssl_ca_file => "/etc/ssl/certs/ca-certificates.crt"
  importer :yahoo, "dj0yJmk9REQ2SHdGUXpPSmJPJmQ9WVdrOVoxSlFhbmxNTlRJbWNHbzlNVFl6T0RBNU1qYzJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD0wNA--", "e4f68d7ede1c06dad5e654c97f12b15086dfa683"
end