init_single_questions = ->
  csrf_token = $('#all_content').data('csrf_token')

#  $('.askq a').click ->
#    dqid = $(this).parent().data("default_question_id")
#    $('#share_dialog').dialog
#      title: "Share Your Question With Friends"
#      resizable: false
#      draggable: true
#      modal: true
#      show: 'fade'
#      hide: 'fade'
#      width: 800
#      height: 550
#      dialogClass: 'share-modal'
#    .html('<img src="/assets/admin/layout/form_spinner.gif" />')
#    $.ajax({
#      type: 'POST',
#      url: 'choose_question/'+dqid,
#      headers: {'X-CSRF-Token': csrf_token},
#      success: (data) ->
#        $('#share_dialog').html(data)
#    })


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

$ ->
  init_single_questions()

  inject_pagination_blurb()
  monitor_category_changer()