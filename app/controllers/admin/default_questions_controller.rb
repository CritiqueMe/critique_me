class Admin::DefaultQuestionsController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update, :deactivate, :activate

  def new
    @default_question = DefaultQuestion.new(:questionnaire_id => params['questionnaire_id'])
  end

  def create
    # strip out the multi choice options if the question isn't a multi choice question (prevents validation errors)
    unless params['default_question']['question_type'] == Question::QUESTION_TYPES.index(:multiple_choice).to_s
      params['default_question'].delete('default_multiple_choice_options_attributes')
    end
    create!(:notice => "Default Question Created"){ admin_default_questions_path }
  end

  def deactivate
    @default_question = DefaultQuestion.where(:id => params['id']).first
    @default_question.update_attribute :active, false
    flash[:notice] = "Default Question Deactivated"
    redirect_to admin_default_questions_path
  end

  def activate
    @default_question = DefaultQuestion.where(:id => params['id']).first
    @default_question.update_attribute :active, true
    flash[:notice] = "Default Question Activated"
    redirect_to admin_default_questions_path
  end

  protected

  def collection
    @default_questions ||= end_of_association_chain.order('priority DESC, id DESC').paginate(:page => params[:page])
  end
end