pop_pitch_dialog = ->
  $('#pitch_dlg').dialog
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 870
    height: 500
    title: ""
    position: 'center'
    dialogClass: 'pitch_dlg'
    autoOpen: true
  $('#pitch_dlg .closer a').click ->
    $('#pitch_dlg').dialog('close')
    return false
  $('#do_not_show input').change ->
    $.post('/toggle_pitch_dlg')
    $('#pitch_dlg').dialog('close')

  $('#pitch_dlg #button a').mouseover ->
    $(this).find('img').attr 'src', 'assets/path/get_started_over.png'
  .mouseout ->
    $(this).find('img').attr 'src', 'assets/path/get_started.png'
  .click ->
    $('#pitch_dlg').dialog('close')
    return false

$ ->
  pop_pitch_dialog()