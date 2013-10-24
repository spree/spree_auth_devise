module Spree
  module Auth
    module StrongParameters
        
      def permitted_attributes
        Spree::Auth::PermittedAttributes
      end
    
      delegate *Spree::Auth::PermittedAttributes::ATTRIBUTES,
                 to: :permitted_attributes,
                 prefix: :permitted
    end
  end
end
