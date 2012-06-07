

$ ->
  $('#continue img').mouseover ->
    $(this).attr 'src', '/assets/path/sign_up_its_free_over.png'
  .mouseout ->
    $(this).attr 'src', '/assets/path/sign_up_its_free.png'