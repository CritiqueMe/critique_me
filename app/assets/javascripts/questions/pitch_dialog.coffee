pop_pitch_dialog = ->
  $('#pitch_dlg').dialog
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 700
    height: 'auto'
    title: "Ever Wonder What People Are Not Telling You?"
    position: 'center'
    dialogClass: 'pitch_dlg'
    autoOpen: true
  $('#pitch_dlg .closer a').click ->
    $('#pitch_dlg').dialog('close')
    return false
  $('#do_not_show input').change ->
    $.post('/toggle_pitch_dlg')
    $('#pitch_dlg').dialog('close')

$ ->
  pop_pitch_dialog()