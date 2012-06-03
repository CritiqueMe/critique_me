class QuestionPhotoInput < Formtastic::Inputs::FileInput
  def to_html
    input_wrapping do
      label_html <<
          open_wrapper.html_safe + builder.file_field(method, input_html_options) + close_wrapper.html_safe
    end
  end

  def open_wrapper
    <<-HTML
      <div id='qphoto'>
        <div id='camera'><img src='/assets/questions/photo_icon.png' /></div>
        <div id='blurb'>add photo</div>
        <div id='filefield'>
    HTML
  end

  def close_wrapper
    <<-HTML
        </div>
      </div
    HTML
  end
end