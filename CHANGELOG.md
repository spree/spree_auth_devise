## Spree Auth Devise v3.3.0 (unreleased)

* `Rails 5.1` support with `spree_extension` gem for compatiblity with all Rails version 4.2+

## Spree Auth Devise v3.2.0 (2017-06-15)

* `Rails 5` support
* Supports `Spree 3.1` `Spree 3.2` and any other newer version lesser than `4.0` (https://github.com/spree/spree_auth_devise/pull/353, https://github.com/spree/spree_auth_devise/pull/386)
* `devise` updated to `4.3` (https://github.com/spree/spree_auth_devise/pull/382)
* `devise-encryptable` updated to `0.2.0` (https://github.com/spree/spree_auth_devise/commit/5f51e6e4e81dbf99fe95848dbd4fa9cba03b6910)
* updated development dependencies (https://github.com/spree/spree_auth_devise/pull/351)
* include `Spree::UserMethods` in `Spree::User` (https://github.com/spree/spree_auth_devise/pull/343)
* fixed: Unnecessary breaking changes of I18n key (https://github.com/spree/spree_auth_devise/pull/387)
* fixed: use proper scoping to find translations related to order states (https://github.com/spree/spree_auth_devise/pull/384)
* fixed: spree_api is not required anymore (https://github.com/spree/spree_auth_devise/pull/380)
* Install generator: Add option to skip migrations (https://github.com/spree/spree_auth_devise/pull/378)
* Added Portuguese translation (https://github.com/spree/spree_auth_devise/pull/365)
* Replaced registration_error flash with standard error (https://github.com/spree/spree_auth_devise/pull/361)

## Spree Auth Devise v3.1.0 (2016-04-05)

* `Spree 3.1` support
* login / account links are loaded via ajax similar to cart link (https://github.com/spree/spree_auth_devise/pull/320)
* updated `devise` to `3.5.4` for security reasons (https://github.com/spree/spree_auth_devise/pull/323)
* explicitly require `deface` in dependencies (https://github.com/spree/spree_auth_devise/pull/331)
* removed `json` from dependencies (https://github.com/spree/spree_auth_devise/pull/329)
* fixes `xml` / `json` endpoints (https://github.com/spree/spree_auth_devise/pull/311)
* `Spree.admin_path` support (https://github.com/spree/spree_auth_devise/pull/307)
* `CircleCI` support (https://github.com/spree/spree_auth_devise/pull/288)
