init_highlightable = ->
  $('.highlightable a').click ->
    content = $(this).html()
    text_box = $('<input type="text" id="dummy" readonly="readonly"></select>').val(content)
    $(this).parent().append(text_box)
    $(this).hide()
    text_box.blur ->
      $(this).parent().find('a').show()
      $(this).remove()
    .click ->
      $(this).parent().find('a').show()
      $(this).remove()
    text_box.select()
    return false

child = null
child_monitor = null
popupCenter = (url, width, height, name) ->
  left = (screen.width/2)-(width/2)
  top = (screen.height/2)-(height/2)
  child = window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top)
  child_monitor = setInterval(check_child, 500)
  return child

check_child = ->
  if child && child.closed
    clearInterval(child_monitor)
    console.log 'child window closed'

window.contacts_callback = (resp) ->
  clearInterval(child_monitor)

  $('#contact_table').html(resp)
  #init_selectors()
  #init_send_contacts_form()
  $('#imported').dialog
    title: ''
    resizable: false
    draggable: true
    modal: true
    show: 'fade'
    hide: 'fade'
    width: 500
    height: 'auto'
    position: 'center'
    dialogClass: 'share-modal'



init_importers = ->
  $('.importer_link a').click ->
    prov = $(this).parent().data('provider')
    if prov == 'live'
      width = 1000
      height = 600
    else
      width = 600
      height = 400
    popupCenter '/contacts/'+prov, width, height, 'contactPopup'
    return false

$ ->
  init_highlightable()
  init_importers()