Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :partial => "spree/admin/users_tab",
                     :disabled => false,
                     :original => '031652cf5a054796022506622082ab6d2693699f')

