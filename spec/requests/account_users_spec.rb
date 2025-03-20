require 'rails_helper'

RSpec.describe "AccountUsers", type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let!(:account_user) { create(:account_user, account: account, user: user, role: :admin) }

  describe "GET /edit" do
    subject { get edit_account_user_path(account_user) }

    it_behaves_like 'requires authorization'

    context 'when authenticated' do
      before { sign_in user }

      it 'renders the edit template' do
        subject
        expect(response).to render_template(:edit)
      end

      it 'assigns the account user' do
        subject
        expect(assigns(:account_user)).to eq(account_user)
      end

      it 'assigns the account' do
        subject
        expect(assigns(:account)).to eq(account)
      end
    end
  end

  describe "PATCH /update" do
    subject { patch account_user_path(account_user), params: { account_user: { role: 'member' } } }

    it_behaves_like 'requires authorization'

    context 'when authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'updates the account user' do
          expect {
            subject
          }.to change { account_user.reload.role }.to('member')
        end

        it 'redirects to the account page' do
          subject
          expect(response).to redirect_to(account_path(account))
        end

        it 'sets a success notice' do
          subject
          expect(flash[:notice]).to eq('Account user was successfully updated.')
        end
      end

      context 'with invalid parameters' do
        subject { patch account_user_path(account_user), params: { account_user: { role: '' } } }

        it 'does not update the account user' do
          expect {
            subject
          }.not_to change { account_user.reload.role }
        end

        it 'renders the edit template' do
          subject
          expect(response).to render_template(:edit)
        end

        it 'returns unprocessable entity status' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete account_user_path(account_user) }

    it_behaves_like 'requires authorization', error_message: 'You can\'t delete the owner of the account'

    context 'when authenticated' do
      before { sign_in user }

      it 'destroys the account user' do
        expect {
          subject
        }.to change(AccountUser, :count).by(-1)
      end

      it 'redirects to the account page' do
        subject
        expect(response).to redirect_to(account_path(account))
      end

      it 'sets a success notice' do
        subject
        expect(flash[:notice]).to eq('Account user was successfully removed.')
      end
    end
  end
end
