RSpec.shared_examples_for 'authenticated request' do
  context 'when user is signed out' do
    before(:each) do
      sign_out :user
    end

    it 'redirects to the sign in page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
    end
  end
end
