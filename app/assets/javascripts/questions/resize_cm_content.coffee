resize_cm_content = ->
  window_height = $(window).height()
  html_height = $('html').height()
  if window_height > html_height
    total_height = window_height
  else
    total_height = html_height
  console.log "*** window_height: " + window_height + " -- html_height: " + html_height + " -- total_height: " + total_height
  header_height = $('#header').height()
  footer_height = $('#footer').height()
  $('.grad_bg').height total_height - header_height # - footer_height

$ ->
  resize_cm_content()
  $(window).resize ->
    resize_cm_content()