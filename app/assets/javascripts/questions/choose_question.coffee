inject_pagination_blurb = ->
  curr_page = $('#default_questions').data('page')
  num_qs = $('#default_questions').data('num_questions')
  per_page = $('#default_questions').data('per_page')
  actually_on_page = $('#default_questions tbody tr').length

  start = (curr_page-1) * per_page + 1
  end = start + actually_on_page - 1
  str = "Results " + start + "-" + end + " of " + num_qs

  new_span = $('<span class="curr_page">').html(str)
  new_span.insertAfter $('#default_questions .pagination .previous_page')

monitor_category_changer = ->
  $('#category_id').change ->
    window.location = "/category/" + $(this).val()


init_helper_mouseover = ->
  $('#chooseq_top a').mouseover ->
    $('#chooseq_lightbox').fadeIn()
  .mouseout ->
    $('#chooseq_lightbox').fadeOut()

init_mouseovers = ->
  $('#default_questions .askq a').mouseover ->
    $(this).find('img').attr('src', '/assets/questions/ask_this_question_over.png')
  .mouseout ->
    $(this).find('img').attr('src', '/assets/questions/ask_this_question.png')


$ ->
  init_helper_mouseover()

  inject_pagination_blurb()
  monitor_category_changer()
  init_mouseovers()
