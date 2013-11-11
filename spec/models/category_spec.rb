require 'spec_helper'

describe Category do
  let(:lesson) { FactoryGirl.create(:lesson) }
  let(:category) { FactoryGirl.create(:category) }
  let(:categorization) { lesson.categorizations.build(category_id: category.id) }

  subject { category }

  it { should respond_to(:name) }
  it { should respond_to(:categorizations) }
  it { should respond_to(:lessons) }

end
