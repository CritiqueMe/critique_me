$ ->
  $("#cq_link a").click ->
    $('#canned_questions').dialog
      title: "Answer fun questions about your friends and find out what they said about you."
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 800
      height: 440
      position: 'center'
      dialogClass: 'share-modal'
    return false