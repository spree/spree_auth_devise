module Spree
  module ComparisonHelpers
    #method to compare the numerical values of spree versions to determine cardinality
    def self.v1_gt_v2(v1, v2)
      (v1.split('.')[0,3].map(&:to_i) <=> v2.split('.')[0,3].map(&:to_i)) == 1
    end
  end
end
