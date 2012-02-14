AdminUser.create :first_name => "Jonathan", :last_name => "Geggatt", :password => "p@55w0rd", :password_confirmation => "p@55w0rd", :email => "jgeggatt@gmail.com", :role => 100

# Create a default landing path for each traffic group
[:organic, :affiliate].each do |traffic_group|
  experiment = Experiment.create({
    :conversion_event => "register",
    :traffic_group => traffic_group,
    :name => "default_#{traffic_group}_v1"
  })
  PathFlow.create :experiment => experiment, :flow => [:register]
  PathPage.create :page_type => :register, :name => "default_reg_v1", :experiment => experiment, :layout => "prototype"
  experiment.generate_variant_combinations
  experiment.update_attribute :active, true
end

# viral is a bit different
experiment = Experiment.create({
    :conversion_event => "register",
    :traffic_group => :viral,
    :name => "default_viral_v1"
})
PathFlow.create :experiment => experiment, :flow => [:fb_permissions, :answer]
PathPage.create :page_type => :fb_permissions, :name => "default_perms_v1", :experiment => experiment, :layout => "prototype"
PathPage.create :page_type => :answer, :name => "default_answer_v1", :experiment => experiment, :layout => "prototype"
experiment.generate_variant_combinations
experiment.update_attribute :active, true

# Default Invite pieces
InviteTemplate.create :name => "default_invite_v1"
InviteSubject.create :name => "default_subject_v1", :subject => "An invitation from *inviter_full_name*..."
InviteFromLine.create :name => "default_from_v1", :from => "*inviter_full_name* <*inviter_email*>"

# Default Invite Reminder pieces
InviteTemplate.create :name => "reminder_invite_v1", :reminder => true
InviteSubject.create :name => "reminder_subject_v1", :subject => "An invitation from *inviter_full_name*...", :reminder => true
InviteFromLine.create :name => "reminder_from_v1", :from => "*inviter_full_name* <*inviter_email*>", :reminder => true

# Default :register email
EmailTemplate.create :name => "default_register_v1", :email_type => :register
EmailSubject.create :name => "default_reg_subj_v1", :email_type => :register, :subject => "Thank you for registering!"
EmailFromLine.create :name => "default_reg_from_v1", :email_type => :register, :from => "<contact@critique_me.com>"
