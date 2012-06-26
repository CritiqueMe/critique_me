q_class = "question"
mco_class = "multiple_choice_option"


show_hide_minus_button = ->
  if num_existing_answers() <= 2
    $('.minus_button').fadeOut()
  else
    $('.minus_button').fadeIn()

init_remove_answer_links = ->
  show_hide_minus_button()

  $('.minus_button a').unbind().click ->
    if num_existing_answers() > 2
      $(this).parent().parent().parent().slideUp 400, () ->
        $(this).remove()
        show_hide_minus_button()
        update_mc_labels()
    else
      alert "You must have at least two multiple choice options!"
    return false

update_mc_labels = ->
  $('#multiple_choice_answers .mchoice label').each (index) ->
    $(this).html String.fromCharCode('A'.charCodeAt() + index)

init_add_answer_link = () ->
  $('#add_button a').click () ->
    add_multiple_choice_answer()

add_multiple_choice_answer = () ->
  label_letter = String.fromCharCode('A'.charCodeAt() + num_existing_answers())

  new_li       = $('<li>').attr("id", q_class + "_" + mco_class + "s_attributes_" + num_existing_answers() + "_answer_text_input").addClass("mchoice string input required stringish")
  new_label    = $('<label>').addClass(" label").attr("for", q_class + "_" + mco_class + "s_attributes_" + num_existing_answers() + "_answer_text").html(label_letter)
  new_input    = $('<input>').attr("id", q_class + "_" + mco_class + "s_attributes_" + num_existing_answers() + "_answer_text").attr("name", q_class + "[" + mco_class + "s_attributes][" + num_existing_answers() + "][answer_text]").attr("type", "text").val("")
  new_div      = $('<div>').addClass("minus_button")
  new_image    = $('<img>').attr("src", "/assets/questions/minus_button.png").attr("alt", "Minus Button")
  new_link     = $('<a>').attr("href", "#").append(new_image)
  new_fieldset = $('<fieldset>').addClass("inputs multi_choice").append(
    $('<ol>').append(
      new_li.append(new_label).append(new_input)
    ).append(
      new_div.append(new_link)
    )
  )
  $('#multiple_choice_answers #answers').append(new_fieldset)
  init_remove_answer_links()
  init_mc_answer_boxes()
  return false

num_existing_answers = () ->
  $('.mchoice').length


update_public_private = (chosen) ->
  $('#question_public').attr 'checked', chosen
  if chosen
    $('.pubpriv #priv').removeClass('selected')
    $('.pubpriv #pub').addClass('selected')
    #$('#public_preview').slideDown()
  else
    $('.pubpriv #pub').removeClass('selected')
    $('.pubpriv #priv').addClass('selected')
    #$('#public_preview').slideUp()

init_public_private = ->
  chosen = $('#question_public').attr('checked')
  update_public_private(chosen)

  $('.pubpriv #pub a').click ->
    update_public_private(true)
    return false
  $('.pubpriv #priv a').click ->
    update_public_private(false)
    return false
  $('.pubpriv #pub a').mouseover ->
    $('.pubpriv #pub .rollover').fadeIn()
  .mouseout ->
    $('.pubpriv #pub .rollover').fadeOut()
  $('.pubpriv #priv a').mouseover ->
    $('.pubpriv #priv .rollover').fadeIn()
  .mouseout ->
    $('.pubpriv #priv .rollover').fadeOut()


update_qtype_radios = ->
  $('#question_question_type_input input[type=radio]').each ->
    if $(this).attr('checked') == 'checked'
      $(this).parent().addClass('radio_selected')

      # show/hide multiple choice answer boxes
      qtype = $(this).attr('id').replace "question_question_type_", ""
      if qtype == '0'  # multiple choice
        num_to_add = 2 - num_existing_answers()
        if num_to_add > 0
          add_multiple_choice_answer() for num in [1..num_to_add]

        $('#multiple_choice_answers').removeClass("hidden").slideDown()
      else
        $('#multiple_choice_answers').slideUp()

    else
      $(this).parent().removeClass('radio_selected')

init_question_types = ->
  update_qtype_radios()
  $('#question_question_type_input input[type=radio]').change ->
    update_qtype_radios()

default_question_text_str = $('#qform').data("default_question_text")
ensure_text_not_blank = ->
  if $('#question_question_text').val() == ""
    $('#question_question_text').val(default_question_text_str)

init_question_text_box = ->
  ensure_text_not_blank()
  $('#question_question_text').blur ->
    ensure_text_not_blank()
  $('#question_question_text').focus ->
    if $('#question_question_text').val() == default_question_text_str
      $('#question_question_text').val('')

default_mc_answer_text_str = $('#qform').data("default_mc_answer_text")
ensure_mc_not_blank = (elem) ->
  if elem.val() == ''
    elem.val(default_mc_answer_text_str)

init_mc_answer_boxes = ->
  $('.mchoice input').each ->
    $(this).unbind()
    ensure_mc_not_blank($(this))
    $(this).blur ->
      ensure_mc_not_blank($(this))
    $(this).focus ->
      if $(this).val() == default_mc_answer_text_str
        $(this).val('')

init_more_info_lightbox = ->
  $('#newq_subhdr a').mouseover ->
    $('#newq_lightbox').fadeIn()
  .mouseout ->
    $('#newq_lightbox').fadeOut()

init_photo_input = ->
  $('#qphoto label div').click ->
    $('#question_photo').click()
  $('#question_photo').change ->
    $('#fname').html($(this).val())




init_page = ->
  init_public_private()
  init_question_types()
  init_photo_input()
  init_add_answer_link()
  init_remove_answer_links()
  init_question_text_box()
  init_mc_answer_boxes()
  init_more_info_lightbox()

$ ->
  init_page()