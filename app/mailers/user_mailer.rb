Rails::Engine.mixin __FILE__
class UserMailer < ActionMailer::Base
  def answers_gathered(tracker, options={})
    sendgrid_category("Answers Gathered")
    @question = Question.where(:id => options[:question_id]).first
    @user = @question.user
    @url = question_url(@question)
    @tracker_id = tracker.id

    subj = prepare_subject(options)
    from_line = prepare_from_line(options)

    mail(
        :to => @question.user.email,
        :subject => subj,
        :from => from_line,
        :template_path => "email_templates/answers_gathered",
        :template_name => options[:email_template].name
    )
  end
end