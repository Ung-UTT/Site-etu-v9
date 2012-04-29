def page_should_have_notice
  page.should have_selector(:css, "#contents > p.notice")
end

def page_should_have_alert
  page.should have_selector(:css, "#contents > p.alert")
end

def submit_form
  find(:xpath, './/input[@type="submit"]').click
end

