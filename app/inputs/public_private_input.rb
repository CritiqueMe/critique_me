class PublicPrivateInput < Formtastic::Inputs::BooleanInput
  def to_html
    input_wrapping do
      label_html <<
          template.check_box_tag("#{object_name}[#{method}]", checked_value, checked?, input_html_options) +
          visible_selectors.html_safe
    end
  end

  def visible_selectors
    <<-HTML
      <div class='pubpriv'>
        <div id='priv'>
          <a href='#' id='privlink'>Private</a>
          <div class='rollover'>
            Only the people you invite can see or answer this question, and all answers are anonymous
          </div>
        </div>
        <div id='pub'>
          <a href='#' id='publink'>Public</a>
          <div class='rollover'>
            Anyone can see and answer this question, though answers will still be anonymous.
          </div>
        </div>
      </div>
      <div class='clearer'></div>
    HTML
  end
end