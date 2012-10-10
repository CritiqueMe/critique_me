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
    $('#contact_form_spinner').hide()
    $('#manual_spinner').hide()
    window.location = '/share_question/'+qid
    return false



$ ->
  default_qid = $('#share_dialog').data('question_id')
  show_oops_dialog(default_qid)

