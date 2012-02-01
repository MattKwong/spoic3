class BudgetController < ApplicationController

  def budget_summary
    @title = "Budget Summary"
    params[:type => "summer_domestic"]
    create_summary(params[:type])
  end

private
  def create_summary(type)
    @budget = {}

    @item_names = BudgetItemType.order(:seq_number).all.map { |p| p.name}
    if type == "summer_domestic" then
       @site_names = Site.order(:listing_priority).find_all_by_active_and_summer_domestic(true, true).map { |s| s.name}
       @title = "Domestic Summer Budget"
    else
       @site_names = Site.order(:listing_priority).find_all_by_active_and_summer_domestic(true, false).map { |s| s.name}
       @title = "Special Program Budget"
    end

    @item_ordinal = Array.new
    for i in 0..@item_names.size - 1 do
      @item_ordinal[i] = @item_names[i]
    end

    @site_ordinal = Array.new
    for i in 0..@site_names.size - 1 do
      @site_ordinal[i] = @site_names[i]
    end

    @budget_matrix = Array.new(@item_names.size + 1){ Array.new(@site_names.size + 1, 0)}
    @budget_cell_matrix = Array.new(@item_names.size + 1){ Array.new(@site_names.size + 1, 0)}

    BudgetItem.all.each do |r|
        @site = Site.find(r.site_id)
        @column_position = @site_ordinal.index(@site.name)
        @row_position = @item_ordinal.index(BudgetItemType.find(r.item_id).name)

        @budget_matrix[@row_position][@column_position] += r.amount.to_i
          unless (@column_position.nil? || @row_position.nil?)
        end
    end
# Sum each of the row totals
    @budget_total = 0
    for i in 0..@item_names.size - 1 do
      for j in 0..@site_names.size - 1 do
        @budget_total = @budget_total + @budget_matrix[i][j]
      end
      @budget_matrix[i][@site_names.size] = @budget_total
      @budget_total = 0
    end

#sum each of the columns
    @budget_total = 0
    for j in 0..@site_names.size do
      for i in 0..@item_names.size do
        @budget_total = @budget_total + @budget_matrix[i][j]
      end
      @budget_matrix[@item_names.size][j] = @budget_total
      @budget_total = 0
    end

#Grand total
    @site_names << "Total"
    @item_names << "Total"
    @budget = { :site_count => @site_names.size - 1, :item_count => @item_names.size - 1,
                  :site_names => @site_names, :item_names => @item_names,
                  :budget_matrix => @budget_matrix, :type => type}
  end
end
