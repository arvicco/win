require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/menu'

module WinGuiWindowTest

  include WinTestApp
  include Win::Gui::Window

  describe Win::Gui::Menu, ' defines a set of API functions related to menus' do
    before(:all){ @app = launch_test_app }
    after(:all){ close_test_app if @launched_test_app }

    describe "#get_menu" do

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

    describe "#get_system_menu" do
      spec{ use{ system_menu = GetSystemMenu(any_handle, reset=0) }}
      spec{ use{ system_menu = get_system_menu(any_handle, reset=false) }}

      it "with reset=0/false(default) allows the application to access the window menu (AKA system menu)" do
        menu1 = GetSystemMenu(@app.handle, reset=0)
        menu2 = get_system_menu(@app.handle, reset=0)
        menu3 = get_system_menu(@app.handle)
        menu1.should be_an Integer
        menu1.should == menu2
        menu1.should == menu3
      end

      it "with reset=1/true allows the application to reset its window menu to default, returns 0/nil" do
        GetSystemMenu(@app.handle, reset=1).should == 0
        get_system_menu(@app.handle, reset=true).should == nil
      end
    end # describe get_system_menu

    describe "#get_menu_item_count" do
      before(:all){ @menu_handle = get_menu(@app.handle) }

      spec{ use{ num_items = GetMenuItemCount(@menu_handle) }}
      spec{ use{ num_items = get_menu_item_count(@menu_handle) }}

      it "determines the number of items in the specified menu. " do
        p num_items = GetMenuItemCount(@menu_handle)
        p num_items = get_menu_item_count(@menu_handle)
      end

      it "returns -1/nil if function fails " do
        pending
        GetMenuItemCount(not_a_handle).should == -1
        get_menu_item_count(not_a_handle).should == nil
      end
    end # describe get_menu_item_count

    describe "#is_menu" do
      before(:all){ @menu_handle = get_menu(@app.handle) }

      spec{ use{ success = IsMenu(@menu_handle) }}
      spec{ use{ success = menu?(@menu_handle) }}

      it "determines whether a given handle is a menu handle " do
        IsMenu(@menu_handle).should == 1
        is_menu(@menu_handle).should == true
        menu?(@menu_handle).should == true
        IsMenu(not_a_handle).should == 0
        is_menu(not_a_handle).should == false
        menu?(not_a_handle).should == false
      end
    end # describe is_menu
  end # describe Win::Gui::Menu, ' defines a set of API functions related to menus'

#  describe Win::Gui::Menu, ' defines convenience/service methods on top of Windows API' do
#  end # Win::Gui::Menu, ' defines convenience/service methods on top of Windows API'
end
