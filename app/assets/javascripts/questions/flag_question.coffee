$ ->
  $('.flag_dlg').dialog
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 600
    height: 300
    title: "Flag Question"
    position: 'center'
    dialogClass: 'share-modal'
    autoOpen: false

  $('.flagger a').click ->
    qid = $(this).data('question')
    $('#flag_dlg_'+qid).dialog('open')
    return false