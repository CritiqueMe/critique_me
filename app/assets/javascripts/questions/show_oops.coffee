show_oops_dialog = (qid) ->
  $('#post_share_dialog').dialog
    title: "Share Your Question With Friends"
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 800
    height: 'auto'
    dialogClass: 'share-modal'

  # initialize oops button and thanks buttons
  $('#oops_button a').click ->
    show_share_dialog(qid)
    $('#contact_form_spinner').hide()
    $('#manual_spinner').hide()
    return false

show_share_dialog = (qid) ->
  $('#post_share_dialog').dialog('close')
  $('#share_dialog').dialog
    title: "Share Your Question With Friends"
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 1000
    height: 650
    dialogClass: 'share-modal'
  .html('<img src="/assets/admin/layout/form_spinner.gif" />')
  $.get '/share/'+qid, (data) ->
    $('#share_dialog').html(data)


$ ->
  default_qid = $('#share_dialog').data('question_id')
  show_oops_dialog(default_qid)

