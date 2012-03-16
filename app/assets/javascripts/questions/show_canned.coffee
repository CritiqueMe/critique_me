pop_canned_questions_dialog = ->
  $('#canned_questions').dialog
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 800
    height: 500
    position: 'center'
    dialogClass: 'share-modal'


$ ->
  pop_canned_questions_dialog()