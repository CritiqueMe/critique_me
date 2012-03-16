class Admin::CannedQuestionsController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update, :deactivate, :activate

  def new
    @canned_question = CannedQuestion.new
  end

  def create
    create!(:notice => "Canned Question Created"){ admin_canned_questions_path }
  end

  def deactivate
    @canned_question = CannedQuestion.where(:id => params['id']).first
    @canned_question.update_attribute :active, false
    flash[:notice] = "Canned Question Deactivated"
    redirect_to admin_canned_questions_path
  end

  def activate
    @canned_question = CannedQuestion.where(:id => params['id']).first
    @canned_question.update_attribute :active, true
    flash[:notice] = "Canned Question Activated"
    redirect_to admin_canned_questions_path
  end

  protected

  def collection
    @canned_questions ||= end_of_association_chain.order('id DESC').paginate(:page => params[:page])
  end
end