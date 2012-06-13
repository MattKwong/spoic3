prawn_document() do |pdf|

logopath = "#{::Rails.root.to_s}/public/images/logo.png"
    pdf.image logopath, :width => 80, :height => 80

    pdf.text "Food Inventory Prep Report", :align => :center, :style => :bold, :size => 20
    pdf.text "Sierra Service Project"
    pdf.text "Date: #{Date.today}", :align => :right, :style => :bold

    pdf.move_down(20)
    pdf.text @program.name

    pdf.move_down(30)

pdf.table(@inventory_list_values, :header => true,
            :column_widths => {0 => 60, 1 => 170, 2 => 150, 3 => 70, 4 => 70 },
            :row_colors => ["F0F0F0", "FFFFCC"] ) do
            cells.size = 10
            row(0).style :align => :left
            column(1).style :align => :left
            column(2).style :align => :left
            column(3).style :align => :right
            column(4).style :align => :right
    end

end