init_post_answer_button = ->
  $('#post_answer input').click ->
    $('#answer_dialog').dialog
      title: "Answer a Question"
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 650
      height: 400
      dialogClass: 'share-modal'
    return false

$ ->
  init_post_answer_button()