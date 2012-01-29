class Admin::CategoriesController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update

  def create
    create!(:notice => "Question Category Created"){ admin_categories_path }
  end

  protected

  def collection
    @categories ||= end_of_association_chain.order(:name).paginate(:page => params[:page])
  end
end