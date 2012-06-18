Rails::Engine.mixin __FILE__
class AdminMailer < ActionMailer::Base
  def question_flagged(flag)
    @flag = flag
    @question_url = admin_question_url(@flag.question)
    @asker_url = admin_user_url(@flag.question.user)
    @flagger_url = admin_user_url(@flag.user)
    @flag_url = admin_flagged_question_url(@flag)

    recips = AdminUser.all.map(&:email)
    #recips = [AdminUser.first[:email]]
    mail(
        :to => recips,
        :subject => "CritiqueMe Question Flagged",
        :from => "admin@critiqueme.com",
        :template_path => "email_templates/admin"
    )
  end
end