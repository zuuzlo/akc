require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { should belong_to(:commentable) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of(:comment) }
  it { should validate_presence_of(:email) }

end
