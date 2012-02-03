#Rails::Engine.mixin __FILE__
class ShareController < ApplicationController
  def index
    @question = Question.find(params['question_id'])
    if request.post?
      get_contacts(params['email'], params['password'], params['provider'])
      if flash[:importer_error].nil?
        render :partial => "share/contacts"
      else
        render :text => "Failure: #{flash[:importer_error]}"
      end
    else
      render :partial => "share/dialog"
    end
  end

  def manual_share
    if request.post?
      invitees = params['emails'].gsub(" ", '').split(",").collect{|x| {:email => x}}
      Invite.queue_invites(@user, invitees)
      if invitees.length >= 5
        render :partial => "share/thanks", :locals => {:num_shared => invitees.length}
      else
        render :partial => "share/oops"
      end
    end
  end

  def share_contacts
    # Create invite for each selected contact
    invitees = []
    imported_emails = params['imported_emails'].gsub(" ", "").split(",")
    imported_emails.each_with_index do |c, i|
      invitees << {:email => c, :fb_user_id => nil} if params["contact_#{i}"]
    end
    Invite.queue_invites(@user, invitees)
    if invitees.length >= 5
      render :partial => "share/thanks", :locals => {:num_shared => invitees.length}
    else
      render :partial => "share/oops"
    end
  end
end