require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/menu'

module WinGuiWindowTest

  include WinTestApp
  include Win::Gui::Window

  describe Win::Gui::Menu, ' defines a set of API functions related to menus' do
    before(:all)do
      @app = launch_test_app
      @menu_handle = get_menu(@app.handle)
      @file_menu_handle = get_sub_menu(@menu_handle, 0)
    end
    after(:all){ close_test_app if @launched_test_app }

    describe "#get_menu" do

      spec{ use{ menu = GetMenu(@app.handle) }}
      spec{ use{ menu = get_menu(@app.handle) }}

      it "retrieves a handle to the menu assigned to the specified top-level window" do
        menu1 = GetMenu(@app.handle)
        menu2 = get_menu(@app.handle)
        menu1.should be_an Integer
        menu1.should == @menu_handle
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

      spec{ use{ num_items = GetMenuItemCount(@menu_handle) }}
      spec{ use{ num_items = get_menu_item_count(@menu_handle) }}

      it "determines the number of items in the specified menu. " do
        GetMenuItemCount(@menu_handle).should == 3
        get_menu_item_count(@menu_handle).should == 3
      end

      it "returns -1/nil if function fails " do
        GetMenuItemCount(not_a_handle).should == -1
        get_menu_item_count(not_a_handle).should == nil
      end
    end # describe get_menu_item_count

    describe "#get_menu_item_id" do
      spec{ use{ item_id = GetMenuItemID(@menu_handle, pos=0) }}
      spec{ use{ item_id = get_menu_item_id(@menu_handle, pos=0) }}

      it "retrieves the menu item identifier of a menu item located at the specified position" do
        p item_id = GetMenuItemID(@file_menu_handle, pos=0)
        p item_id = get_menu_item_id(@file_menu_handle, pos=0)
      end

      it "returns 0/nil if no menu item at given position" do
        GetMenuItemID(@menu_handle, pos=4).should == -1
        get_menu_item_id(@menu_handle, pos=4).should == nil
      end

      it "returns 0/nil if given menu item is in fact submenu" do
        GetMenuItemID(@menu_handle, pos=0).should == -1
        get_menu_item_id(@menu_handle, pos=1).should == nil
      end
    end # describe get_menu_item_id

    describe "#get_sub_menu" do
      spec{ use{ sub_menu = GetSubMenu(@menu_handle, pos=0) }}
      spec{ use{ sub_menu = get_sub_menu(@menu_handle, pos=0) }}

      it "retrieves a handle to the drop-down menu or submenu activated by the specified menu item" do
        sub_menu1 = GetSubMenu(@menu_handle, pos=0)
        sub_menu2 = get_sub_menu(@menu_handle, pos=0)
        sub_menu1.should be_an Integer
        sub_menu1.should == @file_menu_handle
        sub_menu1.should == sub_menu2
      end

      it "snake_case api retrieves a handle to the drop-down menu or submenu activated by the specified " do
        pending
        success = get_sub_menu(h_menu=0, n_pos=0)
      end
    end # describe get_sub_menu

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