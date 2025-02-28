require 'rails_helper'

RSpec.describe Credential, type: :model do
  subject(:credential) { build(:credential) }

  it 'has a valid factory' do
    expect(credential).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:webauthn_id) }
    it { should validate_presence_of(:public_key) }
    it { should validate_uniqueness_of(:webauthn_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
