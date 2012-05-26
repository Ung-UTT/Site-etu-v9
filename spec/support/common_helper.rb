def page_should_have_notice
  puts page.body unless valid = page.has_selector?(:css, "#contents > p.notice")
  valid.should be_true
end

def page_should_have_alert
  puts page.body unless valid = page.has_selector?(:css, "#contents > p.alert")
  valid.should be_true
end

def submit_form
  find(:xpath, './/input[@type="submit"]').click
end

def within_form attributes = {}
  xpath = attributes.map { |key, value| " and @#{key}=\"#{value}\"" }.join
  # Don't select the button_to forms (logout, delete, etc...)
  within(:xpath, "//section//form[@class!='button_to'#{xpath}]") do
    yield
  end
end
