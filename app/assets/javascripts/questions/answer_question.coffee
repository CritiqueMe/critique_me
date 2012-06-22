send_to_create_question_page = ->
  window.location = "/new_question"

init_post_answer_button = ->
  $('.post_answer input').click ->
    t = $('.answer_dialog').data('title')
    qid = $(this).data('question-id')
    $('#answer_q'+qid).dialog
      title: t
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 650
      height: 'auto'
      dialogClass: 'share-modal'
    $('.qform answer').bind("ajax:beforeSend", (evt, xhr, settings) ->
      $('#dlg_content').hide()
      $('#post_answer_spinner').fadeIn()
    ).bind("ajax:complete", (evt, xhr, status) ->
      # hide answer dialog
      $(this).parent().parent().parent().parent().dialog('close')

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
          height: 'auto'
          position: 'center'
          dialogClass: 'share-modal'
          close: send_to_create_question_page
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
          close: send_to_create_question_page
    )
    return false


$ ->
  init_post_answer_button()