require 'spec_helper'

describe School do
  let(:school) { FactoryGirl.create(:school) }

	subject { school }

	it { should respond_to(:name) }
	it { should respond_to(:scholarships) }
	it { should respond_to(:users) }
	
	it { should be_valid }
end
