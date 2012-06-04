CritiqueMe::Application.routes.draw do
  namespace :admin do
    # biz logic
    resources :categories
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

  match '/question/:id',                    :to => 'questions#question',        :as => :question
  match '/questions',                       :to => 'questions#new_question',    :as => :questions
  match '/new_question',                    :to => 'questions#new_question',    :as => :new_question
  match '/edit_question/:id',               :to => 'questions#edit_question',   :as => :edit_question
  match '/choose_question(/:id)',           :to => 'questions#choose_question', :as => :choose_question
  match '/category(/:category_id)',         :to => 'questions#choose_question', :as => :category
  match '/questionnaire/:id',               :to => 'questions#questionnaire',   :as => :questionnaire
  match '/post_to_graph/:id',               :to => 'questions#post_to_graph',   :as => :post_to_graph
  match '/canned_answer/:id',               :to => 'answers#canned_answer',     :as => :canned_answer
  match '/flag_question',                   :to => 'questions#flag',            :as => :new_flag

  match '/answer/new',                      :to => 'answers#new',               :as => :new_answer

  match '/path_answer',                      :to => 'welcome#path_answer',      :as => :path_answer

  match '/share/:question_id',              :to => 'share#index',               :as => :share
  match '/manual_share',                    :to => 'share#manual_share',        :as => :manual_share
  match '/get_contacts',                    :to => 'share#get_contacts',        :as => :get_contacts
  match '/share_contacts',                  :to => 'share#share_contacts',      :as => :share_contacts
  match '/share_friends',                   :to => 'share#share_friends',       :as => :share_friends

  match '/about_us',                        :to => 'corporate#about_us',        :as => :about_us
  match '/faq',                             :to => 'corporate#faq',             :as => :faq
  match '/contact_us',                      :to => 'corporate#contact_us',      :as => :contact_us
end
