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

      # From atlres.h:

      # operation messages sent to DLGINIT
#      LB_ADDSTRING    (WM_USER+1)
#      CB_ADDSTRING    (WM_USER+3)

      # Standard window components

      ID_SEPARATOR                 = 0       # special separator value
      ID_DEFAULT_PANE              = 0       # default status bar pane

      # standard control bars (IDW = window ID)
      ATL_IDW_TOOLBAR               = 0xE800  # main Toolbar for window
      ATL_IDW_STATUS_BAR            = 0xE801  # Status bar window
      ATL_IDW_COMMAND_BAR           = 0xE802  # Command bar window

      # parts of a frame window
      ATL_IDW_CLIENT                = 0xE900
      ATL_IDW_PANE_FIRST            = 0xE900  # first pane (256 max)
      ATL_IDW_PANE_LAST             = 0xE9FF
      ATL_IDW_HSCROLL_FIRST         = 0xEA00  # first Horz scrollbar (16 max)
      ATL_IDW_VSCROLL_FIRST         = 0xEA10  # first Vert scrollbar (16 max)
      ATL_IDW_SIZE_BOX              = 0xEA20  # size box for splitters
      ATL_IDW_PANE_SAVE             = 0xEA21  # to shift ATL_IDW_PANE_FIRST

      # bands for a rebar
      ATL_IDW_BAND_FIRST            = 0xEB00
      ATL_IDW_BAND_LAST             = 0xEBFF

        # Standard Commands

        # File commands
      ID_FILE_NEW                   = 0xE100
      ID_FILE_OPEN                  = 0xE101
      ID_FILE_CLOSE                 = 0xE102
      ID_FILE_SAVE                  = 0xE103
      ID_FILE_SAVE_AS               = 0xE104
      ID_FILE_PAGE_SETUP            = 0xE105
      ID_FILE_PRINT_SETUP           = 0xE106
      ID_FILE_PRINT                 = 0xE107
      ID_FILE_PRINT_DIRECT          = 0xE108
      ID_FILE_PRINT_PREVIEW         = 0xE109
      ID_FILE_UPDATE                = 0xE10A
      ID_FILE_SAVE_COPY_AS          = 0xE10B
      ID_FILE_SEND_MAIL             = 0xE10C
      ID_FILE_MRU_FIRST             = 0xE110
      ID_FILE_MRU_FILE1             = 0xE110          # range - 16 max
      ID_FILE_MRU_FILE2             = 0xE111
      ID_FILE_MRU_FILE3             = 0xE112
      ID_FILE_MRU_FILE4             = 0xE113
      ID_FILE_MRU_FILE5             = 0xE114
      ID_FILE_MRU_FILE6             = 0xE115
      ID_FILE_MRU_FILE7             = 0xE116
      ID_FILE_MRU_FILE8             = 0xE117
      ID_FILE_MRU_FILE9             = 0xE118
      ID_FILE_MRU_FILE10            = 0xE119
      ID_FILE_MRU_FILE11            = 0xE11A
      ID_FILE_MRU_FILE12            = 0xE11B
      ID_FILE_MRU_FILE13            = 0xE11C
      ID_FILE_MRU_FILE14            = 0xE11D
      ID_FILE_MRU_FILE15            = 0xE11E
      ID_FILE_MRU_FILE16            = 0xE11F
      ID_FILE_MRU_LAST              = 0xE11F

      # Edit commands
      ID_EDIT_CLEAR                 = 0xE120
      ID_EDIT_CLEAR_ALL             = 0xE121
      ID_EDIT_COPY                  = 0xE122
      ID_EDIT_CUT                   = 0xE123
      ID_EDIT_FIND                  = 0xE124
      ID_EDIT_PASTE                 = 0xE125
      ID_EDIT_PASTE_LINK            = 0xE126
      ID_EDIT_PASTE_SPECIAL         = 0xE127
      ID_EDIT_REPEAT                = 0xE128
      ID_EDIT_REPLACE               = 0xE129
      ID_EDIT_SELECT_ALL            = 0xE12A
      ID_EDIT_UNDO                  = 0xE12B
      ID_EDIT_REDO                  = 0xE12C

      # Window commands
      ID_WINDOW_NEW                 = 0xE130
      ID_WINDOW_ARRANGE             = 0xE131
      ID_WINDOW_CASCADE             = 0xE132
      ID_WINDOW_TILE_HORZ           = 0xE133
      ID_WINDOW_TILE_VERT           = 0xE134
      ID_WINDOW_SPLIT               = 0xE135
      ATL_IDM_WINDOW_FIRST          = 0xE130
      ATL_IDM_WINDOW_LAST           = 0xE13F
      ATL_IDM_FIRST_MDICHILD        = 0xFF00  # window list starts here

      # Help and App commands
      ID_APP_ABOUT                  = 0xE140
      ID_APP_EXIT                   = 0xE141
      ID_HELP_INDEX                 = 0xE142
      ID_HELP_FINDER                = 0xE143
      ID_HELP_USING                 = 0xE144
      ID_CONTEXT_HELP               = 0xE145      # shift-F1
      ID_HELP                       = 0xE146      # first attempt for F1
      ID_DEFAULT_HELP               = 0xE147      # last attempt

      # Misc
      ID_NEXT_PANE                  = 0xE150
      ID_PREV_PANE                  = 0xE151
      ID_PANE_CLOSE                 = 0xE152

      # Format
      ID_FORMAT_FONT                = 0xE160

      # Scroll
      ID_SCROLL_UP                  = 0xE170
      ID_SCROLL_DOWN                = 0xE171
      ID_SCROLL_PAGE_UP             = 0xE172
      ID_SCROLL_PAGE_DOWN           = 0xE173
      ID_SCROLL_TOP                 = 0xE174
      ID_SCROLL_BOTTOM              = 0xE175
      ID_SCROLL_LEFT                = 0xE176
      ID_SCROLL_RIGHT               = 0xE177
      ID_SCROLL_PAGE_LEFT           = 0xE178
      ID_SCROLL_PAGE_RIGHT          = 0xE179
      ID_SCROLL_ALL_LEFT            = 0xE17A
      ID_SCROLL_ALL_RIGHT           = 0xE17B

      # OLE commands
      ID_OLE_INSERT_NEW             = 0xE200
      ID_OLE_EDIT_LINKS             = 0xE201
      ID_OLE_EDIT_CONVERT           = 0xE202
      ID_OLE_EDIT_CHANGE_ICON       = 0xE203
      ID_OLE_EDIT_PROPERTIES        = 0xE204
      ID_OLE_VERB_FIRST             = 0xE210     # range - 16 max
      ID_OLE_VERB_LAST              = 0xE21F

      # View commands (same number used as IDW used for toolbar and status bar)
      ID_VIEW_TOOLBAR               = 0xE800
      ID_VIEW_STATUS_BAR            = 0xE801
      ID_VIEW_REFRESH               = 0xE803

      # Standard control IDs

      IDC_STATIC              = -1     # all static controls

      # Standard string error/warnings

      # idle status bar message
      ATL_IDS_IDLEMESSAGE           = 0xE001
      ATL_IDS_SCFIRST               = 0xEF00
      ATL_IDS_SCSIZE                = 0xEF00
      ATL_IDS_SCMOVE                = 0xEF01
      ATL_IDS_SCMINIMIZE            = 0xEF02
      ATL_IDS_SCMAXIMIZE            = 0xEF03
      ATL_IDS_SCNEXTWINDOW          = 0xEF04
      ATL_IDS_SCPREVWINDOW          = 0xEF05
      ATL_IDS_SCCLOSE               = 0xEF06
      ATL_IDS_SCRESTORE             = 0xEF12
      ATL_IDS_SCTASKLIST            = 0xEF13
      ATL_IDS_MDICHILD              = 0xEF1F
      ATL_IDS_MRU_FILE              = 0xEFDA

      # Misc. control IDs

      # Property Sheet control id's (determined with Spy++)
      ID_APPLY_NOW                  = 0x3021
      ID_WIZBACK                    = 0x3023
      ID_WIZNEXT                    = 0x3024
      ID_WIZFINISH                  = 0x3025
      ATL_IDC_TAB_CONTROL           = 0x3020

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

      ##
      # The SetMenu function assigns a new menu to the specified window.
      #
      # [*Syntax*] BOOL SetMenu( HWND hWnd, HMENU hMenu );
      #
      # hWnd:: <in> Handle to the window to which the menu is to be assigned.
      # hMenu:: <in> Handle to the new menu. If this parameter is NULL, the window's current menu is removed.
      #
      # *Returns*:: If the function succeeds, the return value is nonzero.
      # If the function fails, the return value is zero. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # The window is redrawn to reflect the menu change. A menu can be assigned to any window that is not a
      # child window.
      # The SetMenu function replaces the previous menu, if any, but it does not destroy it. An application
      # should call the DestroyMenu function to accomplish this task.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # Unicode Implemented as Unicode version.
      # ---
      # See Also: DestroyMenu, GetMenu
      #
      # ---
      # <b>Enhanced (snake_case) API: menu_handle argument optional</b>
      #
      # :call-seq:
      #  success = set_menu(window_handle, menu_handle)
      #
      function :SetMenu, [:HWND, :HMENU], :int8, boolean: true,
               &->(api, window_handle, menu_handle=nil){
               api.call window_handle, menu_handle ? menu_handle : 0}

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
      function :SetMenuDefaultItem, 'LLL', :int8, boolean: true
      function :SetMenuInfo, 'LP', :int8, boolean: true
      function :SetMenuItemBitmaps, 'LIILL', :int8, boolean: true
      function :SetMenuItemInfo, 'LIIP', :int8, boolean: true
      function :TrackPopupMenu, 'LIIIILP', :int8, boolean: true
      function :TrackPopupMenuEx, 'LIIILP', :int8, boolean: true

    end
  end
end
