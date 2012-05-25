require 'spec_helper'

def visit_and_check path
  # visit will fail if there's an error in the view (e.g. AbstractController::DoubleRenderError)
  visit path

  check_page
end

def check_page
  # assert there's no 404.png, 500.png or the like
  page.body.should_not have_xpath("//img[starts-with(@src, '/assets/errors/')]")
end

def is_associated_resource? controller
  # polymorphicable classes
  %(comments documents).include? controller
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
    next if %w(rails/info cas).include?(controller) or
      # Actions not tested
      %w(update join disjoin render_not_found deploy).include?(action) or
      (controller.start_with? 'devise/' and %w(create edit destroy).include?(action)) or
      (controller == 'annals' and action == 'create') or # Already tested
      # FIXME: Special validation
      (controller == 'projects' and %w(create destroy).include?(action)) or
      # FIXME: Test associated resources (comments and documents)
      (is_associated_resource?(controller) and %(show create destroy).include?(action))

    scenario "#{controller}##{action} (path: #{path})" do
      # this also checks that every route has the controller and the action defined
      # i.e. routing specs - the lazy way!

      case action
      when 'index', 'new'
        object = create model if action == 'index' and controller != 'home'

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
        if %w[
          /users/sign_in
          /users/password/new
          /users/unlock/new
          /wikis
        ].include?(path)
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
