pop_img_dialog = ->
  img = $('#qimg_dialog img').first()
  console.log img.attr('src')
  $('#qimg_dialog').dialog
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
  .dialog(width: img.width()+30).height(img.height()+30)

$ ->
  $('.qimage a').click ->
    pop_img_dialog()
    return false