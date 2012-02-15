show_share_dialog = ->
  qid = $('#share_dialog').data('question_id')
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
  show_share_dialog()
  $('#share_question').click ->
    show_share_dialog()
    return false