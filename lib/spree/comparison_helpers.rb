module Spree
  module ComparisonHelpers
    #method to compare the numerical values of spree versions to determine cardinality
    def self.v1_gte_v2(v1, v2)
      v1.split('.')[0,3].zip(v2.split('.')[0,3]).map{|x, y| x.to_i >= y.to_i}.all?
    end
  end
end
