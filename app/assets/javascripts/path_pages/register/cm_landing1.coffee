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

continuous_left_scroll = ->
  $('#table_wrap').animate {scrollLeft: "-=20"}, 100, continuous_left_scroll
continuous_right_scroll = ->
  $('#table_wrap').animate {scrollLeft: "+=20"}, 100, continuous_right_scroll
stop_continuous_scroll = ->
  $('#table_wrap').stop()

init_arrows = ->
  $('#left_arrow').mousedown ->
    clearTimeout(autoscroller)
    stop_continuous_scroll()
    continuous_left_scroll()
  .mouseup ->
    stop_continuous_scroll()
    return false

  $('#right_arrow').mousedown ->
    clearTimeout(autoscroller)
    stop_continuous_scroll()
    continuous_right_scroll()
  .mouseup ->
    stop_continuous_scroll()
    return false

init_button = ->
  $('#continue img').mouseover ->
    $(this).attr 'src', '/assets/path/sign_up_its_free_over.png'
  .mouseout ->
    $(this).attr 'src', '/assets/path/sign_up_its_free.png'

$ ->
  init_button()
  autoscroller = setTimeout autoscroll_recent_questions, 5000
  init_arrows()