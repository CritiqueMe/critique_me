init_cheating_dialog = ->
  $('#cheating_dlg').dialog
    title: ""
    resizable: false
    draggable: false
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 870
    height: 500
    closeOnEscape: false
    dialogClass: 'cheating_dlg'

resize_cm_content = ->
  window_height = $(window).height()
  html_height = $('html').height()
  if window_height > html_height
    total_height = window_height
  else
    total_height = html_height
  landing_page_height = $('#landing_page').height()
  header_height = $('#header').height()
  footer_height = $('#footer').height()
  if landing_page_height > window_height
    $('.container').height(landing_page_height + header_height + footer_height + 30)
  else
    $('.container').height(total_height)
  #console.log "*** window_height: " + window_height + " -- html_height: " + html_height + " -- total_height: " + total_height + " -- heider_height: " + header_height + " -- footer_height: " + footer_height
  $('.cm_content').height total_height - header_height - footer_height

$ ->
  init_cheating_dialog()

  resize_cm_content()
  $(window).resize ->
    resize_cm_content()