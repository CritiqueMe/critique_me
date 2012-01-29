class QuestionTypeInput < Formtastic::Inputs::StringInput
  def to_html
    input_wrapping do
      label_html <<
          builder.text_field(method, input_html_options) +
          question_images.html_safe +
          multiple_choice_answers.html_safe
    end
  end

  def question_images
    <<-HTML
      <ul class='qt_choices'>
        <li><a href='#' data-qtype='multiple_choice' id='multiple_choice'><img src='/assets/questions/multiple_choice_off.jpg' /></a></li>
        <li><a href='#' data-qtype='true_false' id='true_false'><img src='/assets/questions/true_false_off.jpg' /></a></li>
        <li><a href='#' data-qtype='open_text' id='open_text'><img src='/assets/questions/open_text_off.jpg' class='off'/></a></li>
      </ul>
    HTML
  end

  def multiple_choice_answers
    <<-HTML

    HTML
  end

  def input_html_options
    { :hidden => true }.merge(super)
  end
end