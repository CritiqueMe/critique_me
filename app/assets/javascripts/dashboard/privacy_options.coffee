update_radios = ->
  $('input[type=radio]').each ->
    if $(this).attr('checked') == 'checked'
      $(this).parent().addClass('radio_selected')
    else
      $(this).parent().removeClass('radio_selected')

$ ->
  update_radios()
  $('input[type=radio]').change ->
    update_radios()

