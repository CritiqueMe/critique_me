FactoryGirl.define do
  factory :path_spot do
    #id { FactoryGirl.generate(:mock_id) }
    name "Test Spot"
    path_page :path_page
    after_build do |ps| 
      ps.path_page.path_spots << ps
    end
  end
end
