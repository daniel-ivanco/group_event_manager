Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :group_events do
        member do
          put :publish
        end
      end
    end
  end
end
