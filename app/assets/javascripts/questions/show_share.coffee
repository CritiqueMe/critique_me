show_share_dialog = (qid) ->
  $('#share_dialog').dialog
    title: "Share Your Question With Friends"
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 800
    height: 500
    dialogClass: 'share-modal'
  .html('<img src="/assets/admin/layout/form_spinner.gif" />')
  $.get '/share/'+qid, (data) ->
    $('#share_dialog').html(data)



$ ->
  $('#not_enough_answers a').click ->
    qid = $(this).parent().data('question_id')
    show_share_dialog(qid)
  $('.share_question').click ->
    qid = $(this).data('question_id')
    show_share_dialog(qid)
    return false