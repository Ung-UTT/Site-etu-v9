if defined?(Footnotes) && Rails.env.development?
  Footnotes.run! # first of all

  Footnotes::Filter.notes -= [
    :controller, :view, :layout, :partials, :stylesheets, :javascripts
  ]
end
