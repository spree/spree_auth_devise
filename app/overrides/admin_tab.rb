Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
:text => "<% if can? :admin, Spree::User %><%= tab(:users, :url => spree.admin_users_path, :icon => 'icon-user') %><% end %>",
                     :disabled => false) #,
                     #:original => 'e49127029c733dcaf154ad0bd59102b63c57ac0b')

