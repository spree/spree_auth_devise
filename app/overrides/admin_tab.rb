Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:users, :url => spree.admin_users_path) %>",
                     :disabled => false,
                     :original => 'b14b1b16ac8937f99956ffef65de6f9c579ed1aa')

