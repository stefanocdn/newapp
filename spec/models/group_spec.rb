require 'spec_helper'

describe Group do
	let(:group) { FactoryGirl.create(:group) }

	subject { group }

	it { should respond_to(:name) }
	it { should respond_to(:memberships) }
	it { should respond_to(:users) }
	
	it { should be_valid }
end
