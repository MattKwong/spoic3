ActiveAdmin.register Registration do
  menu :priority => 2, :label => "Requests"
  scope :high_school_unscheduled, :label => "HS Unscheduled"
  scope :scheduled
  scope :unscheduled, :default => true

 index do
    column :name do |r|
      link_to r.name, schedule_request_path(:id => r.id)
    end

    column :liaison_id do |liaison|
      link_to liaison.liaison.name, admin_liaison_path(liaison.liaison_id)
    end
    column :church_id do |church|
      link_to church.church.name, admin_church_path(church.church_id)
    end

    column :requested_youth, :label => "Youth"
    column :requested_counselors, :label => "Counselors"
    column :requested_total, :label => "Total"
    column :scheduled
    default_actions
 end

   show :title => :name do
    panel "Request Details " do
      attributes_table_for registration do
        row("Registration Name") {registration.name}
        row("Registration Type") {registration.group_type_id}
        row("Liaison") {registration.liaison}
        row("Request1") {registration.request1}
        row("Request2") {registration.request2}
        row("Request3") {registration.request3}
        row("Request4") {registration.request4}
        row("Request5") {registration.request5}
        row("Request6") {registration.request6}
        row("Request7") {registration.request7}
        row("Request8") {registration.request8}
        row("Request9") {registration.request9}
        row("Request10") {registration.request10}
        row("Counselors") {registration.requested_counselors}
        row("Youth") {registration.requested_youth}
        row("Total") {registration.requested_total}
        row("Scheduled") {registration.scheduled}
        row("Amount paid") {registration.amount_paid}
        row("Amount due") {registration.amount_due}
        row("Payment method") {registration.payment_method}
        row("Payment notes") {registration.payment_notes}
        row("Registration step") {registration.registration_step}
        row("Comments") {registration.comments}
        row("Created at") {registration.created_at}
        row("Updated at") {registration.updated_at}
      end
    end
  end
end
