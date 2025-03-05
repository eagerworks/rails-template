RSpec.shared_examples_for 'admin access' do
  context 'when user is an admin' do
    let(:user) { create(:user, :admin) }

    it { is_expected.to permit(user) }
  end

  context 'when user is not an admin' do
    let(:user) { create(:user) }

    it { is_expected.not_to permit(user) }
  end
end

RSpec.shared_examples_for 'admin scope' do |resource_name|
  context 'when user is an admin' do
    let(:user) { create(:user, :admin) }
    let!(:resources) { create_list(resource_name, 5) }

    it 'returns all resources' do
      resource_class = resource_name.to_s.classify.constantize
      expect(described_class::Scope.new(user,
                                        resource_class).resolve).to match_array(resource_class.all)
    end
  end

  context 'when user is not an admin' do
    let(:user) { create(:user) }

    it 'throws an error' do
      expect do
        described_class::Scope.new(user,
                                   resource_name.to_s.classify.constantize).resolve
      end.to raise_error(NoMethodError)
    end
  end
end
