popupCenter = (url, width, height, name) ->
  left = (screen.width/2)-(width/2)
  top = (screen.height/2)-(height/2)
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top)

window.contacts_callback = (resp) ->
  $('#contact_form_spinner').hide()
  $('#select_contacts').fadeIn()
  $('#contact_list').html(resp)
  init_selectors()
  init_send_contacts_form()
  $("#invite_dialog").dialog("option", "position", "center");



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

      popupCenter '/contacts/'+share_class, 600, 400, 'contactPopup'
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
    # remove all already-selected contacts from the list
    $('.contact_check').each (elem) ->
      $(this).parent().parent().remove() if $(this).is(':checked')
    recycle_contact_rows()
    pop_canned_questions_dialog(xhr.responseText)
  )

recycle_contact_rows = ->
  $('.contacts tr').each (index) ->
    if index % 2 == 0
      $(this).removeClass('odd').addClass('even')
    else
      $(this).removeClass('even').addClass('odd')

pop_canned_questions_dialog = (content) ->
  # hide the sharer dialog, show the thanks or oops dialog
  $('#share_dialog').dialog('close')

  regex = new RegExp('canned_question')

  if regex.test(content)
    dlg_title = "Answer fun questions about your friends and find out what they said about you."
  else
    dlg_title = ''

  $('#post_share_dialog').html(content).delay(700).queue ->
    $(this).dialog
      title: dlg_title
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 800
      height: 'auto'
      position: 'center'
      dialogClass: 'share-modal'
    $(this).dequeue()

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

  # initialize canned question
  $('#post_share_dialog .canned_question').first().show()
  CritiqueMe.init_canned_questions($('#post_share_dialog'))

init_manual_entry_form = ->
  $('#manual form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#manual_spinner').fadeIn()
  ).bind("ajax:complete", (evt, xhr, status) ->
    pop_canned_questions_dialog(xhr.responseText)
  )

init_fb_friend_list = ->
  $('#show_friends_list_link').click () ->
    $('#fb_post_to_graph_link').hide()
    $('#fb_friend_list').fadeIn()
    $('#fb_friend_blurb').fadeIn()
    return false

  $('#send_to_friends_form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#select_friends').hide()
    $('#friend_form_spinner').addClass('inliner')
  ).bind("ajax:complete", (evt, xhr, status) ->
    $('#friend_form_spinner').removeClass('inliner')
    # remove all already-selected friends from the list
    $('.friend_check').each (elem) ->
      $(this).parent().parent().remove() if $(this).is(':checked')
    recycle_friend_rows()
    pop_canned_questions_dialog(xhr.responseText)
  )

recycle_friend_rows = ->
  $('.friends tr').each (index) ->
    if index % 2 == 0
      $(this).removeClass('odd').addClass('even')
    else
      $(this).removeClass('even').addClass('odd')

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
      $('#fb_friend_blurb').show()
      $('#fb_friend_list').show()
      $('#fb_post_to_graph_link').hide()
      pop_canned_questions_dialog(data)


pop_img_dialog = (qid) ->
  img = $('#qimg_dialog_'+qid+' img').first()
  console.log img.attr('src')
  $('#qimg_dialog_'+qid).dialog
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 600
    height: 600
    title: ""
    position: 'center'
    dialogClass: 'share-modal'
    autoOpen: true
  .dialog(width: img.width()+30).height(img.height()+30).dialog("option", "position", "center")

init_qimage_link = ->
  $('.qimage a').click ->
    pop_img_dialog($(this).parent().data('question_id'))
    return false

init_twitter = ->
  qid = $('.qpreview').data('question_id')
  $.get '/build_tweet_button', {question_id: qid}, (html) ->
    $('#invite_content #twitter').html(html)

$ ->
  init_share_nav()
  init_fb_friend_list()
  init_fb_selectors()
  init_twitter()
  init_contact_importer()
  init_manual_entry_form()
  init_post_to_graph_link()
  init_qimage_link()
