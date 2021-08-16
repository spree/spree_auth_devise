appraise 'spree-4-3' do
  spree_version = '~> 4.3.0.rc1'
  gem 'rails-controller-testing'
  gem 'spree', spree_version
  gem 'spree_emails', spree_version
  gem 'spree_frontend', spree_version
  gem 'spree_backend', spree_version
end

appraise 'spree-master' do
  gem 'rails-controller-testing'
  gem 'spree', github: 'spree/spree', branch: 'master'
  gem 'spree_emails', github: 'spree/spree', branch: 'master'
  gem 'spree_frontend', github: 'spree/spree', branch: 'master'
  gem 'spree_backend', github: 'spree/spree', branch: 'master'
end
