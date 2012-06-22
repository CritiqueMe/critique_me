question_length = 5

init_skip_question = (dlg) ->
  dlg.find('.skip a').click ->
    dlg.find('.canned_question').first().remove()
    if dlg.find('.canned_question').length > 0
      next = dlg.find('.canned_question').first()
      next.fadeIn()
      init_canned_form(dlg, next)
    else
      finish_path = $('#post_share_dialog').data('finish_path')
      finish_path = finish_path + "?show_canned_answer=1"
      window.location = finish_path
    return false


window.CritiqueMe = {}
CritiqueMe.init_canned_questions = init_canned_questions = (dlg) ->
  dlg.find('.canned_question').first().delay(500).queue ->
    init_canned_form(dlg, $(this))
    $(this).show()
  init_skip_question(dlg)

init_canned_form = (dlg, cq) ->
  cq.find('form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    dlg.find('.canned_question').first().hide()
    dlg.find('#spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    dlg.find('.canned_question').first().remove()

    dlg.find('#spinner').hide()
    if dlg.find('.canned_question').length > 0
      ques = dlg.find('.canned_question').first()
      ques.fadeIn()
      init_canned_form(dlg, ques)
    else
      finish_path = $('#post_share_dialog').data('finish_path')
      finish_path = finish_path + "?show_canned_answer=1"
      window.location = finish_path
  )

  cq.find('.button a').click ->
    friend_id = $(this).data('friend-id')
    choice_block = $(this).parent().parent().parent().parent()
    choice_block.find('#chosen_friend').val(friend_id)
    choice_block.find('form').submit()
    return false




$ ->
  CritiqueMe.init_canned_questions($('#canned_questions .canned_question').first().parent())