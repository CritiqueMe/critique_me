init_inputs = ->
  curr_fn = $('#user_first_name').val()
  default_fn_text = 'First Name'
  if curr_fn == ''
    $('#user_first_name').val(default_fn_text)
  $('#user_first_name').focus ->
    # hide errors on focus
    $(this).parent().removeClass('error')
    $(this).parent().find('.inline-errors').hide()

    if $(this).val() == default_fn_text
      $(this).val('')
  .blur ->
    if $(this).val() == ''
      $(this).val(default_fn_text)

  curr_ln = $('#user_last_name').val()
  default_ln_text = 'Last Name'
  if curr_ln == ''
    $('#user_last_name').val(default_ln_text)
  $('#user_last_name').focus ->
    # hide errors on focus
    $(this).parent().removeClass('error')
    $(this).parent().find('.inline-errors').hide()

    if $(this).val() == default_ln_text
      $(this).val('')
  .blur ->
    if $(this).val() == ''
      $(this).val(default_ln_text)

  curr_email = $('#user_email').val()
  default_email_text = 'Email Address'
  if curr_email == ''
    $('#user_email').val(default_email_text)
  $('#user_email').focus ->
    # hide errors on focus
    $(this).parent().removeClass('error')
    $(this).parent().find('.inline-errors').hide()

    if $(this).val() == default_email_text
      $(this).val('')
  .blur ->
    if $(this).val() == ''
      $(this).val(default_email_text)

  curr_pass = $('#user_password').val()
  pw_error = $('.error').length > 0

  if curr_pass == '' && !pw_error
    $('#pw_clear').show()
    $('#user_password').hide()
  else
    $('#user_password').show()
    $('#pw_clear').hide()

  $('#pw_clear').focus ->
    $('#pw_clear').hide()
    $('#user_password').show().focus()
  $('#user_password').focus ->
    $('#user_password').parent().removeClass('error')
    $('#user_password').parent().find('.inline-errors').hide()
  .blur ->
      if $('#user_password').val() == ''
        $('#user_password').hide()
        $('#pw_clear').show()

resize_cm_content = ->
  window_height = $(window).height()
  html_height = $('html').height()
  if window_height > html_height
    total_height = window_height
  else
    total_height = html_height
  landing_page_height = $('#landing_page').height()
  header_height = $('#header').height()
  footer_height = $('#footer').height()
  if landing_page_height > window_height
    $('.container').height(landing_page_height + header_height + footer_height + 30)
  else
    $('.container').height(total_height)
  #console.log "*** window_height: " + window_height + " -- html_height: " + html_height + " -- total_height: " + total_height + " -- heider_height: " + header_height + " -- footer_height: " + footer_height
  $('.cm_content').height total_height - header_height - footer_height

init_more_info_lightbox = ->
  $('#hdr2 a').mouseover ->
    $('#hdr2_lightbox').fadeIn()
  .mouseout ->
    $('#hdr2_lightbox').fadeOut()


$ ->
  resize_cm_content()
  $(window).resize ->
    resize_cm_content()
  init_inputs()