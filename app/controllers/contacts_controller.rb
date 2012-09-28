Rails::Engine.mixin __FILE__
class ContactsController < ApplicationController
  def get_contacts
    ic = ImportedContacts.where(:_id => session[:imported_contacts_id]).first
    @question = Question.where(:id => ic.question_id).first
    names = ic.contacts.reject{|x| x['name'].blank?}
    names.sort!{|a,b| a['name'] <=> b['name']}
    no_names = ic.contacts.reject{|x| !x['name'].blank?}
    no_names.sort!{|a,b| a['email'] <=> b['email']}
    @contacts = names + no_names
    render :partial => "share/contacts"
  end

  def callback
    if params[:importer] == 'live'
      live = Contacts::WindowsLive.new(contacts_callback_url('live'))
      contacts = live.contacts(request.raw_post)
      Rails.logger.info "contacts = #{contacts}"
    else
      Rails.logger.info "contacts = #{request.env['omnicontacts.contacts']}"
      contacts = request.env['omnicontacts.contacts']
    end
    Rails.logger.info "*** Session = #{session.inspect}"
    @question = Question.where(:id => session[:question_to_share]).first
    ic = ImportedContacts.create(:user_id => @user.id, :contacts => contacts, :question_id => @question.try(:id))
    session[:imported_contacts_id] = ic.id
    render :layout => false
  end
end