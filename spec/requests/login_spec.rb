describe "log_in tests" do


before(:each) do
    @current_admin_user = Factory.create(:admin_user)  #:user from factory girl with admin privileges
    @request.env['devise.mapping'] = :admin_user
    @current_admin_user.confirm!
    sign_in @current_admin_user
end

end