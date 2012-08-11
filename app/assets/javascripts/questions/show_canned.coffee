send_to_create_question_page = ->
  window.location = "/choose_question"

pop_canned_questions_dialog = ->
  $('#canned_questions').dialog
    title: "Answer fun questions about your friends and find out what they said about you."
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 800
    height: 'auto'
    position: 'center'
    dialogClass: 'share-modal'
    close: send_to_create_question_page
  $('#canned_questions').delay(500).queue ->
    $(this).dialog('option', 'position', 'center')


$ ->
  pop_canned_questions_dialog()