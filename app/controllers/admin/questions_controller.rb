class Admin::QuestionsController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update, :destroy

  protected

  def collection
    @questions ||= end_of_association_chain.paginate(:page => params[:page])
  end
end