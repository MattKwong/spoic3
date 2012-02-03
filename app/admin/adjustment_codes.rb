ActiveAdmin.register AdjustmentCode do
   controller.authorize_resource
   menu :if => proc{ can?(:read, AdjustmentCode) },:parent => "Configuration"
   show :title => :short_name
end
