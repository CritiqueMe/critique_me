show_answer_dialog = (qid) ->
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
  default_qid = $('#share_dialog').data('question_id')
  show_answer_dialog(default_qid)