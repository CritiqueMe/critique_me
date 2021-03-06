CritiqueMe::Application.routes.draw do
  namespace :admin do
    # biz logic
    resources :categories do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
    resources :default_questions do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
    resources :questions do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
    resources :questionnaires do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
    resources :canned_questions do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
    resources :flagged_questions do
      put 'hide', :on => :member
    end
  end

  match '/privacy_options',                 :to => 'dashboard#privacy_options', :as => :privacy_options
  match '/email_preferences',               :to => 'dashboard#email_preferences', :as => :email_preferences

  match '/question/:id',                    :to => 'questions#question',        :as => :question
  match '/q/:token/:question_id',           :to => 'referral#incoming',         :as => :question_referral
  match '/questions',                       :to => 'questions#new_question',    :as => :questions
  match '/new_question',                    :to => 'questions#new_question',    :as => :new_question
  match '/edit_question/:id',               :to => 'questions#edit_question',   :as => :edit_question
  match '/choose_question(/:id)',           :to => 'questions#choose_question', :as => :choose_question
  match '/category(/:category_id)',         :to => 'questions#choose_question', :as => :category
  match '/questionnaire/:id',               :to => 'questions#questionnaire',   :as => :questionnaire
  match '/post_to_graph/:id',               :to => 'questions#post_to_graph',   :as => :post_to_graph
  match '/canned_answer/:id',               :to => 'answers#canned_answer',     :as => :canned_answer
  match '/flag_question',                   :to => 'questions#flag',            :as => :new_flag
  match '/toggle_pitch_dlg',                :to => 'questions#toggle_pitch_dlg',:as => :toggle_pitch_dlg

  match '/answer/new',                      :to => 'answers#new',               :as => :new_answer

  match '/path_answer',                     :to => 'welcome#path_answer',       :as => :path_answer
  match '/path_canned_finished',            :to => 'welcome#canned_finished',   :as => :path_canned_finished
  match '/path_choose_question',            :to => 'welcome#choose_question',   :as => :path_choose_question
  match '/path_write_question',             :to => 'welcome#write_question',    :as => :path_write_question
  match '/path_manual_share',               :to => 'welcome#manual_share',      :as => :path_manual_share

  match '/share/:question_id',              :to => 'share#index',               :as => :share
  match '/manual_share',                    :to => 'share#manual_share',        :as => :manual_share
  match '/get_contacts',                    :to => 'share#get_contacts',        :as => :get_contacts
  match '/share_contacts',                  :to => 'share#share_contacts',      :as => :share_contacts
  match '/share_friends',                   :to => 'share#share_friends',       :as => :share_friends
  match '/share_question/:id',              :to => 'share#three_options',       :as => :share_question

  match '/about_us',                        :to => 'corporate#about_us',        :as => :about_us
  match '/faq',                             :to => 'corporate#faq',             :as => :faq
  match '/contact_us',                      :to => 'corporate#contact_us',      :as => :contact_us
  match '/tos',                             :to => 'corporate#tos',             :as => :tos
  match '/privacy',                         :to => 'corporate#privacy',         :as => :privacy

  # override the splash path
  match '/splash',                          :to => 'welcome#path',              :as => :splash

  root :to => "questions#choose_question"
end
