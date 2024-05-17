Rails.application.routes.draw do
    # 車のリソースに対するRESTfulなルーティングを定義
    resources :cars do
      # 車に関連する燃費情報のリソースに対するルーティングを追加
      resources :mileage_records, only: [:new, :create]
    end
  end
  