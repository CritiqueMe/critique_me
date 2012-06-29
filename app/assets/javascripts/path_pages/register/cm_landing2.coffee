reset_leftest_rightest = ->
  i = 0
  $('#table_wrap table td').each ->
    i++
    if i == 1
      $(this).addClass('leftest')
    else if i == 3
      $(this).addClass('rightest')

autoscroller = null

autoscroll_recent_questions = ->
  num_cells = $('#table_wrap table td').length
  $('#table_wrap').animate {scrollLeft:$('#table_wrap').width()}, 2000, ->
    # remove first three questions and append them to the end
    num = 4
    while num -= 1
      table = $('#table_wrap table')
      #new_width = table.width()+350
      #table.width(new_width)
      orig = table.find('td').first()
      orig.removeClass('leftest').removeClass('rightest')  # we don't want these classes to be cloned
      orig.clone().appendTo(table.find('tbody tr'))
      orig.remove()

    reset_leftest_rightest()
    $('#table_wrap').scrollLeft(0)  # scroll it back to the left, now that the td's are removed

    callback = ->
      autoscroll_recent_questions()
    autoscroller = setTimeout callback, 5000

init_button = ->
  $('#continue img').mouseover ->
    $(this).attr 'src', '/assets/path/sign_in_with_fb_over.png'
  .mouseout ->
    $(this).attr 'src', '/assets/path/sign_in_with_fb.png'

resize_cm_content = ->
  window_height = $(window).height()
  html_height = $('html').height()
  if window_height > html_height
    total_height = window_height
  else
    total_height = html_height
  #console.log "*** window_height: " + window_height + " -- html_height: " + html_height + " -- total_height: " + total_height
  header_height = $('#header').height()
  footer_height = $('#footer').height()
  $('.cm_content').height total_height - header_height - footer_height

$ ->
  resize_cm_content()
  $(window).resize ->
    resize_cm_content()

  init_button()
  autoscroller = setTimeout autoscroll_recent_questions, 5000