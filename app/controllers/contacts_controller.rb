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
    Rails.logger.info "contacts = #{request.env['omnicontacts.contacts']}"
    Rails.logger.info "*** session = #{session.inspect}"
    q = Question.where(:id => session[:question_to_share]).first
    ic = ImportedContacts.create(:user_id => @user.id, :contacts => request.env['omnicontacts.contacts'], :question_id => q.try(:id))
    session[:imported_contacts_id] = ic.id
    render :layout => false
  end
end