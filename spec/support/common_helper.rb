def page_should_have_notice
  page.should have_selector(:css, "#contents > p.notice")
end

def page_should_have_alert
  page.should have_selector(:css, "#contents > p.alert")
end

def submit_form
  find(:xpath, './/input[@type="submit"]').click
end

def within_form attributes = {}
  xpath = attributes.map { |key, value| "@#{key}=\"#{value}\"" }.join(' and ')
  xpath = "[#{xpath}]" unless xpath.blank?
  within(:xpath, "//form#{xpath}") do
    yield
  end
end

