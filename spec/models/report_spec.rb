require 'spec_helper'

describe Report do
  before :each do
    @program_attr = {:site_id => Site.find_by_name('Test Site 1').id, :start_date => Date.strptime("06/01/2012", "%m/%d/%Y"),
                     :end_date => Date.strptime("08/31/2012", "%m/%d/%Y"),
                     :program_type_id => ProgramType.find_by_name("Summer Domestic").id, :active => true,
                     :name => "Test Program 1", :short_name  => "TP 1"}
  end

  it "should return a list of all active programs" do
    report = Report.new
    test_prog1 = Program.create!(@program_attr)
    report.all_programs.count.should == 1
  end

  it "should return the correct program id" do
    report = Report.new
    test_prog1 = Program.create!(@program_attr)
    report.all_programs.first.id == test_prog1.id
  end

  describe "spending calculation tests" do

    it "given a budget item id and no purchase items, should return zero" do
      report = Report.new
      report.spending_without_tax(BudgetItemType.find_by_name("Food").id).should == 0
    end

    describe "purchases of non taxable items with no program specified" do
      before :each do
        @test_prog1 = Program.create!(@program_attr)
        @item1 = Item.create!(:name => "Test food item", :base_unit => 'oz', :default_taxed => false, :description => 'Test food item description',
                              :budget_item_type_id => BudgetItemType.find_by_name("Food").id, :untracked => false, :item_type_id => 1, :item_category_id => 1)
        @vendor1 = Vendor.create!(:site_id => @test_prog1.site_id, :name => 'Test Vendor 1', :address => '1 First St.', :city => 'Los Angeles', :state => 'CA',
                                  :zip => '90037', :phone => '123-456-7890' )
        @purchase1 = Purchase.create!(:date => Date.today, :program_id => @test_prog1.id, :purchaser_id => 1, :tax => 0, :total => 500.00,
                                      :vendor_id => @vendor1.id, :purchase_type => 'Credit' )
      end

      it "given a budget item id, should return the amount spent without tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item1.id, :price => 5.00, :purchase_id => @purchase1.id, :quantity => 100,
            :taxable => false, :size => '1 lbs', :uom => "oz")
        report.spending_without_tax(BudgetItemType.find_by_name("Food").id).should == 500.00
      end

      it "given a budget item id, should return the amount spent with tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item1.id, :price => 5.00, :purchase_id => @purchase1.id, :quantity => 100,
                             :taxable => false, :size => '1 lbs', :uom => "oz")
        report.spending_with_tax(BudgetItemType.find_by_name("Food").id).should == 500.00
      end
    end
    describe "purchases of taxable items with no program specified" do
      before :each do
        @test_prog1 = Program.create!(@program_attr)
        @item2 = Item.create!(:name => "Test material item", :base_unit => 'each', :default_taxed => true, :description => 'Test material item description',
           :budget_item_type_id => BudgetItemType.find_by_name("Materials").id, :untracked => true, :item_type_id => 1, :item_category_id => 1)
        @vendor1 = Vendor.create!(:site_id => @test_prog1.site_id, :name => 'Test Vendor 1', :address => '1 First St.', :city => 'Los Angeles', :state => 'CA',
           :zip => '90037', :phone => '123-456-7890' )
        @purchase2 = Purchase.create!(:date => Date.today, :program_id => @test_prog1.id, :purchaser_id => 1, :tax => 8.50, :total => 100.00,
           :vendor_id => @vendor1.id, :purchase_type => 'Credit' )
      end

      it "given a budget item id, should return the amount spent without tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
            :taxable => true, :size => 'each', :uom => "each")
        report.spending_without_tax(BudgetItemType.find_by_name("Materials").id).should == 91.50
      end

      it "given a budget item id, should return the amount spent with tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
                             :taxable => true, :size => 'each', :uom => "each")
        report.spending_with_tax(BudgetItemType.find_by_name("Materials").id).should be_within(0.005).of(100.00)
      end
    end
    describe "purchases of non taxable items with a program specified" do
      before :each do
        @test_prog1 = Program.create!(@program_attr)
        @item1 = Item.create!(:name => "Test food item", :base_unit => 'oz', :default_taxed => false, :description => 'Test food item description',
                              :budget_item_type_id => BudgetItemType.find_by_name("Food").id, :untracked => false, :item_type_id => 1, :item_category_id => 1)
        @vendor1 = Vendor.create!(:site_id => @test_prog1.site_id, :name => 'Test Vendor 1', :address => '1 First St.', :city => 'Los Angeles', :state => 'CA',
                                  :zip => '90037', :phone => '123-456-7890' )
        @purchase1 = Purchase.create!(:date => Date.today, :program_id => @test_prog1.id, :purchaser_id => 1, :tax => 0, :total => 500.00,
                                      :vendor_id => @vendor1.id, :purchase_type => 'Credit' )
      end

      it "given a budget item id, should return the amount spent without tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item1.id, :price => 5.00, :purchase_id => @purchase1.id, :quantity => 100,
                             :taxable => false, :size => '1 lbs', :uom => "oz")
        @test_prog1.budget_item_spent(BudgetItemType.find_by_name("Food").id).should == 500.00
      end

      it "given a budget item id, should return the amount spent with tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item1.id, :price => 5.00, :purchase_id => @purchase1.id, :quantity => 100,
                             :taxable => false, :size => '1 lbs', :uom => "oz")
        @test_prog1.budget_item_spent(BudgetItemType.find_by_name("Food").id).should == 500.00
      end
    end
    describe "purchases of taxable items with no program specified" do
      before :each do
        @test_prog1 = Program.create!(@program_attr)
        @item2 = Item.create!(:name => "Test material item", :base_unit => 'each', :default_taxed => true, :description => 'Test material item description',
                              :budget_item_type_id => BudgetItemType.find_by_name("Materials").id, :untracked => true, :item_type_id => 1, :item_category_id => 1)
        @vendor1 = Vendor.create!(:site_id => @test_prog1.site_id, :name => 'Test Vendor 1', :address => '1 First St.', :city => 'Los Angeles', :state => 'CA',
                                  :zip => '90037', :phone => '123-456-7890' )
        @purchase2 = Purchase.create!(:date => Date.today, :program_id => @test_prog1.id, :purchaser_id => 1, :tax => 8.50, :total => 100.00,
                                      :vendor_id => @vendor1.id, :purchase_type => 'Credit' )
      end

      it "given a budget item id, should return the amount spent without tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
                             :taxable => true, :size => 'each', :uom => "each")
        @test_prog1.budget_item_spent(BudgetItemType.find_by_name("Materials").id).should == 91.50
      end

      it "given a budget item id, should return the amount spent with tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
                             :taxable => true, :size => 'each', :uom => "each")
        @test_prog1.budget_item_spent_with_tax(BudgetItemType.find_by_name("Materials").id).should be_within(0.005).of(100.00)
      end
    end
    describe "purchases of taxable items with no program specified with multiple sites" do
      before :each do
        @test_prog1 = Program.create!(@program_attr)
        @test_prog2 = Program.create!(@program_attr.merge(:site_id => Site.find_by_name('Test Site 2').id,
                                                          :name => "Test Program 2", :short_name  => "TP 2"))
        @item2 = Item.create!(:name => "Test material item", :base_unit => 'each', :default_taxed => true, :description => 'Test material item description',
                              :budget_item_type_id => BudgetItemType.find_by_name("Materials").id, :untracked => true, :item_type_id => 1, :item_category_id => 1)
        @vendor1 = Vendor.create!(:site_id => @test_prog1.site_id, :name => 'Test Vendor 1', :address => '1 First St.', :city => 'Los Angeles', :state => 'CA',
                                  :zip => '90037', :phone => '123-456-7890' )
        @purchase2 = Purchase.create!(:date => Date.today, :program_id => @test_prog1.id, :purchaser_id => 1, :tax => 8.50, :total => 100.00,
                                      :vendor_id => @vendor1.id, :purchase_type => 'Credit' )
      end

      it "given a budget item id, should return the amount spent without tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
                             :taxable => true, :size => 'each', :uom => "each")
        @test_prog2.budget_item_spent(BudgetItemType.find_by_name("Materials").id).should == 0.00
      end

      it "given a budget item id, should return the amount spent with tax" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
                             :taxable => true, :size => 'each', :uom => "each")
        @test_prog2.budget_item_spent_with_tax(BudgetItemType.find_by_name("Materials").id).should be_within(0.005).of(0.00)
      end
      it "should return the total amount spent with tax for all programs" do
        report = Report.new
        ItemPurchase.create!(:item_id => @item2.id, :price => 45.75, :purchase_id => @purchase2.id, :quantity => 2,
                             :taxable => true, :size => 'each', :uom => "each")
        report.spending_with_tax_total.should be_within(0.005).of(100.00)
      end
    end
  end
end
