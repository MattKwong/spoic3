class Report

  def initialize
    @programs = Program.current
  end

  def all_programs
    @programs
  end

  def spending_without_tax(budget_item_type_id, start_date, end_date)
      (ItemPurchase.by_budget_line_type(budget_item_type_id).between_dates(start_date, end_date).map &:total_price).sum
  end

  def spending_with_tax(budget_item_type_id, start_date, end_date)
      (ItemPurchase.by_budget_line_type(budget_item_type_id).between_dates(start_date, end_date).map &:total_price_with_tax).sum
  end
  def spending_with_tax_total(start_date, end_date)
    (ItemPurchase.between_dates(start_date, end_date).map &:total_price_with_tax).sum
  end

end
