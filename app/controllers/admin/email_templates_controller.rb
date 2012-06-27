Rails::Engine.mixin __FILE__
class Admin::EmailTemplatesController < Admin::SbAdminController
  private

  def sb_extra_preview_vars
    @question = Question.last
    @default_questions = DefaultQuestion.active.featured.not_in_questionnaire.random.limit(3)
  end
end

