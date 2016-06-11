class AddsOauthToUsers < ActiveRecord::Migration
  def change

    ## Omniauth
    add_column :users, :provider, :string
    add_column :users, :uid, :string
        
  end
end
