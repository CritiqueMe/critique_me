FactoryGirl.define do
  factory :path_element_group do
    name "Test Group"
    experiment :experiment
    after_build do |peg| 
      # id { FactoryGirl.generate(:mock_id) }
      peg.experiment.path_element_groups << peg
    end
  end
end
