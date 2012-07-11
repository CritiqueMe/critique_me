inject_pagination_blurb = ->
  curr_page = $('#dashtable').data('page')
  num_qs = $('#dashtable').data('num_questions')
  per_page = $('#dashtable').data('per_page')
  actually_on_page = $('#dashtable tbody tr').length

  start = (curr_page-1) * per_page + 1
  end = start + actually_on_page - 1
  str = "Results " + start + "-" + end + " of " + num_qs

  new_span = $('<span class="curr_page">').html(str)
  new_span.insertAfter $('#dashtable .pagination .previous_page')

init_mouseovers = ->
  $('#dashtable .invite_friends a').mouseover ->
    $(this).find('img').attr('src', '/assets/questions/invite_friends_button_over.png')
  .mouseout ->
    $(this).find('img').attr('src', '/assets/questions/invite_friends_button.png')

  $('#dashtable .see_answers a').mouseover ->
    $(this).find('img').attr('src', '/assets/questions/see_answers_button_over.png')
  .mouseout ->
    $(this).find('img').attr('src', '/assets/questions/see_answers_button.png')

$ ->
  inject_pagination_blurb()
  init_mouseovers()