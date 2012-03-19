class Admin::FlaggedQuestionsController < Admin::SbAdminController
  actions :index, :show, :hide

  def hide
    @flagged_question = FlaggedQuestion.where(:id => params['id']).first
    @flagged_question.update_attribute :hidden, true
    flash[:notice] = "Flagged Question Hidden"
    redirect_to admin_flagged_questions_path
  end

  protected

  def collection
    @flagged_questions ||= end_of_association_chain.order('id DESC').paginate(:page => params[:page])
  end
end