Rails::Engine.mixin __FILE__
class FbShare
  def self.get_template_for_tracking_object(question, share_type)
    qtype = question.canned_question_id ? 'canned' : (question.public? ? 'public' : 'private')
    FbShareTemplate.active.where(:question_type => qtype, :share_type => share_type).random.first
  end
end