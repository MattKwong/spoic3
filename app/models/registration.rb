class Registration < ActiveRecord::Base
  attr_accessible :name,:comments, :current_counselors, :current_youth,
                  :current_total, :liaison_id, :request1, :request2, :request3,
                  :request4, :request5, :request6,:request7, :request8, :request9,
                  :request10, :requested_counselors, :requested_youth,
                  :requested_total, :scheduled, :scheduled_priority,
                  :scheduled_session, :amount_due, :amount_paid, :payment_method,
                  :payment_notes, :group_type_id
  has_many :payments

  validates :name, :requested_youth, :requested_counselors, :request1, :presence => true
  validates_numericality_of :requested_youth, :requested_counselors,
                            :only_integer => true, :greater_than => 0
  validates_numericality_of :request1

  validate :request_sequence
  validate :check_for_duplicate_choices

  def request_sequence
  #This routine fails if there are any non-requests within the sequence of requests.
  a = [request1, request2, request3, request4, request5, request6, request7,
       request8, request9, request10]
  first_nil = a.index{|i| i.nil?}

    unless first_nil.nil?
      suba = a.slice(first_nil, a.size - first_nil)
      next_non_nil = suba.index{|i| i != nil}
      unless next_non_nil.nil?
        error_item = next_non_nil + first_nil + 1
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
        end
      end
    end
  end

  def check_for_duplicate_choices

    #TODO this routine doesn't appear to work'
    a = [request1, request2, request3, request4, request5, request6, request7,
       request8, request9, request10]
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
