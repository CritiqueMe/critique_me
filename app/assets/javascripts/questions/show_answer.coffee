send_to_create_question_page = ->
  console.log "**** sending to create question page"
  window.location = "/choose_question"

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
    height: 'auto'
    dialogClass: 'answerq_dlg'
  $('.qform #new_answer').bind("ajax:before", (evt, form) ->
    # Answer form validations
    if $('#answer_multiple_choice_option_id_input').length > 0
      selected = $('.mc_options input[type=radio]:checked').val()
      if selected == undefined
        console.log "ERROR - no multiple choice option checked"
        return false
    else if $('#answer_open_text_answer_input').length > 0
      text = $('#answer_open_text_answer').val()
      max_length = $('.character_counter').data('chars')
      if text.length == 0
        console.log "ERROR - no open text answer given"
        return false
      else if text.length > max_length
        console.log "ERROR - open text answer too long"
        return false

  ).bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('.post_answer').hide()
    $('#dlg_content').hide()
    $('#post_answer_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    # hide answer dialog
    $(this).parent().parent().parent().dialog('close')

    if $('#canned_questions').length > 0
      console.log "AAAA"
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
      console.log "BBBB"
      # show answer posted dialog
      $('#answer_posted_dialog').dialog
        title: "Answer Given"
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

init_flag_question_button = ->
  $('.dlg_flagger a').click ->
    answer_dlg = $(this).parent().parent().parent().parent().parent().find('.answer_dialog')
    qid = answer_dlg.data('question_id')
    answer_dlg.dialog('close')
    $('#flag_dlg_'+qid).dialog("open")

    return false


init_tf_radios = ->
  $('.true_false_buttons a').click ->
    if $(this).attr('id') == 'yes'
      $('#answer_true_false_answer').val(true)
    else
      $('#answer_true_false_answer').val(false)
    $('#new_answer').submit()
    return false

update_mc_radios = ->
  $('.mc_options input[type=radio]').each ->
    if $(this).attr('checked') == 'checked'
      $(this).parent().addClass('radio_selected')
    else
      $(this).parent().removeClass('radio_selected')

init_mc_radios = ->
  update_mc_radios()
  $('.mc_options input[type=radio]').change ->
    update_mc_radios()




$ ->
  default_qid = $('#share_dialog').data('question_id')
  show_answer_dialog(default_qid)
  init_flag_question_button()
  init_tf_radios()
  init_mc_radios()