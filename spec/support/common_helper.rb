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
  xpath = attributes.map { |key, value| " and @#{key}=\"#{value}\"" }.join
  # Don't select the button_to forms (logout, delete, etc...)
  within(:xpath, "//form[@class!='button_to'#{xpath}]") do
    yield
  end
end
