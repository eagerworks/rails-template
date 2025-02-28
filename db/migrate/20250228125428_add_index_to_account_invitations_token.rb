class AddIndexToAccountInvitationsToken < ActiveRecord::Migration[8.0]
  def change
    add_index :account_invitations, :token, unique: true
  end
end
