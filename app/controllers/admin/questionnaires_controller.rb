class Admin::QuestionnairesController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update, :deactivate, :activate

  def create
    create!(:notice => "Questionnaire Created"){ admin_questionnaires_path }
  end

  def deactivate
    @questionnaire = Questionnaire.where(:id => params['id']).first
    @questionnaire.update_attribute :active, false
    flash[:notice] = "Questionnaire Deactivated"
    redirect_to admin_questionnaires_path
  end

  def activate
    @questionnaire = Questionnaire.where(:id => params['id']).first
    @questionnaire.update_attribute :active, true
    flash[:notice] = "Questionnaire Activated"
    redirect_to admin_questionnaires_path
  end

  protected

  def collection
    @questionnaires ||= end_of_association_chain.paginate(:page => params[:page])
  end
end