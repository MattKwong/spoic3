module ApplicationHelper
  include Rails.application.routes.url_helpers

  def cancel_link
    return link_to 'Cancel', request.env["HTTP_REFERER"],
      :class => 'cancel',
     :confirm => 'Are you sure? Any changes will be lost.'
  end

# return the title of each page
	def title
		base_title = "Sierra Service Project Online Information Center"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
  end

  def logo
      image_tag("logo.jpg", :alt => "SSP Logo", :class => "round", :width => 75, :height => 75)
  end

  def spoic_graphic
    image_tag("spoic_graphic.jpg", :alt => "SSP Online Information Center", :class => "round", :width => 200, :height => 100)
  end

end
