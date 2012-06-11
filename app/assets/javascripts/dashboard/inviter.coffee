init_inviter_buttons = ->
  $('.invite_friends a').click ->
    qid = $(this).data("question-id")
    $('#share_dialog').dialog
      title: "Share Your Question With Friends"
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 800
      height: 575
      dialogClass: 'share-modal'
    .html('<img src="/assets/admin/layout/form_spinner.gif" />')
    $.get 'share/'+qid, (data) ->
      $('#share_dialog').html(data)
    return false

$ ->
  init_inviter_buttons()