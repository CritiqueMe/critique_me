question_length = 5

init_canned_questions = ->
  $('.canned_question').first().delay(100).queue ->
    init_canned_form($(this))
    $(this).show()

init_canned_form = (cq) ->
  cq.find('form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('.canned_question').first().hide()
    $('#spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    $('.canned_question').first().remove()

    # handle the viral messaging
    if $('#before_see_answer').length > 0
      $('#before_see_answer').remove()
      $('#see_answer').show()
    else if $('#see_answer').length > 0
      $('#see_answer').remove()
      $('#done_showing_answer').show()

    $('#spinner').hide()
    if $('.canned_question').length > 0
      ques = $('.canned_question').first()
      ques.fadeIn()
      init_canned_form(ques)
    else
      finish_path = $('#post_share_dialog').data('finish_path')
      window.location = finish_path
  )

  cq.find('.button a').click ->
    friend_id = $(this).data('friend-id')
    choice_block = $(this).parent().parent().parent().parent()
    choice_block.find('#chosen_friend').val(friend_id)
    choice_block.find('form').submit()
    return false

init_skip_question = ->
  $('.skip a').click ->
    $('.canned_question').first().remove()
    if $('.canned_question').length > 0
      next = $('.canned_question').first()
      next.fadeIn()
      init_canned_form(next)
    else
      finish_path = $('#post_share_dialog').data('finish_path')
      window.location = finish_path
    return false

$ ->
  init_canned_questions()
  init_skip_question()