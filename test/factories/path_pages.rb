FactoryGirl.define do
  factory :path_page do
    #id { FactoryGirl.generate(:mock_id) }
    experiment :experiment
    name "Test Page"
    page_type :register
    after_build do |pp| 
      pp.experiment.path_pages << pp
    end
  end
end
