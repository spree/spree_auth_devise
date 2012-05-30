Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:users, :url => spree.admin_users_path) %>",
                     :disabled => false)

