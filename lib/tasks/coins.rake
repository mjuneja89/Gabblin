task :addcoins => :environment do
  User.find_each do |user|
    user.update_attribute(:coinstobeclaimed, 30) 
  end
end

task :unclaimedcoins => :environment do
  User.find_each do |user|
    user.update_attribute(:coinstobeclaimed, 0)
  end
end