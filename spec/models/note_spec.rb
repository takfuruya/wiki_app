# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#  public_id  :string(255)
#

require 'spec_helper'

describe Note do

  let(:user) { FactoryGirl.create(:user) }
  before { @note = user.notes.build(name: "Lorem", content: "ipsum dolor") }

  subject { @note }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:name) }
  it { should respond_to(:public_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Note.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to public_id" do
      expect do
        Note.new(public_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @note.user_id = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @note.name = nil }
    it { should_not be_valid }
  end
end
