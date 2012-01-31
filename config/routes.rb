CritiqueMe::Application.routes.draw do
  namespace :admin do
    # biz logic
    resources :categories
    resources :default_questions do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
    resources :questions
    resources :questionnaires do
      put 'deactivate', :on => :member
      put 'activate', :on => :member
    end
  end

  match '/privacy_options',                 :to => 'dashboard#privacy_options', :as => :privacy_options

  match '/questions',                       :to => 'questions#new_question',    :as => :questions
  match '/new_question',                    :to => 'questions#new_question',    :as => :new_question
  match '/choose_question(/:id)',           :to => 'questions#choose_question', :as => :choose_question
  match '/questionnaire/:id',               :to => 'questions#questionnaire',   :as => :questionnaire

  match '/share/:question_id',              :to => 'share#index',               :as => :share
end
