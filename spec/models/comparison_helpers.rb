require 'spec_helper'
require 'spree/comparison_helpers'
include Spree::ComparisonHelpers
describe 'ComparisonHelpers.v1_gt_v2' do
  it 'should return true when v1 is greater than v2' do
    expect(Spree::ComparisonHelpers.v1_gt_v2("2.1.11.stable", "2.1.3")).to be_true
  end
  it 'should return false when v1 is equal to v2' do
    expect(Spree::ComparisonHelpers.v1_gt_v2("2.1.3", "2.1.3")).to be_false
  end
  it 'should return false when v1 is less than v2' do
    expect(Spree::ComparisonHelpers.v1_gt_v2("2.1.1", "2.1.3")).to be_false
  end
  it 'should return true for 2.2.5 > 2.1.7' do
    expect(Spree::ComparisonHelpers.v1_gt_v2("2.2.5", "2.1.7")).to be_true
  end
  it "should return true for 2.10 > 2.1.11" do
    expect(Spree::ComparisonHelpers.v1_gt_v2("2.10", "2.1.11")).to be_true
  end
end
