FactoryGirl.define do
  factory :path_flow do
    #id { FactoryGirl.generate(:mock_id) }
    experiment :experiment
    flow [:register, :invite]
    after_build do |pf| 
      pf.experiment.path_flows << pf
    end
  end
end
