require 'spec_helper'

def visit_and_check path
  # visit will fail if there's an error in the view (e.g. DoubleRenderError)
  visit path

  check_page
end

def check_page
  # assert there's no 404.png, 500.png or the like
  puts page.body unless valid = page.has_no_xpath?("//img[starts-with(@src, '/assets/errors/')]")
  valid.should be_true
end

def is_associated_resource? controller
  # polymorphicable classes
  controller.in?(%w[comments documents])
end

feature "It does not raise any errors while browsing as an administrator" do # what a cool feature, huh?
  background do
    # browse as an administrator so he can see everything on all pages
    user = create :administrator
    sign_in user.login, user.password
  end

  # Get ALL routes available
  routes = Rails.application.routes.routes.to_a

  # Test each valid routes
  routes.each do |route|
    next if route.defaults.empty?

    name = route.name # Example: projects_path
    path = route.path.spec.to_s.gsub('(.:format)','') # Example: /projects
    controller = route.defaults[:controller] # Example: projects
    action = route.defaults[:action] # Example: index
    model = controller.singularize # Example: project

    # Remove Rails internal routes (assets, ...) and not tested routes
    next if controller.in?(%w[rails/info cas]) or
      # Actions not tested
      action.in?(%w[update join disjoin render_not_found deploy]) or
      (controller.start_with? 'devise/' and action.in?(%w[create edit destroy])) or
      # FIXME: Special validation
      (controller.in?(%w[projects annals]) and action.in?(%w[create destroy])) or
      # FIXME: Test associated resources (comments and documents)
      (is_associated_resource?(controller) and action.in?(%w[show create destroy]))

    scenario "#{controller}##{action} (path: #{path})" do
      # this also checks that every route has the controller and the action defined
      # i.e. routing specs - the lazy way!

      case action
      when 'index', 'new'
        # Create at least two objects (because some controllers redirect when
        # there is only one object
        if action == 'index' and controller != 'home'
          create model
          object = create model
        end

        if is_associated_resource? controller
          # the commentable/documentable class name (e.g. asso, course, etc.)
          base_object_name = path.match(/\A\/[^\/]+\/:(?<class>[^\/]+)_id\/#{controller}/)[:class]

          base_object = create base_object_name # Create the course, asso, ...
          base_object.send(controller) << object # Add the comment/document

          path = send("#{name}_path", base_object) # Get the right path
        else
          path = send("#{name}_path") # non-nested route
        end

        visit_and_check path

        # white-list of paths that should redirect when signed in
        if path.in?(%w[
          /users/sign_in
          /users/password/new
          /users/unlock/new
          /wikis])
          current_path.should_not == path
        else
          current_path.should == path
        end
      when 'show', 'edit'
        object = create model

        path = send("#{name}_path", object)
        visit_and_check path

        if action == 'show'
          # assert we haven't been somehow redirected
          current_path.should == path
        else
          # submit the form with no changes
          within_form { submit_form }

          # should be successful
          page_should_have_notice

          # should display the object page
          object_path = send("#{model}_path", object)
          current_path.should == object_path
        end
      when 'create'
        path = "/#{controller}"
        attributes = attributes_for model
        klass = model.classify.constantize

        expect {
          page.driver.post(path, { model => attributes })
        }.to change{klass.count}.by(1)

        check_page
      when 'destroy'
        object = create model
        path = "/#{controller}/#{object.id}"
        klass = model.classify.constantize

        expect {
          page.driver.delete(path)
        }.to change{klass.count}.by(-1)

        check_page
      else
        # Other actions: rules, about, ...
        visit_and_check path
      end
    end
  end
end
