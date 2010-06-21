require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/menu'

module WinGuiWindowTest

  include WinTestApp
  include Win::Gui::Window

  describe Win::Gui::Menu, ' defines a set of API functions related to menus' do
    context 'non-destructive methods' do
      before(:all)do
        @app = launch_test_app
        @menu = get_menu(@app.handle)
        @file_menu = get_sub_menu(@menu, 0)
      end
      after(:all){ close_test_app if @launched_test_app }

      describe "#get_menu" do

        spec{ use{ menu = GetMenu(@app.handle) }}
        spec{ use{ menu = get_menu(@app.handle) }}

        it "retrieves a handle to the menu assigned to the specified top-level window" do
          menu1 = GetMenu(@app.handle)
          menu2 = get_menu(@app.handle)
          menu1.should be_an Integer
          menu1.should == @menu
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

        spec{ use{ num_items = GetMenuItemCount(@menu) }}
        spec{ use{ num_items = get_menu_item_count(@menu) }}

        it "determines the number of items in the specified menu. " do
          GetMenuItemCount(@menu).should == 3
          get_menu_item_count(@menu).should == 3
        end

        it "returns -1/nil if function fails " do
          GetMenuItemCount(not_a_handle).should == -1
          get_menu_item_count(not_a_handle).should == nil
        end
      end # describe get_menu_item_count

      describe "#get_menu_item_id" do
        spec{ use{ item_id = GetMenuItemID(@menu, pos=0) }}
        spec{ use{ item_id = get_menu_item_id(@menu, pos=0) }}

        it "retrieves the menu item identifier of a menu item located at the specified position" do
          GetMenuItemID(@file_menu, pos=0).should == ID_FILE_SAVE_AS
          get_menu_item_id(@file_menu, pos=0).should == ID_FILE_SAVE_AS
        end

        it "returns -1/nil if no menu item at given position" do
          GetMenuItemID(@menu, pos=4).should == -1
          get_menu_item_id(@menu, pos=4).should == nil
        end

        it "returns -1/nil if given menu item is in fact a sub-menu" do
          GetMenuItemID(@menu, pos=0).should == -1
          get_menu_item_id(@menu, pos=1).should == nil
        end
      end # describe get_menu_item_id

      describe "#get_sub_menu" do
        spec{ use{ sub_menu = GetSubMenu(@menu, pos=0) }}
        spec{ use{ sub_menu = get_sub_menu(@menu, pos=0) }}

        it "retrieves a handle to the drop-down menu or submenu activated by the specified menu item" do
          sub_menu1 = GetSubMenu(@menu, pos=0)
          sub_menu2 = get_sub_menu(@menu, pos=0)
          sub_menu1.should be_an Integer
          sub_menu1.should == @file_menu
          sub_menu1.should == sub_menu2
        end

        it "returns 0/nil if unable to find submenu activated by the specified menu item" do
          GetSubMenu(@file_menu, pos=0).should == 0
          get_sub_menu(@file_menu, pos=0).should == nil
        end
      end # describe get_sub_menu

      describe "#is_menu" do
        before(:all){ @menu = get_menu(@app.handle) }

        spec{ use{ success = IsMenu(@menu) }}
        spec{ use{ success = menu?(@menu) }}

        it "determines whether a given handle is a menu handle " do
          IsMenu(@menu).should == 1
          is_menu(@menu).should == true
          menu?(@menu).should == true
          menu?(@file_menu).should == true
          IsMenu(not_a_handle).should == 0
          is_menu(not_a_handle).should == false
          menu?(not_a_handle).should == false
        end
      end # describe is_menu

      describe "#set_menu" do
        spec{ use{ success = SetMenu(window_handle=0, menu_handle=0) }}
        spec{ use{ success = set_menu(window_handle=0, menu_handle=0) }}

        it "assigns/removes menu of the specified top-level window" do
          SetMenu(@app.handle, menu_handle=0)
          get_menu(@app.handle).should == nil
          SetMenu(@app.handle, @menu)
          menu(@app.handle).should == @menu
          set_menu(@app.handle)
          menu(@app.handle).should == nil
          set_menu(@app.handle, @menu)
          menu(@app.handle).should == @menu
        end

        it "snake_case api with nil, zero or omitted menu_handle removes menu" do
          [[@app.handle, 0], [@app.handle, nil], [@app.handle]].each do |args|
            set_menu(*args)
            menu(@app.handle).should == nil
            set_menu(@app.handle, @menu)
          end
        end
      end # describe set_menu

      describe "#create_menu" do
        after(:each){ destroy_menu(@new_menu) }

        spec{ use{ @new_menu = CreateMenu() }}
        spec{ use{ @new_menu = create_menu() }}

        it "original api creates a menu. The menu is initially empty, but it can be filled with menu items" do
          @new_menu = CreateMenu()
          menu?(@new_menu).should == true
        end

        it "snake_case api creates a menu. The menu is initially empty." do
          @new_menu = create_menu()
          menu?(@new_menu).should == true
        end
      end # describe create_menu

      context 'functions related to menu item manipulation' do
        before(:each)do
          @new_menu = create_menu()
          @sub_menu = create_menu()
          @text = FFI::MemoryPointer.from_string("Appended Item Text")
        end
        after(:each){ destroy_menu(@new_menu) }

        describe "#append_menu" do
          spec{ use{ success = AppendMenu(menu_handle=0, flags=0, id_new_item=0, lp_new_item=nil) }}
          spec{ use{ success = append_menu(menu_handle=0, flags=0, id_new_item=0, lp_new_item=nil) }}

          it "appends a new item to the end of the specified menu bar, drop-down or context menu, returns 1/true " do
            AppendMenu(@new_menu, flags=MF_STRING, 333, @text).should == 1
            append_menu(@new_menu, flags=MF_STRING, 333, @text).should == true
            menu_item_count(@new_menu).should == 2
            menu_item_id(@new_menu, pos=0).should == 333
          end

          it "appends a submenu to the end of the specified menu bar, drop-down or context menu, returns 1/true " do
            AppendMenu(@new_menu, MF_STRING | MF_POPUP, @sub_menu, @text).should == 1
            append_menu(@new_menu, MF_STRING | MF_POPUP, @sub_menu, @text).should == true
            menu_item_count(@new_menu).should == 2
            get_sub_menu(@new_menu, pos=0).should == @sub_menu
            get_sub_menu(@new_menu, pos=1).should == @sub_menu
          end

          it "returns 0/false if unable to appends a new item to the end of the specified menu" do
            AppendMenu(0, flags=MF_STRING, 333, @text).should == 0
            append_menu(0, flags=MF_STRING, 333, @text).should == false
          end
        end # describe append_menu

        describe "#insert_menu" do
          before(:each)do
            append_menu(@new_menu, MF_STRING, ID_FILE_SAVE_AS, FFI::MemoryPointer.from_string("Appended Item Text"))
          end

          spec{ use{ success = InsertMenu(menu_handle=0, position=0, flags=0, id_new_item=0, lp_new_item=nil) }}
          spec{ use{ success = insert_menu(menu_handle=0, position=0, flags=0, id_new_item=0, lp_new_item=nil) }}

          it "inserts a new menu item into a menu, moving other items down the menu, returns 0/true" do
            InsertMenu(@new_menu, 0, MF_STRING | MF_BYPOSITION, 1, @text).should == 1
            insert_menu(@new_menu, 0, MF_STRING | MF_BYPOSITION, 0, @text).should == true
            menu_item_count(@new_menu).should == 3
            menu_item_id(@new_menu, pos=0).should == 0
            menu_item_id(@new_menu, pos=1).should == 1
          end

          it "returns 0/false if unable to appends a new item to the end of the specified menu" do
            InsertMenu(0, 0, flags=MF_STRING, 333, @text).should == 0
            insert_menu(0, 0, flags=MF_STRING, 333, @text).should == false
          end
        end # describe insert_menu

        describe "#delete_menu" do
          before(:each)do
            append_menu(@new_menu, MF_STRING, 0, FFI::MemoryPointer.from_string("Item 0"))
            append_menu(@new_menu, MF_STRING, 1, FFI::MemoryPointer.from_string("Item 1"))
            append_menu(@new_menu, MF_POPUP | MF_STRING, @sub_menu, FFI::MemoryPointer.from_string("Sub 1"))
          end

          spec{ use{ success = DeleteMenu(menu_handle=0, position=0, flags=0) }}
          spec{ use{ success = delete_menu(menu_handle=0, position=0, flags=0) }}

          it "deletes an item from the specified menu, returns 1/true" do
            DeleteMenu(@new_menu, position=0, flags=MF_BYPOSITION).should == 1
            menu_item_count(@new_menu).should == 2
            delete_menu(@new_menu, position=0, flags=MF_BYPOSITION).should == true
            menu_item_count(@new_menu).should == 1
          end

          it "returns 0/false if unable to delete an item from the specified menu" do
            DeleteMenu(@new_menu, position=5, flags=MF_BYPOSITION).should == 0
            menu_item_count(@new_menu).should == 3
            delete_menu(0, position=0, flags=MF_BYPOSITION).should == false
          end

          it "destroys the handle to submenu and frees the memory if given menu item opens a submenu" do
            delete_menu(@new_menu, position=2, flags=MF_BYPOSITION).should == true
            menu_item_count(@new_menu).should == 2
            menu?(@sub_menu).should == false
          end
        end # describe delete_menu
      end # functions related to menu item manipulation
    end # context 'non-destructive methods'

    context 'destructive methods' do
      before(:each)do
        @app = launch_test_app
        @menu = get_menu(@app.handle)
        @file_menu = get_sub_menu(@menu, 0)
      end
      after(:each){ close_test_app if @launched_test_app }

      describe "#destroy_menu" do
        spec{ use{ success = DestroyMenu(menu_handle=0) }}
        spec{ use{ success = destroy_menu(menu_handle=0) }}

        it "original api destroys the specified menu and frees any memory that the menu occupies, returns 1" do
          DestroyMenu(@menu).should == 1
          menu?(@menu).should == false
        end

        it "snake_case api destroys the specified menu and frees any memory that the menu occupies, returns true" do
          destroy_menu(@menu).should == true
          menu?(@menu).should == false
        end

        it "returns 0/false if function was not successful " do
          destroy_menu(h_menu=0).should == false
          DestroyMenu(0).should == 0
        end
      end # describe destroy_menu

    end # context 'destructive methods' do

  end # describe Win::Gui::Menu, ' defines a set of API functions related to menus'

#  describe Win::Gui::Menu, ' defines convenience/service methods on top of Windows API' do
#  end # Win::Gui::Menu, ' defines convenience/service methods on top of Windows API'
end