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
      height: 450
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


$ ->
  init_post_answer_button()