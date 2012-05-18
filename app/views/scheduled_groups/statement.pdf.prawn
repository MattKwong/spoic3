prawn_document() do |pdf|

logopath = "#{::Rails.root.to_s}/public/images/logo.png"
    pdf.image logopath, :width => 80, :height => 80

    pdf.text "Statement", :align => :center, :style => :bold, :size => 20
    pdf.text "Sierra Service Project"
    pdf.text "PO Box 992"
    pdf.move_up(16)
    pdf.text "Date: #{Date.today}", :align => :right, :style => :bold
    pdf.text "Carmichael, CA 95609"
    pdf.text "916-488-6441"

    pdf.move_down(20)
    pdf.text "Bill To:", :style => :bold
    pdf.text @liaison_name
    pdf.text @church.name
    pdf.move_up(15)
    pdf.text "Site: #{@site_name}", :align => :right
    pdf.text @church.address1
    pdf.move_up(15)
    pdf.text "Period: #{@period_name} (#{@start_date.strftime("%m/%d/%y")} - #{@end_date.strftime("%m/%d/%y")})", :align => :right
    pdf.text "#{@church.city}, #{@church.state} #{@church.zip}"
    pdf.move_up(15)
    pdf.text "Youth Group Name: #{@scheduled_group.name}", :align => :right

    pdf.move_down(30)

    pdf.table(@event_list, :header => true,
            :column_widths => {0 => 60, 1 => 170, 2 => 150, 3 => 70, 4 => 70 },
            :row_colors => ["F0F0F0", "FFFFCC"] ) do
            cells.size = 10
            row(0).style :align => :left
            column(1).style :align => :left
            column(2).style :align => :left
            column(3).style :align => :right
            column(4).style :align => :right
    end

    pdf.move_down(20)
    pdf.text "If you have any questions about this statement call the SSP office at 916-488-6441."
end
