require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "24514668274.apps.googleusercontent.com", "479blV5OlkOIzF3ISuJ8_JNZ"#, :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"
  importer :yahoo, "dj0yJmk9dnN6c0ZRUWFXend2JmQ9WVdrOU1FTnhkM040TkRRbWNHbzlNVEk1TURjd05USTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD05ZQ--", "86c1af023b5d937eeb1e28177fb74a91a1514f76"
  importer :hotmail, "00000000480CF256", "G8l-H3FlFheKMAjmxVBVeLlEEmIdhWZB"
end