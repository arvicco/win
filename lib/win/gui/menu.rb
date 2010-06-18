require 'win/library'
#require 'win/gui/window'
#require 'win/gui/message' # needed because SC_... constants defined there

module Win
  module Gui

    # Contains constants and Win32 API functions related to Window menus manipulation.
    # Menu basics can be found here:
    # http://msdn.microsoft.com/en-us/library/ms646977%28v=VS.85%29.aspx
    module Menu
      extend Win::Library
#      include Win::Gui::Window

      ##
      # The GetMenu function retrieves a handle to the menu assigned to the specified window.
      #
      # [*Syntax*] HMENU GetMenu( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window whose menu handle is to be retrieved.
      #
      # *Returns*:: The return value is a handle to the menu. If the specified window has no menu, the return
      #             value is NULL. If the window is a child window, the return value is undefined.
      # ---
      # *Remarks*:
      # GetMenu does not work on floating menu bars. Floating menu bars are custom controls that mimic
      # standard menus; they are not menus. To get the handle on a floating menu bar, use the Active
      # Accessibility APIs.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # ---
      # *See* *Also*
      # GetSubMenu, SetMenu
      # Menus: http://msdn.microsoft.com/en-us/library/ms646977%28v=VS.85%29.aspx
      # ---
      # <b>Enhanced (snake_case) API: returns nil if no menu handle associated with this window. </b>
      #
      # :call-seq:
      #  menu_handle = [get_]menu(window_handle)
      #
      function :GetMenu, [:HWND], :HMENU, zeronil: true

      ##
      # The GetSystemMenu function allows the application to access the window menu (also known as the system
      # menu or the control menu) for copying and modifying.
      #
      # [*Syntax*] HMENU GetSystemMenu( HWND hWnd, BOOL bRevert );
      #
      # hWnd:: <in> Handle to the window that will own a copy of the window menu.
      # bRevert:: <in> Specifies the action to be taken. If this parameter is FALSE, GetSystemMenu returns a
      #           handle to the copy of the window menu currently in use. The copy is initially identical to
      #           the window menu, but it can be modified. If this parameter is TRUE, GetSystemMenu resets the
      #           window menu back to the default state. The previous window menu, if any, is destroyed.
      #
      # *Returns*:: If the bRevert parameter is FALSE, the return value is a handle to a copy of the window
      #             menu. If the bRevert parameter is TRUE, the return value is NULL.
      # ---
      # *Remarks*:
      # Any window that does not use the GetSystemMenu function to make its own copy of the window menu
      # receives the standard window menu.
      # The window menu initially contains items with various identifier values, such as SC_CLOSE, SC_MOVE, SC_SIZE.
      # Menu items on the window menu send WM_SYSCOMMAND messages.
      # All predefined window menu items have identifier numbers greater than 0xF000. If an application adds
      # commands to the window menu, it should use identifier numbers less than 0xF000.
      # The system automatically grays items on the standard window menu, depending on the situation. The
      # application can perform its own checking or graying by responding to the WM_INITMENU message that is
      # sent before any menu is displayed.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # ---
      # *See* *Also*:
      # GetMenu, InsertMenuItem, SetMenuItemInfo, WM_INITMENU, WM_SYSCOMMAND
      # Menus: http://msdn.microsoft.com/en-us/library/ms646977%28v=VS.85%29.aspx
      #
      # ---
      # <b>Enhanced (snake_case) API: reset is optional, defaults to false(do not reset)</b>
      #
      # :call-seq:
      #  menu_handle = [get_]system_menu(window_handle, reset)
      #
      function :GetSystemMenu, [:HWND, :int8], :HMENU, zeronil: true,
               &->(api, window_handle, reset=false) {
               api.call window_handle, (reset == 0 || reset == false) ? 0 : 1 }
      # weird lambda literal instead of normal block is needed because current version of RDoc
      # goes crazy if block is attached to meta-definition

    end
  end
end
