require 'win/library'
require 'win/gui/window'

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
      #  menu_handle = get_menu(h_wnd)
      #
      function :GetMenu, [:HWND], :HMENU, zeronil: true

    end
  end
end
