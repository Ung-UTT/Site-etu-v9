require 'spec_helper'

def visit_and_check path
  # visit will fail if there's an error in the view (e.g. AbstractController::DoubleRenderError)
  visit path

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

  `rake routes`.lines.each do |line|
    # not especially neat way of getting routes but didn't find better :/
    next unless route = line.match(/\A\s+(?<name>[^\s]+)\s.+\s(?<path>[^\s]+)\s+(?<controller>[^\s]+)#(?<action>(index|show|new))\Z/)

    # edge cases
    next if route[:controller] == 'cas' and route[:action] == 'new'
    next if route[:controller] == 'devise/unlocks' and route[:action] == 'show'

    # don't test associated resources twice
    next if is_associated_resource?(route[:controller]) and route[:action] == 'show'

    scenario "#{route[:controller]}##{route[:action]} (path: #{route[:path]})" do
      # this also checks that every route has the controller and the action defined
      # i.e. routing specs - the lazy way!

      case route[:action]
      when 'index', 'new'
        if is_associated_resource? route[:controller]
          # create a comment/document from factory
          associated_object = create(route[:controller].singularize)

          # the commentable/documentable class name (e.g. asso, course, etc.)
          base_object_name = route[:path].match(/\A\/[^\/]+\/:(?<class>[^\/]+)_id\/#{route[:controller]}/)[:class]

          base_object = create base_object_name
          base_object.send(route[:controller]) << associated_object

          path = send("#{route[:name]}_path", base_object)
        else
          path = send("#{route[:name]}_path") # non-nested route
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

      when 'show'
        model = route[:controller].singularize
        object = create model

        path = send("#{route[:name]}_path", object)
        visit_and_check path

        # assert we haven't been somehow redirected
        current_path.should == path

      else
        raise "WTF? Route parsing error?"
      end
    end
  end
end

