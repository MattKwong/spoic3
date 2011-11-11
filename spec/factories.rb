Factory.define :admin_user do |user|
  user.email            "admin@sierraserviceproject.org"
  user.password         "ssp4admin"
  user.password_confirmation       "ssp4admin"
end