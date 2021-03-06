require 'rails_helper'

RSpec.describe Organization, type: :model do
  
  it "has a valid factory" do
    FactoryBot.create(:organization).should be_valid
  end 
  
  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    # it { should validate_inclusion_of(:use_tokens).in_array([true, false]) }  
    
    # ************************************************************************
    # Warning from shoulda-matchers:
    
    # You are using `validate_inclusion_of` to assert that a boolean column
    # allows boolean values and disallows non-boolean ones. Be aware that it
    # is not possible to fully test this, as boolean columns will
    # automatically convert non-boolean values to boolean ones. Hence, you
    # should consider removing this test.
    # ***********************************************************************
  end 
  
  describe "Associations" do
    it { should have_many(:drivers) }  
    it { should have_many(:riders) }  
    it { should have_many(:rides) }  
  end
  
end
