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

  def login_reminder(tracker, options={})
    sendgrid_category("Login Reminder")
    @user = User.where(:id => tracker.user_id).first
    @tracker_id = tracker.id

    subj = prepare_subject(options)
    from_line = prepare_from_line(options)

    mail(
        :to => @user.email,
        :subject => subj,
        :from => from_line,
        :template_path => "email_templates/login_reminder",
        :template_name => options[:email_template].name
    )
  end

  def question_invite_reminder(tracker, options={})
    sendgrid_category("Question Invite Reminder")
    @user = User.where(:id => tracker.user_id).first
    @question = Question.where(:id => options[:question_id]).first
    @tracker_id = tracker.id

    subj = prepare_subject(options)
    from_line = prepare_from_line(options)

    mail(
        :to => @user.email,
        :subject => subj,
        :from => from_line,
        :template_path => "email_templates/question_invite_reminder",
        :template_name => options[:email_template].name
    )
  end

  def weekly_email(tracker, options={})
    sendgrid_category("Weekly Email")
    @user = User.where(:id => tracker.user_id).first
    @tracker_id = tracker.id
    @default_questions = DefaultQuestion.active.featured.not_in_questionnaire.random.limit(3)

    subj = prepare_subject(options)
    from_line = prepare_from_line(options)

    mail(
        :to => @user.email,
        :subject => subj,
        :from => from_line,
        :template_path => "email_templates/weekly_email",
        :template_name => options[:email_template].name
    )
  end
end