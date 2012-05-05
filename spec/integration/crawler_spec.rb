require 'spec_helper'

feature "It does not raise any errors while browsing as an administrator" do # what a cool feature, huh?
  def visit_and_check path
    # visit will fail if there's a error in the view (e.g. AbstractController::DoubleRenderError)
    visit path

    # assert there's no 404.png, 500.png or the like
    page.body.should_not have_xpath("//img[starts-with(@src, '/assets/errors/')]")
  end

  background do
    # browse as an administrator so he can see everything on all pages
    user = create :administrator
    sign_in user.login, user.password
  end

  `rake routes`.lines.each do |line|
    # not especially neat way of getting routes but didn't find better :/
    next unless route = line.match(/\A\s+(?<name>[^\s]+)\s.+\s(?<path>[^\s]+)\s+(?<controller>[^\s]+)#(?<action>(index|show|new))\Z/)

    scenario "#{route[:controller]}##{route[:action]} (path: #{route[:path]})" do
      # this also checks that every route has the controller and the action defined
      # i.e. routing specs - the lazy way!

      case route[:action]
      when 'index', 'new'
        next if route[:controller] == 'cas' and route[:action] == 'new' # edge case

        begin
          path = send("#{route[:name]}_path")
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

        rescue ActionController::RoutingError
          # skip comments and documents
          pending "skipping nested routes for now" # FIXME
        end

      when 'show'
        next if route[:controller] == 'devise/unlocks' # edge case

        begin
          model = route[:controller].singularize
          object = create model

          path = send("#{route[:name]}_path", object)
          visit_and_check path

          # assert we haven't been somehow redirected
          current_path.should == path

        rescue ActionController::RoutingError
          # skip comments and documents
          pending "skipping nested routes for now" # FIXME
        end

      else
        raise "WTF"
      end
    end
  end
end

