require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/menu'

module WinGuiWindowTest

  include WinTestApp
  include Win::Gui::Window

  describe Win::Gui::Menu, ' defines a set of API functions related to menus' do

    describe "#get_menu" do
      before(:all){ @app = launch_test_app }
      after(:all){ close_test_app if @launched_test_app }

      spec{ use{ menu = GetMenu(@app.handle) }}
      spec{ use{ menu = get_menu(@app.handle) }}

      it "retrieves a handle to the menu assigned to the specified top-level window" do
        menu1 = GetMenu(@app.handle)
        menu2 = get_menu(@app.handle)
        menu1.should be_an Integer
        menu1.should == menu2
      end

      it "returns 0/nil if no menu assigned to the specified top-level window" do
        test_app_with_dialog(:close) do |app, dialog|
          GetMenu(dialog).should == 0
          get_menu(dialog).should == nil
        end
      end
    end # describe get_menu

  end # describe Win::Gui::Menu, ' defines a set of API functions related to menus'

#  describe Win::Gui::Menu, ' defines convenience/service methods on top of Windows API' do
#
#  end # Win::Gui::Menu, ' defines convenience/service methods on top of Windows API'
end
