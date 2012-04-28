# == Schema Information
#
# Table name: experiments
#
#  id               :integer(4)      not null, primary key
#  conversion_event :string(255)
#  name             :string(255)
#  delivery_url     :string(255)
#  traffic_group    :string(255)
#  active           :boolean(1)      default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ExperimentTest < ActiveSupport::TestCase
  context "landing path experiments" do
    context "variant combination generation" do
      context "recursive combine method" do
        setup do
          @arr1 = [ 1 ]
          @arr2 = [ 'a', 'b' ]
          @arr3 = [ 'Z', 'Y', 'X' ]
          @arr4 = [ 9, 8, 7, 6 ]
          @arr5 = [ '!', '@', '#', '$', '%' ]
          @arr6 = [ '.' ]

          @experiment = FactoryGirl.build(:experiment)
        end

        should "combine 1x2 arrays" do
          combs = @experiment.combinations [@arr1, @arr2]
          assert_equal 2, combs.length
          assert_equal '1a', combs.first
          assert_equal '1b', combs.last
        end

        should "combine 2x3 arrays" do
          combs = @experiment.combinations [@arr2, @arr3]
          assert_equal 6, combs.length
          right = ['aZ', 'aY', 'aX', 'bZ', 'bY', 'bX']
          assert_equal right, combs
        end

        should "combine 4x5 arrays" do
          combs = @experiment.combinations [@arr4, @arr5]
          assert_equal 20, combs.length
          right = ['9!', '9@', '9#', '9$', '9%', '8!', '8@', '8#', '8$', '8%', '7!', '7@', '7#', '7$', '7%', '6!', '6@', '6#', '6$', '6%' ]
          assert_equal right, combs
        end

        should "combine 3x4x1 arrays" do
          combs = @experiment.combinations [@arr3, @arr4, @arr6]
          assert_equal 12, combs.length
          right = ['Z9.', 'Z8.', 'Z7.', 'Z6.', 'Y9.', 'Y8.', 'Y7.', 'Y6.', 'X9.', 'X8.', 'X7.', 'X6.']
          assert_equal right, combs
        end

        should "combine 3x4x1x2 arrays" do
          combs = @experiment.combinations [@arr3, @arr4, @arr6, @arr2]
          assert_equal 24, combs.length
          right = [ 'Z9.a', 'Z9.b', 'Z8.a', 'Z8.b', 'Z7.a', 'Z7.b', 'Z6.a', 'Z6.b', 'Y9.a', 'Y9.b', 'Y8.a', 'Y8.b', 'Y7.a', 'Y7.b', 'Y6.a', 'Y6.b', 'X9.a', 'X9.b', 'X8.a', 'X8.b', 'X7.a', 'X7.b', 'X6.a', 'X6.b' ]
          assert_equal right, combs
        end

      end

      context "traversing paths" do
        setup do
          @experiment = FactoryGirl.create(:experiment)

          # Page Flow 1:
          @flow1 = FactoryGirl.create(:path_flow, :experiment => @experiment, :flow => [:register, :invite])
          # register page has two templates
          @rp1 = FactoryGirl.create(:path_page, :page_type => :register, :name => "RP1", :experiment => @experiment)

          # RP1 has two path_spots
          @rp1s1 = FactoryGirl.create(:path_spot, :name => "RP1s1", :path_page => @rp1)

          # RP1s1 has two configured elements
          @rp1s1e1 = FactoryGirl.create(:path_element, :path_spot => @rp1s1)
          @rp1s1e2 = FactoryGirl.create(:path_element, :path_spot => @rp1s1)

          @rp1s2 = FactoryGirl.create(:path_spot, :name => "RP1s2", :path_page => @rp1)

          # RP1s2 has three configured elements
          @rp1s2e1 = FactoryGirl.create(:path_element, :path_spot => @rp1s2)
          @rp1s2e2 = FactoryGirl.create(:path_element, :path_spot => @rp1s2)
          @rp1s2e3 = FactoryGirl.create(:path_element, :path_spot => @rp1s2)


          @rp2 = FactoryGirl.create(:path_page, :page_type => :register, :name => "RP2", :experiment => @experiment)
          # RP2 has one path_spot
          @rp2s1 = FactoryGirl.create(:path_spot, :name => "RP2s1", :path_page => @rp2)
          # RP2s1 has three configured elements
          @rp2s1e1 = FactoryGirl.create(:path_element, :path_spot => @rp2s1)
          @rp2s1e2 = FactoryGirl.create(:path_element, :path_spot => @rp2s1)
          @rp2s1e3 = FactoryGirl.create(:path_element, :path_spot => @rp2s1)

          # invite page has one template
          @ip1 = FactoryGirl.create(:path_page, :page_type => :invite, :name => "IP1", :experiment => @experiment)

          # IP1 has three path spots

          @ip1s1 = FactoryGirl.create(:path_spot, :name => "IP1s1", :path_page => @ip1)
          # IP1s1 has two configured elements
          @ip1s1e1 = FactoryGirl.create(:path_element, :path_spot => @ip1s1)
          @ip1s1e2 = FactoryGirl.create(:path_element, :path_spot => @ip1s1)

          @ip1s2 = FactoryGirl.create(:path_spot, :name => "IP1s2", :path_page => @ip1)
          # IP1s1 has two configured elements
          @ip1s2e1 = FactoryGirl.create(:path_element, :path_spot => @ip1s2)
          @ip1s2e2 = FactoryGirl.create(:path_element, :path_spot => @ip1s2)

          @ip1s3 = FactoryGirl.create(:path_spot, :name => "IP1s3", :path_page => @ip1)
          # IP1s3 has two configured elements
          @ip1s3e1 = FactoryGirl.create(:path_element, :path_spot => @ip1s3)
          @ip1s3e2 = FactoryGirl.create(:path_element, :path_spot => @ip1s3)

        end

        should "build all the correct combinations" do
          @experiment.generate_variant_combinations

          # ((2*3) + 3 elements) * (2*2*2 elements) = 72
          assert_equal 72, @experiment.variant_combinations.active.count
          assert_equal "#{ @rp1.id }[#{ @rp1s1e1.id },#{ @rp1s2e1.id }].#{ @ip1.id }[#{ @ip1s1e1.id },#{ @ip1s2e1.id },#{ @ip1s3e1.id }]", @experiment.variant_combinations.active.first.key
          assert_equal "#{ @rp2.id }[#{ @rp2s1e3.id }].#{ @ip1.id }[#{ @ip1s1e2.id },#{ @ip1s2e2.id },#{ @ip1s3e2.id }]", @experiment.variant_combinations.active.last.key
        end

        should "ignore inactive elements" do
          @rp1s2e1.update_attribute :active, false
          @experiment.generate_variant_combinations
          assert_equal 56, @experiment.variant_combinations.active.count # ((2*2)+3) * (2*2*2) = 56
        end

        should "ignore inactive pages" do
          @rp2.update_attribute :active, false
          @experiment.generate_variant_combinations
          assert_equal 48, @experiment.variant_combinations.active.count # (2*3) * (2*2*2) = 48
        end

        should "limit combinations by group" do
          # set up some of the elements to be in a group
          @group = FactoryGirl.create(:path_element_group, :experiment => @experiment)
          @rp1s1e2.update_attribute :path_element_group_id, @group.id
          @rp1s2e2.update_attribute :path_element_group_id, @group.id
          @rp1s2e3.update_attribute :path_element_group_id, @group.id
          @ip1s1e2.update_attribute :path_element_group_id, @group.id
          @ip1s2e2.update_attribute :path_element_group_id, @group.id
          @ip1s3e2.update_attribute :path_element_group_id, @group.id

          @experiment.generate_variant_combinations
          assert_equal 6, @experiment.variant_combinations.active.count # (2 different group paths, 4 different ungrouped paths) = 6
        end

      end  # context travsersing paths

    end
  end
end

