init_share_nav = ->
  $('#invite_nav ul li a').click ->
    share_class = $(this).attr("class")

    $('#invite_content .content_block').hide()  # hide all current content containers
    $('#invite_nav ul li').removeClass('selected')  # unselect the nav item
    $('#select_contacts').hide()  # reset the importer forms
    $('#email_entry').show()
    $('.error_cntr').remove()  # remove any old errors

    # choose the correct content pane to show
    if share_class == 'gmail' || share_class == 'yahoo' || share_class == 'hotmail'
      $('#contact').show()
      $('.provider').html(share_class)
      $('#provider').val(share_class)
    else
      $('#' + share_class).show()
    $(this).parent().addClass("selected")  # select the correct nav item

    return false

init_selectors = ->
  $('#select_all').click () ->
    $('.contacts input').each (index) ->
      $(this).prop('checked', true)
    return false
  $('#unselect_all').click () ->
    $('.contact_check').each (index) ->
      $(this).prop('checked', false)
    return false

init_contact_importer = ->
  $('#contact_importer').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#email_entry').hide()
    $('#contact_form_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    $('#contact_form_spinner').hide()
    re = /Failure:/
    resp = xhr.responseText
    if re.test(resp)
      $('.error_cntr').remove()  # remove any old errors
      $('#email_entry').prepend("<ol class='error_cntr'><li class='error'>" + resp + "</li></ol>").fadeIn()
    else
      $('#select_contacts').fadeIn()
      $('#contact_table').html(resp)
      init_selectors()
      init_send_contacts_form()
  )

init_send_contacts_form = ->
  $('#send_to_contacts_form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#select_contacts').hide()
    $('#contact_form_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    $('#select_contacts').show()
    pop_confirmation_dialog(xhr.responseText)
  )

pop_confirmation_dialog = (content) ->
  # hide the sharer dialog, show the thanks or oops dialog
  $('#share_dialog').dialog('close')
  $('#post_share_dialog').dialog
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 400
    position: 'center'
    dialogClass: 'share-modal'
  .html(content)

  # initialize oops button and thanks buttons
  $('#oops_button a').click ->
    $('#post_share_dialog').dialog('close')
    $('#share_dialog').dialog('open')
    $('#contact_form_spinner').hide()
    $('#manual_spinner').hide()
    return false
  $('#ask_more a').click ->
    $('#post_share_dialog').dialog('close')
    $('#share_dialog').dialog('open')
    $('#contact_form_spinner').hide()
    $('#manual_spinner').hide()
    return false
  $('#no_thanks').click ->
    $('#post_share_dialog').dialog('close')
    return false

init_manual_entry_form = ->
  $('#manual form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#manual_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    pop_confirmation_dialog(xhr.responseText)
  )

init_fb_friend_list = ->
  $('#show_friends_list_link').click () ->
    $('#fb_post_to_graph_link').hide()
    $('#fb_friend_list').fadeIn()
    return false

  $('#send_to_friends_form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#select_friends').hide()
    $('#friend_form_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    $('#friend_form_spinner').hide()
    pop_confirmation_dialog(xhr.responseText)
  )

init_fb_selectors = ->
  $('#fb_select_all').click () ->
    $('.friends input').each (index) ->
      $(this).prop('checked', true)
    return false
  $('#fb_unselect_all').click () ->
    $('.friend_check').each (index) ->
      $(this).prop('checked', false)
    return false

init_post_to_graph_link = ->
  $('#post_to_graph_link').click ->
    $('#fb_post_to_graph_link').hide()
    $('#post_to_fb_spinner').fadeIn()
    qid = $(this).data("question-id")
    $.get '/post_to_graph/'+qid, (data) ->
      $('#post_to_fb_spinner').hide()
      $('#fb_friend_list').show()
      $('#fb_post_to_graph_link').hide()
      pop_confirmation_dialog(data)

$ ->
  init_share_nav()
  init_fb_friend_list()
  init_fb_selectors()
  init_contact_importer()
  init_manual_entry_form()
  init_post_to_graph_link()