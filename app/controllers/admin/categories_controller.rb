class Admin::CategoriesController < Admin::SbAdminController
  actions :index, :show, :new, :edit, :create, :update

  def create
    create!(:notice => "Question Category Created"){ admin_categories_path }
  end

  def deactivate
    @category = Category.where(:id => params['id']).first
    @category.update_attribute :active, false
    flash[:notice] = "Category Deactivated"
    redirect_to admin_categories_path
  end

  def activate
    @category = Category.where(:id => params['id']).first
    @category.update_attribute :active, true
    flash[:notice] = "Category Activated"
    redirect_to admin_categories_path
  end

  protected

  def collection
    @categories ||= end_of_association_chain.order(:name).paginate(:page => params[:page])
  end
end