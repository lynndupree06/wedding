class InitializeGroupTable < ActiveRecord::Migration
  def change
    Group.create!(:name => "Bride's Family")
    Group.create!(:name => "Bride's Friends")
    Group.create!(:name => "Groom's Family")
    Group.create!(:name => "Groom's Friends")
    Group.create!(:name => 'Bridal Party')
  end
end
