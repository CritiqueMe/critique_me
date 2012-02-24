init_post_answer_button = ->
  $('.post_answer input').click ->
    qid = $(this).data('question-id')
    $('#answer_q'+qid).dialog
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