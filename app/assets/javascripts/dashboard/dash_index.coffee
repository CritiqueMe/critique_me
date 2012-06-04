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

$ ->
  inject_pagination_blurb()