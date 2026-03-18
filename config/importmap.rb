# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@rails/activestorage', to: '@rails--activestorage.js' # @8.1.200
pin '@floating-ui/dom', to: '@floating-ui--dom.js' # @1.7.5
pin '@floating-ui/core', to: '@floating-ui--core.js' # @1.7.4
pin '@floating-ui/utils', to: '@floating-ui--utils.js' # @0.2.10
pin '@floating-ui/utils/dom', to: '@floating-ui--utils--dom.js' # @0.2.10
pin "stimulus-use" # @0.52.3
pin "slim-select" # @3.4.3
