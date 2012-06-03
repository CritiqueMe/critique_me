FactoryGirl.define do
  factory :path_element do
    name "Test Element"
    html "<div>test</div>"
    path_spot :path_spot
    after_build do |pe| 
      #pe.id { FactoryGirl.generate(:mock_id) }
      pe.path_spot.path_elements << pe
    end
  end
end
