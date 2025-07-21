class AddOtpToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :otp_secret, :string
  end
end
