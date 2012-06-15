autoscroller = null

autoscroll_recent_questions = ->
  num = 0
  scroll_height = 0
  while num < 5
    scroll_height += $($('#scroll_wrap ol li').get(num)).height() + 20  # extra 20 is for top/bottom padding of 10px
    console.log scroll_height
    num++

  $('#scroll_wrap').animate {scrollTop:scroll_height}, 2000, ->
    # remove first five questions and append them to the end
    num = 6
    while num -= 1
      list = $('#scroll_wrap ol')
      orig = list.find('li').first()
      orig.clone().appendTo(list)
      orig.remove()

    $('#scroll_wrap').scrollTop(0)  # scroll it back to the top, now that the li's are removed

    callback = ->
      autoscroll_recent_questions()
    autoscroller = setTimeout callback, 5000

$ ->
  autoscroller = setTimeout autoscroll_recent_questions, 5000