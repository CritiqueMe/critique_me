init_single_questions = ->
  $('#single_questions li').mouseover () ->
    $(this).addClass("hover")
  .mouseleave () ->
    $(this).removeClass("hover")
  .click () ->
    dqid = $(this).data("default_question_id")
    $('#share_dialog').dialog
      title: "Share Your Question With Friends"
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 500
      height: 500
      dialogClass: 'share-modal'
    .html('<img src="/assets/admin/layout/form_spinner.gif" />')
    $.post 'choose_question/'+dqid, (data) ->
      $('#share_dialog').html(data)

init_questionnaires = ->
  $('#questionnaires li.q').mouseover () ->
    $(this).addClass("hover")
  .mouseleave () ->
    $(this).removeClass("hover")
  .click () ->
    qid = $(this).data("questionnaire_id")
    window.location = "/questionnaire/" + qid



$ ->
  init_single_questions()
  init_questionnaires()