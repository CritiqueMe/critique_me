Rails::Engine.mixin __FILE__
class ContactsController < ApplicationController
  def get_contacts
    ic = ImportedContacts.where(:_id => session[:imported_contacts_id]).first
    names = ic.contacts.reject{|x| x['name'].blank?}
    names.sort!{|a,b| a['name'] <=> b['name']}
    no_names = ic.contacts.reject{|x| !x['name'].blank?}
    no_names.sort!{|a,b| a['email'] <=> b['email']}
    @contacts = names + no_names
    render :partial => "share/contacts"
  end
end