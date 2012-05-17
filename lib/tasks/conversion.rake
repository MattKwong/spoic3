task :update_liaisons => :environment do
  liaisons = AdminUser.where('liaison_id > ?', 0)
  puts liaisons.length
  liaisons.each do |i|
    i.user_role_id = 2
    i.username = "#{i.first_name}#{i.last_name}#{i.id}"
    puts i.username
    i.save
  end
end

task :update_admins => :environment do
  admins = AdminUser.find_all_by_user_role_id( nil)
  puts admins.length
  admins.each do |i|
    i.user_role_id = 1
    i.username = "#{i.first_name}#{i.last_name}#{i.id}"
    puts i.username
    i.save
  end
end