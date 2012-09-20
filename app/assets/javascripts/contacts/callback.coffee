$ ->
  if window.opener
    question_id = $('body').data('question_id')
    $.get '/contacts', {question_id: question_id}, (html) ->
      window.opener.contacts_callback(html)
      window.close()