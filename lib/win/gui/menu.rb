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
      # <b>Enhanced (snake_case) API: returns true/false instead of 1/0</b>
      #
      # :call-seq:
      #  success = menu?(menu_handle)
      #
      function :IsMenu, [:HMENU], :int8, boolean: true

      ##
      # The CreateMenu function creates a menu. The menu is initially empty, but it can be filled with menu
      # items by using the InsertMenuItem, AppendMenu, and InsertMenu functions.
      #
      # [*Syntax*] HMENU CreateMenu( void );
      #
      # *Returns*:: If the function succeeds, the return value is a handle to the newly created menu.
      # If the function fails, the return value is NULL. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # Resources associated with a menu that is assigned to a window are freed automatically. If the menu is
      # not assigned to a window, an application must free system resources associated with the menu before
      # closing. An application frees menu resources by calling the DestroyMenu function.
      # Windows 95/98/Me:The system can support a maximum of 16,364 menu handles.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # Unicode Implemented as Unicode version.
      # ---
      # See Also: AppendMenu, CreatePopupMenu, DestroyMenu, InsertMenu, SetMenu, InsertMenuItem
      #
      # :call-seq:
      #  menu_handle = create_menu()
      #
      function :CreateMenu, [], :HMENU

      ##
      # The DestroyMenu function destroys the specified menu and frees any memory that the menu occupies.
      #
      # [*Syntax*] BOOL DestroyMenu( HMENU hMenu );
      #
      # hMenu:: <in> Handle to the menu to be destroyed.
      #
      # *Returns*:: If the function succeeds, the return value is nonzero.
      # If the function fails, the return value is zero. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # Before closing, an application must use the DestroyMenu function to destroy a menu not assigned to a
      # window. A menu that is assigned to a window is automatically destroyed when the application closes.
      # DestroyMenu is recursive, that is, it will destroy the menu and all its submenus.
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # Unicode Implemented as Unicode version.
      # ---
      # See Also: CreateMenu, DeleteMenu, RemoveMenu, SetMenuItemInfo
      #
      # ---
      # <b>Enhanced (snake_case) API: returns true/false instead of 1/0</b>
      #
      # :call-seq:
      #  success = destroy_menu(menu_handle)
      #
      function :DestroyMenu, [:HMENU], :int8, boolean: true

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

      ##
      # The AppendMenu function appends a new ITEM to the end of the specified menu bar, drop-down menu, submenu, or
      # shortcut menu. You can use this function to specify the content, appearance, and behavior of the menu item.
      #
      # [*Syntax*] BOOL AppendMenu( HMENU hMenu, UINT uFlags, UINT_PTR uIDNewItem, LPCTSTR lpNewItem );
      #
      # hMenu:: <in> Handle to the menu bar, drop-down menu, submenu, or shortcut menu to be changed.
      # uFlags:: <in> Specifies flags to control the appearance and behavior of the new menu item. This
      #          parameter can be a combination of the values listed in the following Remarks section.
      # uIDNewItem:: <in> Specifies either the identifier of the new menu item or, if the uFlags parameter is
      #              set to MF_POPUP, a handle to the drop-down menu or submenu.
      # lpNewItem:: <in> Specifies the content of the new menu item. The interpretation of lpNewItem depends
      #             on whether the uFlags parameter includes the MF_BITMAP, MF_OWNERDRAW, or MF_STRING flag,
      #             as shown in the following table.
      #             MF_BITMAP:: Contains a bitmap handle.
      #             MF_OWNERDRAW:: Contains an application-supplied value that can be used to maintain additional
      #                            data related to the menu item. The value is in the itemData member of the structure
      #                            pointed to by the lParam parameter of the WM_MEASUREITEM or WM_DRAWITEM message
      #                            sent when the menu is created or its appearance is updated.
      #             MF_STRING:: Contains a pointer to a null-terminated string. 
      #
      # *Returns*:: If the function succeeds, the return value is nonzero. If the function fails, the return
      #             value is zero. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # The application must call the DrawMenuBar function whenever a menu changes, whether or not the menu is
      # in a displayed window.
      # To get keyboard accelerators to work with bitmap or owner-drawn menu items, the owner of the menu must
      # process the WM_MENUCHAR message. For more information, see Owner-Drawn Menus and the WM_MENUCHAR Message.
      # The following flags can be set in the uFlags parameter:
      # MF_BITMAP:: Uses a bitmap as the menu item. The lpNewItem parameter contains a handle to the bitmap.
      # MF_CHECKED:: Places a check mark next to the menu item. If the application provides check-mark bitmaps
      #              (see SetMenuItemBitmaps, this flag displays the check-mark bitmap next to the menu item.)
      # MF_DISABLED:: Disables the menu item so that it cannot be selected, but the flag does not gray it.
      # MF_ENABLED:: Enables the menu item so that it can be selected, and restores it from its grayed state.
      # MF_GRAYED:: Disables the menu item and grays it so that it cannot be selected.
      # MF_MENUBARBREAK:: Functions the same as the MF_MENUBREAK flag for a menu bar. For a drop-down menu, submenu,
      #                   or shortcut menu, the new column is separated from the old column by a vertical line.
      # MF_MENUBREAK:: Places the item on a new line (for a menu bar) or in a new column (for a drop-down menu,
      #                submenu, or shortcut menu) without separating columns.
      # MF_OWNERDRAW:: Specifies that the item is an owner-drawn item. Before the menu is displayed for the
      #                first time, the window that owns the menu receives a WM_MEASUREITEM message to retrieve
      #                the width and height of the menu item. The WM_DRAWITEM message is then sent to the window
      #                procedure of the owner window whenever the appearance of the menu item must be updated.
      # MF_POPUP:: Specifies that the menu item opens a drop-down menu or submenu. The uIDNewItem parameter
      #            specifies a handle to the drop-down menu or submenu. This flag is used to add a menu name to a menu
      #            bar, or a menu item that opens a submenu to a drop-down menu, submenu, or shortcut menu.
      # MF_SEPARATOR:: Draws a horizontal dividing line. This flag is used only in a drop-down menu, submenu, or
      #                shortcut menu. The line cannot be grayed, disabled, or highlighted. The lpNewItem and uIDNewItem
      #                parameters are ignored.
      # MF_STRING:: Specifies that the menu item is a text string; the lpNewItem parameter is a pointer to the string.
      # MF_UNCHECKED:: Does not place a check mark next to the item (default). If the application supplies check-mark
      #                bitmaps (see SetMenuItemBitmaps), this flag displays the clear bitmap next to the menu item.
      # The following groups of flags cannot be used together:
      # MF_BITMAP, MF_STRING, and MF_OWNERDRAW
      # MF_CHECKED and MF_UNCHECKED
      # MF_DISABLED, MF_ENABLED, and MF_GRAYED
      # MF_MENUBARBREAK and MF_MENUBREAK
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # Unicode Implemented as ANSI and Unicode versions.
      # ---
      # See Also:
      # CreateMenu, DeleteMenu, DestroyMenu, DrawMenuBar, InsertMenu, InsertMenuItem, ModifyMenu,
      # RemoveMenu, SetMenuItemBitmaps
      #
      # ---
      # <b>Enhanced (snake_case) API: </b>
      #
      # :call-seq:
      #  success = append_menu(menu_handle, flags, id_new_item, lp_new_item)
      #
      function :AppendMenu, [:HMENU, :UINT, :UINT, :pointer], :int8, boolean: true

      ##
      # The InsertMenu function inserts a new menu item into a menu, moving other items down the menu.
      # Note  The InsertMenu function has been superseded by the InsertMenuItem function. You can still use
      # InsertMenu, however, if you do not need any of the extended features of InsertMenuItem.
      #
      # [*Syntax*] BOOL InsertMenu( HMENU hMenu, UINT uPosition, UINT uFlags, PTR uIDNewItem, LPCTSTR
      #            lpNewItem );
      #
      # hMenu:: <in> Handle to the menu to be changed.
      # uPosition:: <in> Specifies the menu item before which the new menu item is to be inserted, as
      #             determined by the uFlags parameter.
      # uFlags:: <in> Specifies flags that control the interpretation of the uPosition parameter and the content,
      #          appearance, and behavior of the new menu item. This parameter must be a combination of one of the
      #          following required values and at least one of the values listed in the following Remarks section.
      #          MF_BYCOMMAND:: Indicates that the uPosition parameter gives the identifier of the menu item.
      #                         MF_BYCOMMAND flag is the default if neither MF_BYCOMMAND nor MF_BYPOSITION specified.
      #          MF_BYPOSITION:: Indicates that the uPosition parameter gives the zero-based relative position of the
      #                          new menu item. If uPosition is -1, new menu item is appended to the end of the menu.
      # uIDNewItem:: <in> Specifies either the identifier of the new menu item or, if the uFlags parameter has
      #              the MF_POPUP flag set, a handle to the drop-down menu or submenu.
      # lpNewItem:: <in> Specifies the content of the new menu item. The interpretation of lpNewItem depends on whether
      #             the uFlags parameter includes the MF_BITMAP, MF_OWNERDRAW, or MF_STRING flag, as follows:
      #             MF_BITMAP:: Contains a bitmap handle.
      #             MF_OWNERDRAW:: Contains an application-supplied value that can be used to maintain additional data
      #                            related to the menu item. The value is in the itemData member of the structure
      #                            pointed to by the lParam parameter of the WM_MEASUREITEM or WM_DRAWITEM message sent
      #                            when the menu item is created or its appearance is updated.
      #             MF_STRING:: Contains a pointer to a null-terminated string (the default).
      #
      # *Returns*:: If the function succeeds, the return value is nonzero.
      # If the function fails, the return value is zero. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # The application must call the DrawMenuBar function whenever a menu changes, whether or not the menu is
      # in a displayed window.
      # The following list describes the flags that can be set in the uFlags parameter:
      # MF_BITMAP:: Uses a bitmap as the menu item. The lpNewItem parameter contains a handle to the bitmap.
      # MF_CHECKED:: Places a check mark next to the menu item. If the application provides check-mark bitmaps
      #              (see SetMenuItemBitmaps), this flag displays the check-mark bitmap next to the menu item.
      # MF_DISABLED:: Disables the menu item so that it cannot be selected, but does not gray it.
      # MF_ENABLED:: Enables the menu item so that it can be selected and restores it from its grayed state.
      # MF_GRAYED:: Disables the menu item and grays it so it cannot be selected.
      # MF_MENUBARBREAK:: Functions the same as the MF_MENUBREAK flag for a menu bar. For a drop-down menu, submenu, or
      #                   shortcut menu, the new column is separated from the old column by a vertical line.
      # MF_MENUBREAK:: Places the item on a new line (for menu bars) or in a new column (for a drop-down menu,
      #                submenu, or shortcut menu) without separating columns.
      # MF_OWNERDRAW:: Specifies that the item is an owner-drawn item. Before the menu is displayed for the first time,
      #                the window that owns the menu receives a WM_MEASUREITEM message to retrieve the width and
      #                height of the menu item. The WM_DRAWITEM message is then sent to the window procedure of the
      #                owner window whenever the appearance of the menu item must be updated.
      # MF_POPUP:: Specifies that the menu item opens a drop-down menu or submenu. The uIDNewItem parameter
      #            specifies a handle to the drop-down menu or submenu. This flag is used to add a menu name to a menu
      #            bar or a menu item that opens a submenu to a drop-down menu, submenu, or shortcut menu.
      # MF_SEPARATOR:: Draws a horizontal dividing line. This flag is used only in a drop-down menu, submenu, or
      #                shortcut menu. The line cannot be grayed, disabled, or highlighted. The lpNewItem and uIDNewItem
      #                parameters are ignored.
      # MF_STRING:: Specifies that the menu item is a text string; the lpNewItem parameter is a pointer to the string.
      # MF_UNCHECKED:: Does not place a check mark next to the menu item (default). If the application supplies
      #                check-mark bitmaps (see the SetMenuItemBitmaps function), this flag displays the clear bitmap
      #                next to the menu item.
      # The following groups of flags cannot be used together:
      # MF_BYCOMMAND and MF_BYPOSITION
      # MF_DISABLED, MF_ENABLED, and MF_GRAYED
      # MF_BITMAP, MF_STRING, MF_OWNERDRAW, and MF_SEPARATOR
      # MF_MENUBARBREAK and MF_MENUBREAK
      # MF_CHECKED and MF_UNCHECKED
      # ---
      # Minimum DLL Version user32.dll
      # Header Declared in Winuser.h, include Windows.h
      # Import library User32.lib
      # Minimum operating systems Windows 95, Windows NT 3.1
      # Unicode Implemented as ANSI and Unicode versions.
      # ---
      # See Also: AppendMenu, DeleteMenu, DrawMenuBar, InsertMenuItem, ModifyMenu, RemoveMenu,
      # SetMenuItemBitmaps, WM_DRAWITEM, WM_MEASUREITEM
      #
      # ---
      # <b>Enhanced (snake_case) API: </b>
      #
      # :call-seq:
      #  success = insert_menu(menu_handle, position, flags, id_new_item, lp_new_item)
      #
      function :InsertMenu, [:HMENU, :UINT, :UINT, :UINT, :pointer], :int8, boolean: true


      # Untested:

      function :CheckMenuItem, 'LII', 'L'
      function :CheckMenuRadioItem, 'LIIII', :int8, boolean: true
      function :CreatePopupMenu, [], 'L'
      function :DeleteMenu, 'LII', :int8, boolean: true
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
#      function :InsertMenu, 'LIIPP', :int8, boolean: true
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
