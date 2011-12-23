ActiveAdmin.register DownloadableDocument do
  menu :parent => "Configuration"
  show :title => :name

  form do |f|
    f.inputs "Church Details" do
      f.input :name
      f.input :url
      f.input :description
      f.input :doc_type
      f.input :active
    end
    f.buttons
  end
end
