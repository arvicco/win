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

      # Menu Flags

      MF_INSERT          = 0x00000000
      MF_CHANGE          = 0x00000080
      MF_APPEND          = 0x00000100
      MF_DELETE          = 0x00000200
      MF_REMOVE          = 0x00001000
      MF_BYCOMMAND       = 0x00000000
      MF_BYPOSITION      = 0x00000400
      MF_SEPARATOR       = 0x00000800
      MF_ENABLED         = 0x00000000
      MF_GRAYED          = 0x00000001
      MF_DISABLED        = 0x00000002
      MF_UNCHECKED       = 0x00000000
      MF_CHECKED         = 0x00000008
      MF_USECHECKBITMAPS = 0x00000200
      MF_STRING          = 0x00000000
      MF_BITMAP          = 0x00000004
      MF_OWNERDRAW       = 0x00000100
      MF_POPUP           = 0x00000010
      MF_MENUBARBREAK    = 0x00000020
      MF_MENUBREAK       = 0x00000040
      MF_UNHILITE        = 0x00000000
      MF_HILITE          = 0x00000080
      MF_DEFAULT         = 0x00001000
      MF_SYSMENU         = 0x00002000
      MF_HELP            = 0x00004000
      MF_RIGHTJUSTIFY    = 0x00004000
      MF_MOUSESELECT     = 0x00008000
      MF_END             = 0x00000080

      # System Objects

      OBJID_WINDOW            = 0x00000000
      OBJID_SYSMENU           = 0xFFFFFFFF
      OBJID_TITLEBAR          = 0xFFFFFFFE
      OBJID_MENU              = 0xFFFFFFFD
      OBJID_CLIENT            = 0xFFFFFFFC
      OBJID_VSCROLL           = 0xFFFFFFFB
      OBJID_HSCROLL           = 0xFFFFFFFA
      OBJID_SIZEGRIP          = 0xFFFFFFF9
      OBJID_CARET             = 0xFFFFFFF8
      OBJID_CURSOR            = 0xFFFFFFF7
      OBJID_ALERT             = 0xFFFFFFF6
      OBJID_SOUND             = 0xFFFFFFF5
      OBJID_QUERYCLASSNAMEIDX = 0xFFFFFFF4
      OBJID_NATIVEOM          = 0xFFFFFFF0

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
      function :GetMenu, [:HWND], :HMENU, fails: 0

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
      function :GetSystemMenu, [:HWND, :int8], :HMENU, fails: 0,
               &->(api, window_handle, reset=false) {
               api.call window_handle, (reset == 0 || reset == false) ? 0 : 1 }
      # weird lambda literal instead of normal block is needed because current version of RDoc
      # goes crazy if block is attached to meta-definition

      ##
      # The GetMenuItemCount function determines the number of items in the specified menu.
      #
      # [*Syntax*] int GetMenuItemCount( HMENU hMenu );
      #
      # hMenu:: <in> Handle to the menu to be examined.
      #
      # *Returns*:: If the function succeeds, the return value specifies the number of items in the menu.
      # If the function fails, the return value is -1. To get extended error information, call GetLastError.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # ---
      # *See* *Also*:
      # GetMenuItemID
      #
      # ---
      # <b>Enhanced (snake_case) API: returns nil instead of -1 if function fails </b>
      #
      # :call-seq:
      # num_items = [get_]menu_item_count(menu_handle)
      #
      function :GetMenuItemCount, [:HMENU], :int32, fails: -1

      ##
      # The GetMenuItemID function retrieves the menu item identifier of a menu item located at the specified
      # position in a menu.
      #
      # [*Syntax*] UINT GetMenuItemID( HMENU hMenu, int nPos );
      #
      # hMenu:: <in> Handle to the menu that contains the item whose identifier is to be retrieved.
      # nPos:: <in> Specifies the zero-based relative position of the menu item whose identifier is to be
      #        retrieved.
      #
      # *Returns*:: The return value is the identifier of the specified menu item. If the menu item identifier
      #             is NULL or if the specified item opens a submenu, the return value is -1.
      # --
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # ---
      # See Also:
      # GetMenuItemCount
      #
      # ---
      # <b>Enhanced (snake_case) API: returns nil instead of -1 if function fails </b>
      #
      # :call-seq:
      #  item_id = [get_]menu_item_id(@menu_handle, pos)
      #
      function :GetMenuItemID, [:HMENU, :int], :int32, fails: -1

      ##
      # The GetSubMenu function retrieves a handle to the drop-down menu or submenu activated by the specified
      # menu item.
      #
      # [*Syntax*] HMENU GetSubMenu( HMENU hMenu, int nPos );
      #
      # hMenu:: <in> Handle to the menu.
      # nPos:: <in> Specifies the zero-based relative position in the specified menu of an item that activates
      #        a drop-down menu or submenu.
      #
      # *Returns*:: If the function succeeds, the return value is a handle to the drop-down menu or submenu
      #             activated by the menu item. If the menu item does not activate a drop-down menu or
      #             submenu, the return value is NULL.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # ---
      # See Also: CreatePopupMenu, GetMenu
      #
      # ---
      # <b>Enhanced (snake_case) API: </b>
      #
      # :call-seq:
      #  sub_menu = [get_]sub_menu(menu_handle, pos)
      #
      function :GetSubMenu, [:HMENU, :int], :HMENU, fails: 0

      ##
      # The IsMenu function determines whether a handle is a menu handle.
      #
      # [*Syntax*] BOOL IsMenu( HMENU hMenu );
      #
      # hMenu:: <in> Handle to be tested.
      #
      # *Returns*:: If hMenu is a menu handle, the return value is nonzero.
      # If hMenu is not a menu handle, the return value is zero.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # Unicode Implemented as Unicode version.
      #
      # ---
      # <b>Enhanced (snake_case) API: returns true/false istead of 1/0</b>
      #
      # :call-seq:
      #  success = menu?(menu_handle)
      #
      function :IsMenu, [:HMENU], :int8, boolean: true

      # Untested:

      function :AppendMenu, 'LIPP', :int8, boolean: true
      function :CheckMenuItem, 'LII', 'L'
      function :CheckMenuRadioItem, 'LIIII', :int8, boolean: true
      function :CreateMenu, [], 'L'
      function :CreatePopupMenu, [], 'L'
      function :DeleteMenu, 'LII', :int8, boolean: true
      function :DestroyMenu, 'L', :int8, boolean: true
      function :DrawMenuBar, 'L', :int8, boolean: true
      function :EnableMenuItem, 'LII', :int8, boolean: true
      function :EndMenu, [], :int8, boolean: true
      function :GetMenuBarInfo, 'LLLP', :int8, boolean: true
      function :GetMenuCheckMarkDimensions, [], 'L'
      function :GetMenuDefaultItem, 'LII', 'I'
      function :GetMenuInfo, 'LP', :int8, boolean: true
      function :GetMenuItemInfo, 'LIIP', :int8, boolean: true
      function :GetMenuItemRect, 'LLIP', :int8, boolean: true
      function :GetMenuState, 'LLI', 'I'
      function :GetMenuString, 'LIPII', 'I'
      function :GetSubMenu, 'LI', 'L'
      function :HiliteMenuItem, 'LLII', :int8, boolean: true
      function :InsertMenu, 'LIIPP', :int8, boolean: true
      function :InsertMenuItem, 'LIIP', :int8, boolean: true
      function :LoadMenu, 'LP', 'L'
      function :LoadMenuIndirect, 'P', 'L'
      function :MenuItemFromPoint, 'LLP', 'I'
      function :ModifyMenu, 'LIIPP', :int8, boolean: true
      function :RemoveMenu, 'LII', :int8, boolean: true
      function :SetMenu, 'LL', :int8, boolean: true
      function :SetMenuDefaultItem, 'LLL', :int8, boolean: true
      function :SetMenuInfo, 'LP', :int8, boolean: true
      function :SetMenuItemBitmaps, 'LIILL', :int8, boolean: true
      function :SetMenuItemInfo, 'LIIP', :int8, boolean: true
      function :TrackPopupMenu, 'LIIIILP', :int8, boolean: true
      function :TrackPopupMenuEx, 'LIIILP', :int8, boolean: true

    end
  end
end
