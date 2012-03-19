class Admin::QuestionsController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update, :destroy, :deactivate, :activate

  def deactivate
    @question = Question.where(:id => params['id']).first
    @question.update_attribute :active, false
    flash[:notice] = "Question Deactivated"
    redirect_to admin_question_path(@question)
  end

  def activate
    @question = Question.where(:id => params['id']).first
    @question.update_attribute :active, true
    flash[:notice] = "Question Activated"
    redirect_to admin_question_path(@question)
  end

  protected

  def collection
    @questions ||= end_of_association_chain.paginate(:page => params[:page])
  end
end