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
  $('.qform form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#dlg_content').hide()
    $('#post_answer_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    # hide answer dialog
    $(this).parent().parent().parent().dialog('close')

    if $('#canned_questions').length > 0
      # show canned questions
      $('#canned_questions').dialog
        title: "Answer fun questions about your friends and find out what they said about you."
        resizable: false
        draggable: true
        modal: true
        show: 'fade'
        hide: 'fade'
        width: 800
        height: 440
        position: 'center'
        dialogClass: 'share-modal'
    else
      # show answer posted dialog
      $('#answer_posted_dialog').dialog
        title: "Answer Posted"
        resizable: false
        draggable: true
        modal: true
        show: 'fade'
        hide: 'fade'
        width: 400
        height: 200
        dialogClass: 'share-modal'
  )
  return false

init_flag_question_button = ->
  $('.dlg_flagger a').click ->
    answer_dlg = $(this).parent().parent().parent().parent().find('.answer_dialog')
    qid = answer_dlg.data('question_id')
    answer_dlg.dialog('close')
    $('#flag_dlg_'+qid).dialog("open")

    return false



$ ->
  default_qid = $('#share_dialog').data('question_id')
  show_answer_dialog(default_qid)
  init_flag_question_button()