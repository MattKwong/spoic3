prawn_document() do |pdf|

pdf.text "Sierra Service Project"
pdf.move_up(16)
pdf.text "INVOICE", :align => :right, :style => :bold
pdf.text "PO Box 992"
pdf.move_up(16)
pdf.text "Date: #{Date.today}", :align => :right, :style => :bold
pdf.text "Carmichael, CA 95609"
pdf.text "916-488-6441"
pdf.move_down(10)
pdf.text "Bill To:", :style => :bold
pdf.move_up(15)
pdf.text "Please return a copy of this invoice with your payment", :style => :bold, :align => :right
pdf.text @screen_info[:liaison_name]
pdf.text @screen_info[:church_info].name
        pdf.move_up(15)
pdf.text "Site: #{@screen_info[:site_name]}", :align => :right
pdf.text @screen_info[:church_info].address1
        pdf.move_up(15)
pdf.text "Period: #{@screen_info[:period_name]} (#{@screen_info[:start_date].strftime("%m/%d/%y")} - #{@screen_info[:end_date].strftime("%m/%d/%y")})", :align => :right
pdf.text "#{@screen_info[:church_info].city}, #{@screen_info[:church_info].state} #{@screen_info[:church_info].zip}"
        pdf.move_up(15)
        pdf.text "Group Name: #{@screen_info[:scheduled_group].name}", :align => :right

        pdf.move_down(30)

        pdf.table @screen_info[:invoice_items]

        pdf.move_down(60)
        pdf.text "If you have any questions about this invoice call the SSP office at 916-488-6441."






end