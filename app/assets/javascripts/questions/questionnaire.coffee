init_page = ->
  $('#questionnaires-choice li').mouseover () ->
    $(this).addClass('hover')
  .mouseleave () ->
    $(this).removeClass('hover')

  $('#questionnaires-choice .remover a').click () ->
    remove_question($(this))
    return false

  $('#questionnaires-choice form').bind("ajax:beforeSend", (evt, xhr, settings) ->
    $('#share_dialog').dialog
      title: "Share Your Question With Friends"
      resizable: false
      draggable: true
      modal: true
      show: 'fade'
      hide: 'fade'
      width: 500
      height: 500
      dialogClass: 'share-modal'
    .html('<img src="/assets/admin/layout/form_spinner.gif" />')
  ).bind("ajax:complete", (evt, xhr, status) ->
    $('#share_dialog').html(xhr.responseText)
  )

remove_question = (remover) ->
  row = remover.parent().parent()
  row.slideUp()
  # remove the question ID from the final submission box
  dqid = row.data("default_question_id")
  dqids = $('#default_question_ids').val().split(",").filter (val) ->
    parseInt(val) != dqid
  $('#default_question_ids').val(dqids.join(","))
  if dqids.length == 0
    $('.buttons input').hide()



$ ->
  init_page()