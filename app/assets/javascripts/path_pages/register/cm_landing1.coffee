autoscroll_recent_questions = (dir='right') ->
  num_cells = $('#table_wrap table td').length
  if dir == 'left'
    $('#table_wrap').animate {scrollLeft:0}, num_cells*700, ->
      callback = ->
        autoscroll_recent_questions('right')
      setTimeout callback, 2000
  else
    right_scroll_amount = $('#table_wrap table').width() - $('#table_wrap').width()
    $('#table_wrap').animate {scrollLeft:right_scroll_amount}, num_cells*700, ->
      callback = ->
        autoscroll_recent_questions('left')
      setTimeout callback, 2000


$ ->
  $('#continue img').mouseover ->
    $(this).attr 'src', '/assets/path/sign_up_its_free_over.png'
  .mouseout ->
    $(this).attr 'src', '/assets/path/sign_up_its_free.png'

  setTimeout autoscroll_recent_questions, 3000