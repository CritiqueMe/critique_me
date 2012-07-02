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
        <label>
          <div id='camera'><img src='/assets/questions/img_upload.png' /></div>
          <div id='blurb'>add photo?</div>
          <div id='fname'></div>
    HTML
  end

  def close_wrapper
    <<-HTML

        </label>
      </div
    HTML
  end
end