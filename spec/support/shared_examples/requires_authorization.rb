RSpec.shared_examples 'requires authorization' do |error_message: nil|
  context 'when not authenticated' do
    before(:each) do
      sign_out :user
    end

    it 'redirects to the root path' do
      subject
      expect(response).to redirect_to(root_path)
    end

    it 'sets an unauthorized flash message' do
      subject
      message = error_message || I18n.t('default', scope: 'pundit')
      expect(flash[:error]).to eq(message)
    end
  end
end 