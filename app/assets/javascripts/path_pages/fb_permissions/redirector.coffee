redirect_to_fb_perms = ->
  window.location = $('#fb_redirect').data('perms_url')

$ ->
  redirect_to_fb_perms()