show_answer_dialog = (qid) ->
  t = $('#answer_q'+qid).data('title')
  $('#answer_q'+qid).dialog
    title: t
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 650
    height: 450
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
    answer_dlg = $(this).parent().parent().parent().parent().parent().find('.answer_dialog')
    qid = answer_dlg.data('question_id')
    answer_dlg.dialog('close')
    $('#flag_dlg_'+qid).dialog("open")

    return false


update_tf_radios = ->
  $('#answer_true_false_answer_input input[type=radio]').each ->
    if $(this).attr('checked') == 'checked'
      $(this).parent().addClass('radio_selected')
    else
      $(this).parent().removeClass('radio_selected')

init_tf_radios = ->
  update_tf_radios()
  $('#answer_true_false_answer_input input[type=radio]').change ->
    update_tf_radios()


$ ->
  default_qid = $('#share_dialog').data('question_id')
  show_answer_dialog(default_qid)
  init_flag_question_button()
  init_tf_radios()