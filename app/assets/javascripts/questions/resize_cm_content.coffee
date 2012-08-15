resize_cm_content = ->
  window_height = $(window).height()
  html_height = $('html').height()
  header_height = $('#header').height()
  footer_height = $('#footer').height()
  cm_content_height = $('.cm_content').height() + header_height + footer_height + 25
  if window_height > cm_content_height
    total_height = window_height
  else
    total_height = html_height
  if cm_content_height > window_height
    $('.container').height(cm_content_height)
  else
    $('.container').height(total_height)
  #console.log "*** window_height: " + window_height + " -- html_height: " + html_height + " -- total_height: " + total_height + " -- heider_height: " + header_height + " -- footer_height: " + footer_height
  $('.grad_bg').height total_height #- header_height # - footer_height

do_resize = ->
  $(window).resize()

$ ->
  resize_cm_content()
  $(window).resize ->
    resize_cm_content()
  setInterval do_resize, 3000