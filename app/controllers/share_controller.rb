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
      get_fb_friends if @user.fb_user_id
      render :partial => "share/dialog"
    end
  end

  def manual_share
    if request.post?
      @question = Question.find(params['question_id'])
      invitees = params['emails'].gsub(" ", '').split(",").collect{|x| {:email => x}}
      Invite.queue_invites(@user, invitees, @question.id)
      if @question.shared_with_minimum?
        finished_sharing(invitees.length)
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
    @question = Question.find(params['question_id'])
    Invite.queue_invites(@user, invitees, @question.id)
    if @question.shared_with_minimum?
      finished_sharing(invitees.length)
    else
      render :partial => "share/oops"
    end
  end

  def share_friends
    @question = Question.find(params['question_id'])

    friend_ids = []
    params['imported_friends'].split(",").each_with_index do |f, i|
      friend_ids << f if params["friend_#{i}"]
    end

    FbShare.share(@user, @question, session[:fb_access_token], friend_ids, nil, 'my_wall')

    if @question.shared_with_minimum? || friend_ids.length >= 5
      finished_sharing(friend_ids.length)
    else
      render :partial => "share/oops"
    end
  end

  private

  def finished_sharing(num_shared)
    if @user.fb_user_id.blank?
      render :partial =>"share/thanks", :locals => {:num_shared => num_shared}
    else
      @canned_questions = CannedQuestion.active.limit(5).order("RAND()")
      get_fb_friends
      if @fb_friends && @fb_friends.length >= 3
        @canned_choices = @canned_questions.map do |cq|
          this_q_choice = []
          @fb_friends.shuffle!
          cq.num_choices.times do |i|
            friend = @fb_friends[i]
            this_q_choice << {
                :name => friend['name'],
                :id => friend['id']
            }
          end
          this_q_choice
        end
        render :partial => "canned/canned_questions"
      else
        # not enough fb friends, so let's not do the share thing
        render :partial =>"share/thanks", :locals => {:num_shared => num_shared}
      end
    end
  end


end

