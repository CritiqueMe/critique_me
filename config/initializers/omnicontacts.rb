require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "777788312346.apps.googleusercontent.com", "rVzZwaJi31mc99u9qWAakEfl"#, :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"
  importer :yahoo, "dj0yJmk9enZSN3o5c0s1aUxhJmQ9WVdrOU9XaEZZVXBHTnpJbWNHbzlNVGd5T1RrNU5EYzJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD0yZg--", "3da1c0e187dd2c0a8bf53dbb9bd5dc0a56844b31"
  importer :hotmail, "00000000480CEB56", "es5nH-tNAIpHr59IDXXPozQchSi3gpbL"
end