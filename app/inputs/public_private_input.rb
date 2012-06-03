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
        <div id='priv'><a href='#' id='publink'>Private</a></div>
        <div id='pub'><a href='#' id='privlink'>Public</a></div>
      </div>
      <div class='clearer'></div>
    HTML
  end
end