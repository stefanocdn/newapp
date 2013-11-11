require 'spec_helper'

describe Categorization do

  let(:lesson) { FactoryGirl.create(:lesson) }
  let(:category) { FactoryGirl.create(:category) }
  let(:categorization) { lesson.categorizations.build(category_id: category.id) }

  subject { categorization }

  it { should respond_to(:lesson) }
  it { should respond_to(:lesson_id) }
  it { should respond_to(:category) }
  it { should respond_to(:category_id) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to lesson_id" do
      expect do
        Categorization.new(lesson_id: lesson.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "categorization methods" do
    it { should respond_to(:lesson) }
    it { should respond_to(:category) }
    its(:lesson) { should == lesson }
    its(:category) { should == category }
  end

  describe "when category id is not present" do
    before { categorization.category_id = nil }
    it { should_not be_valid }
  end

  describe "when lesson id is not present" do
    before { categorization.lesson_id = nil }
    it { should_not be_valid }
  end
end
