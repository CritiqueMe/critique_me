FactoryGirl.define do
  factory :experiment do
    traffic_group "organic"
    conversion_event "registration"
    name "Test Experiment"
    delivery_url ""
    active false
    #id { FactoryGirl.generate(:mock_id) }
  end
end
