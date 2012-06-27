update_email_pref_radios = ->
  $('#user_email_preferences_input input[type=radio]').each ->
    if $(this).attr('checked') == 'checked'
      $(this).parent().addClass('radio_selected')
    else
      $(this).parent().removeClass('radio_selected')

init_email_prefs = ->
  update_email_pref_radios()
  $('#user_email_preferences_input input[type=radio]').change ->
    update_email_pref_radios()

$ ->
  init_email_prefs()