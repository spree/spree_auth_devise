Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :partial => "spree/admin/users_tab",
                     :disabled => false)

