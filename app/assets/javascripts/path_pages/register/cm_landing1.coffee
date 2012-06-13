autoscroller = null

autoscroll_recent_questions = (dir='right') ->
  num_cells = $('#table_wrap table td').length
  if dir == 'left'
    $('#table_wrap').animate {scrollLeft:0}, num_cells*700, ->
      callback = ->
        autoscroll_recent_questions('right')
      autoscroller = setTimeout callback, 2000
  else
    right_scroll_amount = $('#table_wrap table').width() - $('#table_wrap').width()
    $('#table_wrap').animate {scrollLeft:right_scroll_amount}, num_cells*700, ->
      callback = ->
        autoscroll_recent_questions('left')
      autoscroller = setTimeout callback, 2000

continuous_left_scroll = ->
  $('#table_wrap').animate {scrollLeft: "-=20"}, 100, continuous_left_scroll
continuous_right_scroll = ->
  $('#table_wrap').animate {scrollLeft: "+=20"}, 100, continuous_right_scroll
stop_continuous_scroll = ->
  $('#table_wrap').stop()

$ ->
  $('#continue img').mouseover ->
    $(this).attr 'src', '/assets/path/sign_up_its_free_over.png'
  .mouseout ->
    $(this).attr 'src', '/assets/path/sign_up_its_free.png'

  autoscroller = setTimeout autoscroll_recent_questions, 3000

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