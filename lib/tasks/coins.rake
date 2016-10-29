task :addcoins => :environment do
  User.find_each do |user|
    user.update_attribute(:coinstobeclaimed, 20)
    SendNewcoinsJob.set(wait: 10.seconds).perform_later(user) 
  end
end

task :unclaimedcoins => :environment do
  User.find_each do |user|
    user.update_attribute(:coinstobeclaimed, 0)
  end
end