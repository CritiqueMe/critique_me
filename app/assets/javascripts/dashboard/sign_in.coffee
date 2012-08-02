$ ->
  $('#continue img').mouseover ->
    $(this).attr 'src', '/assets/dashboard/fb_sign_in_button_over.png'
  .mouseout ->
    $(this).attr 'src', '/assets/dashboard/fb_sign_in_button.png'