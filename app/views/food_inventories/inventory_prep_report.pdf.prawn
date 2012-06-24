prawn_document(:page_layout => :landscape) do |pdf|

    logopath = "#{::Rails.root.to_s}/public/images/logo.png"
    pdf.image logopath, :width => 40, :height => 40
    pdf.text "Food Inventory Prep Report", :align => :center, :style => :bold, :size => 20
    pdf.text "Sierra Service Project"
    pdf.text "Date: #{Date.today}", :align => :right, :style => :bold

    pdf.move_down(10)
    pdf.text @program.name

    pdf.move_down(10)

pdf.table(@inventory_list_values, :header => true,
            :column_widths => {0 => 70, 1 => 90, 2 => 40, 3 => 60, 4 => 60, 5 => 60, 6 => 50, 7 => 60, 8 => 60, 9 => 60, 10 => 60, 11 => 50 },
            :row_colors => ["F0F0F0", "FFFFCC"] ) do
            cells.size = 10
            row(0).style :align => :left
            column(1).style :align => :left
            column(2).style :align => :left
            column(3).style :align => :left
            column(4).style :align => :left
            column(5).style :align => :left
            column(6).style :align => :left
            column(7).style :align => :left
            column(8).style :align => :left
            column(9).style :align => :left
            column(10).style :align => :left
    end

end