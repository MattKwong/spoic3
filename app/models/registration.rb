class Registration < ActiveRecord::Base
  belongs_to :church
  attr_accessible :name,:comments, :liaison_id, :request1, :request2, :request3,
                  :request4, :request5, :request6,:request7, :request8, :request9,
                  :request10, :requested_counselors, :requested_youth,
                  :requested_total, :scheduled,  :amount_due, :amount_paid, :payment_method,
                  :payment_notes, :group_type_id, :church_id, :registration_step, :id
    has_many :payments

   validates :name, :requested_youth, :requested_counselors, :presence => true
   validates_numericality_of :requested_youth, :requested_counselors,
                             :only_integer => true, :greater_than => 0


 #TODO: Test that the requested totals don't exceed the limit which is currently 30'

  with_options :if => :step2? do |registration|
    registration.validates_presence_of :request1
    registration.validates_numericality_of :request1, :only_integer => true, :greater_than => 0, :message => "must be valid request"
    registration.validate :request_sequence, :message => "All requests must be made in order."
    registration.validate :check_for_duplicate_choices, :message => "You may not select the same session twice."
  end

  with_options :if => :step3? do |registration|
    registration.validates_presence_of :amount_paid, :payment_method
    registration.validates_numericality_of :amount_paid, :greater_than => 0
  end

  private
  def step1?
    registration_step == 'Step 1'
  end
  def step2?
    registration_step == 'Step 2'
  end
  def step3?
    registration_step == 'Step 3'
  end
  def request_sequence
  #This routine fails if there are any non-requests within the sequence of requests.
  a = [request1, request2, request3, request4, request5, request6, request7,
       request8, request9, request10]

  first_nil = a.index{|i| i.nil?}

    unless first_nil.nil?
      suba = a.slice(first_nil, a.size - first_nil)
      next_non_nil = suba.index{|i| i != nil}
      unless next_non_nil.nil?
        error_item = next_non_nil + first_nil
        no_request_message = "A request is required here."
        case error_item
          when 1
            errors.add(:request1, no_request_message)
          when 2
            errors.add(:request2, no_request_message)
          when 3
            errors.add(:request3, no_request_message)
          when 4
            errors.add(:request4, no_request_message)
          when 5
            errors.add(:request5, no_request_message)
          when 6
            errors.add(:request6, no_request_message)
          when 7
            errors.add(:request7, no_request_message)
          when 8
            errors.add(:request8, no_request_message)
          when 9
            errors.add(:request9, no_request_message)
          when 10
            errors.add(:request10, no_request_message)
        end
      end
    end
  end

  def check_for_duplicate_choices

    a = [request1, request2, request3, request4, request5, request6, request7,
       request8, request9, request10]
    a.map! { |i| if i == 0 then i = nil else i end }    # eliminate cases were zeroes are entered for no choice.
    first_nil = a.index{|i| i.nil?}
    if first_nil.nil?
      first_nil = 9
    end

    violations = Array.new
#  first_nil += 1
    a = a.slice(0, first_nil)
    for i in 1..first_nil - 1 do
      test_value = a.shift
      dup_location = a.index(test_value)
      if dup_location
        violations.push(i + dup_location + 1)
      end
    end

  #if violations is nil, then everything passes.
    if violations.size > 0
      error_item = violations.first
      dup_request_message = "Duplicate requests are not permitted."
      case error_item
        when 1
          errors.add(:request1, dup_request_message )
        when 2
          errors.add(:request2, dup_request_message )
        when 3
          errors.add(:request3, dup_request_message )
        when 4
          errors.add(:request4, dup_request_message )
        when 5
          errors.add(:request5, dup_request_message )
        when 6
          errors.add(:request6, dup_request_message )
        when 7
          errors.add(:request7, dup_request_message )
        when 8
          errors.add(:request8, dup_request_message )
        when 9
          errors.add(:request9, dup_request_message )
        when 10
          errors.add(:request10, dup_request_message )
      end
    end
  end
end
