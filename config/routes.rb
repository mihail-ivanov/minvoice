# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :companies

resources :invoices do
  member do
    get 'export'
  end
end

resources :invoice_templates
