init_character_counters = ->
  $('.character_counter').each ->
    limit = $(this).data('chars')
    curr_count = $(this).find('input,textarea').val().length
    $(this).append("<div class='expl'>chars left</div><div class='counter'>" + (limit-curr_count) + "</span>")
    $('.counter').digits()
    if limit-curr_count < 0
      $(this).find('div').not('.field_with_errors').addClass("error")

    $(this).find('input,textarea').keyup ->
      if $(this).parent().data('chars')
        limit = $(this).parent().data('chars')
        new_count = $(this).val().length
        $(this).parent().find('.counter').html(limit-new_count)
      else # if the input is wrapped inside a field_with_errors div
        limit = $(this).parent().parent().data('chars')
        new_count = $(this).val().length
        $(this).parent().parent().find('.counter').html(limit-new_count)
      $('.counter').digits()
      if limit-new_count < 0
        $(this).parent().addClass("field_with_errors").parent().find('div').not('.field_with_errors').addClass("error")
      else
        $(this).parent().removeClass("field_with_errors").addClass('inline').parent().find('div').not('.field_with_errors').removeClass("error")

# this method injects commas into numbers, found at
# http://stackoverflow.com/questions/1990512/add-comma-to-numbers-every-three-digits-using-jquery
$.fn.digits = ->
  return this.each ->
    $(this).text( $(this).text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") )

$ ->
  init_character_counters()