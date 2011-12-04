describe AlbumsController, "#show" do
  context "for a fictionnal album" do
    before do
      get :show, :id => 1
    end

    it { should assign_to(:album) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should_not set_the_flash }
  end
end

describe AlbumsController, "#index" do
  it { should assign_to(:albums) }
  it { should respond_with(:success) }
  it { should render_template(:index) }
  it { should_not set_the_flash }
end
