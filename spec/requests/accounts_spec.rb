require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let!(:account_user) { create(:account_user, account: account, user: user, role: :admin) }

  describe "GET /index" do
    subject { get accounts_path }

    it_behaves_like 'authenticated request'

    context 'when authenticated' do
      before { sign_in user }

      it 'renders the index template' do
        subject
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET /new" do
    subject { get new_account_path }

    it_behaves_like 'authenticated request'

    context 'when authenticated' do
      before { sign_in user }

      it 'renders the new template' do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST /create" do
    subject { post accounts_path, params: { account: { name: 'New Account' } } }

    it_behaves_like 'authenticated request'

    context 'when authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates a new account' do
          expect {
            subject
          }.to change(Account, :count).by(1)
        end

        it 'creates an account user with admin role' do
          expect {
            subject
          }.to change(AccountUser, :count).by(1)
        end

        it 'sets the current user as owner' do
          subject
          expect(Account.last.owner).to eq(user)
        end

        it 'redirects to the accounts list' do
          subject
          expect(response).to redirect_to(accounts_path)
        end

        it 'sets a success notice' do
          subject
          expect(flash[:notice]).to eq('Account was successfully created.')
        end
      end

      context 'with invalid parameters' do
        subject { post accounts_path, params: { account: { name: '' } } }

        it 'does not create a new account' do
          expect {
            subject
          }.not_to change(Account, :count)
        end

        it 'renders the new template' do
          subject
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "GET /show" do
    subject { get account_path(account) }

    it_behaves_like 'authenticated request'

    context 'when authenticated' do
      before { sign_in user }

      it 'renders the show template' do
        subject
        expect(response).to render_template(:show)
      end

      it 'assigns the account' do
        subject
        expect(assigns(:account)).to eq(account)
      end
    end
  end

  describe "PATCH /switch" do
    subject { patch account_switch_path(account) }

    it_behaves_like 'authenticated request'

    context 'when authenticated' do
      before { sign_in user }

      it 'sets the account in the session' do
        subject
        expect(session[:account_id]).to eq(account.id)
      end

      context 'when return_to is provided' do
        subject { patch account_switch_path(account), params: { return_to: '/some/path' } }

        it 'redirects to the return_to path' do
          subject
          expect(response).to redirect_to('/some/path')
        end
      end

      context 'when return_to is not provided' do
        it 'redirects to the root path' do
          subject
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end 