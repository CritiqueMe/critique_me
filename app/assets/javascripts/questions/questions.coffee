q_class = "question"
mco_class = "multiple_choice_option"

select_question_type = (qtype, elem) ->
  deactivate_all_types()

  qtype_index = switch qtype
    when 'multiple_choice' then 0
    when 'true_false' then 1
    when 'open_text' then 2
  $('#' + q_class + '_question_type').val(qtype_index)

  # show/hide multiple choice answer boxes
  if qtype == 'multiple_choice'
    num_to_add = 2 - num_existing_answers()
    if num_to_add > 0
      add_multiple_choice_answer() for num in [1..num_to_add]

    $('#multiple_choice_answers').removeClass("hidden").slideDown()
  else
    $('#multiple_choice_answers').slideUp()

  # show the "_on" image
  elem.find('img').attr('src', "/assets/questions/" + qtype + "_on.jpg")

  return false

deactivate_all_types = () ->
  $('.qt_choices a').each (index) ->
    qtype = $(this).data('qtype')
    $(this).find('img').attr('src', "/assets/questions/" + qtype + "_off.jpg")

init_question_types = ->
  # grab the qclass and the mco_class from the form
  $('form').each (index) ->
    q_class = $(this).attr('id').replace("new_", "").replace("edit_", "")

    # check to see if the object ID is appended to the q_class, remove it if so...
    regex = /_[0-9]*$/
    extra_id = regex.exec(q_class)
    q_class = q_class.replace(extra_id, "")

    if q_class == 'question'
      mco_class = "multiple_choice_option"
    else
      mco_class = "default_multiple_choice_option"


  # run it once on page load to make sure everything is presented correctly
  qt = $('#' + q_class + '_question_type').val()
  qt_name = switch qt
    when '0' then 'multiple_choice'
    when '1' then 'true_false'
    when '2' then 'open_text'
  select_question_type(qt_name, $('#'+qt_name))

  $('.qt_choices a').each (index) ->
    qtype = $(this).data('qtype')
    $(this).bind('click', () ->
      select_question_type(qtype, $(this))
    )

init_remove_answer_links = ->
  $('.minus_button a').unbind().click ->
    if num_existing_answers() > 2
      $(this).parent().parent().parent().slideUp 400, () ->
        $(this).remove()
    else
      alert "You must have at least two multiple choice options!"
    return false

init_add_answer_link = () ->
  $('#add_button a').click () ->
    add_multiple_choice_answer()

add_multiple_choice_answer = () ->
  new_li       = $('<li>').attr("id", q_class + "_" + mco_class + "s_attributes_" + num_existing_answers() + "_answer_text_input").addClass("mchoice string input required stringish")
  new_label    = $('<label>').addClass(" label").attr("for", q_class + "_" + mco_class + "s_attributes_" + num_existing_answers() + "_answer_text")
  new_input    = $('<input>').attr("id", q_class + "_" + mco_class + "s_attributes_" + num_existing_answers() + "_answer_text").attr("name", q_class + "[" + mco_class + "s_attributes][" + num_existing_answers() + "][answer_text]").attr("type", "text").val("")
  new_div      = $('<div>').addClass("minus_button")
  new_image    = $('<img>').attr("src", "/assets/questions/minus_button.jpg").attr("alt", "Minus Button")
  new_link     = $('<a>').attr("href", "#").append(new_image)
  new_fieldset = $('<fieldset>').addClass("inputs multi_choice").append(
    $('<ol>').append(
      new_li.append(new_label).append(new_input)
    ).append(
      new_div.append(new_link)
    )
  )
  $('#multiple_choice_answers').append(new_fieldset)
  init_remove_answer_links()
  return false

num_existing_answers = () ->
  $('.mchoice').length



init_page = ->
  init_question_types()
  init_add_answer_link()
  init_remove_answer_links()


$ ->
  init_page()