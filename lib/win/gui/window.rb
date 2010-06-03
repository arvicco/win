require 'win/library'
require 'win/gui/message' # needed because some convenience methods work via PostMessage

module Win
  module Gui
    # Contains constants and Win32API functions related to window manipulation
    #
    module Window
      extend Win::Library

      # ShowWindow constants:

      # Hides the window and activates another window.
      SW_HIDE           = 0
      # Same as SW_SHOWNORMAL
      SW_NORMAL         = 1
      # Activates and displays a window. If the window is minimized or maximized, the system restores it to its
      # original size and position. An application should specify this flag when displaying the window for the first time.
      SW_SHOWNORMAL     = 1
      # Activates the window and displays it as a minimized window.
      SW_SHOWMINIMIZED  = 2
      # Activates the window and displays it as a maximized window.
      SW_SHOWMAXIMIZED  = 3
      # Activates the window and displays it as a maximized window.
      SW_MAXIMIZE       = 3
      # Displays a window in its most recent size and position. Similar to SW_SHOWNORMAL, but the window is not activated.
      SW_SHOWNOACTIVATE = 4
      # Activates the window and displays it in its current size and position.
      SW_SHOW           = 5
      # Minimizes the specified window, activates the next top-level window in the Z order.
      SW_MINIMIZE       = 6
      # Displays the window as a minimized window. Similar to SW_SHOWMINIMIZED, except the window is not activated.
      SW_SHOWMINNOACTIVE= 7
      # Displays the window in its current size and position. Similar to SW_SHOW, except the window is not activated.
      SW_SHOWNA         = 8
      # Activates and displays the window. If the window is minimized or maximized, the system restores it to its original
      # size and position. An application should specify this flag when restoring a minimized window.
      SW_RESTORE        = 9
      # Sets the show state based on the SW_ value specified in the STARTUPINFO structure  passed to the CreateProcess
      # function by the program that started the application.
      SW_SHOWDEFAULT    = 10
      # Windows 2000/XP: Minimizes a window, even if the thread that owns the window is not responding. Only use this
      # flag when minimizing windows from a different thread.
      SW_FORCEMINIMIZE  = 11

      # GetWindow constants:
      GW_HWNDFIRST = 0
      GW_HWNDLAST = 1
      GW_HWNDNEXT = 2
      GW_HWNDPREV = 3
      GW_OWNER = 4
      GW_CHILD = 5
      GW_ENABLEDPOPUP = 6

      # GetAncestor constants:
      GA_PARENT = 1
      GA_ROOT = 2
      GA_ROOTOWNER = 3

      class << self
        # Def_block that calls API function expecting EnumWindowsProc callback (EnumWindows, EnumChildWindows, ...).
        # Default callback pushes all passed handles into Array that is returned if Enum function call was successful.
        # If runtime block is given it is called after the end of default callback (handle Array is still being
        # collected and returned by the method). If Enum... function call fails, method returns nil, otherwise
        # an Array of all window handles passed into callback.
        #
        def return_enum #:nodoc:
          lambda do |api, *args, &block|
            args.push 0 if args.size == api.prototype.size - 2 # If value is missing, it defaults to 0
            handles = []

            # Insert callback proc into appropriate place of args Array
            args[api.prototype.find_index(:EnumWindowsProc), 0] =
                    proc do |handle, message|
                      handles << handle
                      block ? block[handle, message] : true
                    end
            handles if api.call *args
          end
        end

        # Helper method that creates def_block returning (possibly encoded) string as a result of
        # api function call or nil if zero characters was returned by api call
        #
        def return_string( encode = nil )  #:nodoc:
          lambda do |api, *args|
            namespace.enforce_count( args, api.prototype, -2)
            buffer = FFI::MemoryPointer.new :char, 1024
            args += [buffer, buffer.size]
            num_chars = api.call(*args)
            return nil if num_chars == 0
            if encode
              string = buffer.get_bytes(0, num_chars*2)
              string = string.force_encoding('utf-16LE').encode(encode)
            else
              string = buffer.get_bytes(0, num_chars)
            end
            string.rstrip
          end
        end

        private :return_enum, :return_string
      end

      # Windows GUI API definitions:

      ##
      # The IsWindow function determines whether the specified window handle identifies an existing window.
      # [*Syntax*] BOOL IsWindow( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window to test.
      #
      # *Returns*:: If the window handle identifies an existing window, the return value is (*true*).
      #             If the window handle does not identify an existing window, the return value is (*false*).
      # ---
      # *remarks*:
      # A thread should not use IsWindow for a window that it did not create because the window
      # could be destroyed after this function was called. Further, because window handles are
      # recycled the handle could even point to a different window.
      #
      # :call-seq:
      # window?( win_handle )
      #
      function :IsWindow, [:HWND], :int, boolean: true

      ##
      # The IsWindowVisible function retrieves the visibility state of the specified window.
      # [*Syntax*] BOOL IsWindowVisible( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window to test.
      #
      # *Returns*:: If the specified window, its parent window, its parent's parent window, and so forth,
      #             have the WS_VISIBLE style set, return value is *true*. Because the return value specifies
      #             whether the window has the WS_VISIBLE style, it may be true even if the window is totally
      #             obscured by other windows.
      # ---
      # *Remarks*:
      # - The visibility state of a window is indicated by the WS_VISIBLE style bit. When WS_VISIBLE is set,
      #   the window is displayed and subsequent drawing into it is displayed as long as the window has the
      #   WS_VISIBLE style.
      # - Any drawing to a window with the WS_VISIBLE style will not be displayed if the window is obscured
      #   by other windows or is clipped by its parent window.
      #
      # :call-seq:
      #   [window_]visible?( win_handle )
      #
      function :IsWindowVisible, [:HWND], :int, boolean: true, aliases: :visible?

      ##
      # Tests whether the specified window is maximized.
      # [*Syntax*] BOOL IsZoomed( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window to test.
      #
      # *Returns*:: If the window is zoomed (maximized), the return value is *true*.
      #             If the window is not zoomed (maximized), the return value is *false*.
      #
      # :call-seq:
      #   zoomed?( win_handle ), maximized?( win_handle )
      #
      function :IsZoomed, [:HWND], :int, boolean: true, aliases: :maximized?

      ##
      # Tests whether the specified window is minimized.
      # [*Syntax*] BOOL IsIconic( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window to test.
      #
      # *Returns*:: If the window is iconic (minimized), the return value is *true*.
      #             If the window is not iconic (minimized), the return value is *false*.
      #
      # :call-seq:
      #   iconic?( win_handle ), minimized?( win_handle )
      #
      function :IsIconic, [:HWND], :int, boolean: true, aliases: :minimized?

      ##
      # Tests whether a window is a child (or descendant) window of a specified parent window.
      # A child window is the direct descendant of a specified parent window if that parent window
      # is in the chain of parent windows; the chain of parent windows leads from the original overlapped
      # or pop-up window to the child window.
      #
      # [*Syntax*] BOOL IsChild( HWND hWndParent, HWND hWnd);
      #
      # hWndParent:: <in> Handle to the parent window.
      # hWnd:: <in> Handle to the window to be tested.
      #
      # *Returns*::  If the window is a child or descendant window of the specified parent window,
      #              the return value is *true*. If the window is not a child or descendant window of
      #              the specified parent window, the return value is *false*.
      # :call-seq:
      #   child?( win_handle )
      #
      function :IsChild, [:HWND, :HWND], :int, boolean: true

      ##
      # The FindWindow function retrieves a handle to the top-level window whose class name and window name
      # match the specified strings. This function does not search child windows. This function does not
      # perform a case-sensitive search.
      #
      # To search child windows, beginning with a specified child window, use the FindWindowEx function.
      #
      # [*Syntax*] HWND FindWindow( LPCTSTR lpClassName, LPCTSTR lpWindowName );
      #
      # lpClassName:: <in> Pointer to a null-terminated string that specifies the class name or a class
      #               atom created by a previous call to the RegisterClass or RegisterClassEx function.
      #               The atom must be in the low-order word of lpClassName; the high-order word must be zero.
      #               If lpClassName points to a string, it specifies the window class name. The class name
      #               can be any name registered with RegisterClass or RegisterClassEx, or any of the
      #               predefined control-class names.
      #               If lpClassName is NULL, it finds any window whose title matches the lpWindowName parameter.
      # lpWindowName:: <in> Pointer to a null-terminated string that specifies the window name (the window's title).
      #                If this parameter is NULL, all window names match.
      # *Returns*:: If the function succeeds, the return value is a handle to the window that has the specified
      #             class name and window name. If the function fails, the return value is *nil*.
      #             To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # - If the lpWindowName parameter is not NULL, FindWindow calls the GetWindowText function to retrieve
      #   the window name for comparison. For a description of a potential problem that can arise, see the
      #   Remarks for GetWindowText.
      # - To check if the Microsoft IntelliType version 1.x software is running, call FindWindow as follows:
      #      find_window("MSITPro::EventQueue", nil)
      # - To check if the IntelliType version 2.0 software is running, call FindWindow as follows:
      #      find_window("Type32_Main_Window", nil)
      #   If the IntelliType software is running, it sends WM_APPCOMMAND messages to the application.
      #   Otherwise the application must install a hook to receive WM_APPCOMMAND messages.
      #
      # :call-seq:
      #   win_handle = find_window( class_name, win_name )
      #
      function :FindWindow, [:pointer, :pointer], :HWND, zeronil: true

      ##
      # Unicode version of FindWindow (strings must be encoded as utf-16LE AND terminate with "\x00\x00")
      #
      # :call-seq:
      #   win_handle = find_window_w( class_name, win_name )
      #
      function :FindWindowW, [:pointer, :pointer], :HWND, zeronil: true

      ##
      #  The FindWindowEx function retrieves a handle to a window whose class name and window name match the specified
      #  strings. The function searches only child windows, beginning with the one following the specified child window.
      #  This function does not perform a case-sensitive search.
      #
      #  [*Syntax*] HWND FindWindowEx( HWND hwndParent, HWND hwndChildAfter, LPCTSTR lpszClass, LPCTSTR lpszWindow );
      #
      #  hwndParent:: <in> Handle to the parent window whose child windows are to be searched.
      #               If hwndParent is NULL, the function uses the desktop window as the parent window.
      #               The function searches among windows that are child windows of the desktop.
      #               Microsoft Windows 2000 and Windows XP: If hwndParent is HWND_MESSAGE, the function
      #               searches all message-only windows.
      #  hwndChildAfter:: <in> Handle to a child window. The search begins with the next child window in the Z order.
      #                   The child window must be a direct child window of hwndParent, not just a descendant window.
      #                   If hwndChildAfter is NULL, the search begins with the first child window of hwndParent.
      #                   Note that if both hwndParent and hwndChildAfter are NULL, the function searches all
      #                   top-level and message-only windows.
      #  lpszClass:: <in> Pointer to a null-terminated string that specifies the class name or a class atom created
      #              by a previous call to the RegisterClass or RegisterClassEx function. The atom must be placed in
      #              the low-order word of lpszClass; the high-order word must be zero.
      #              If lpszClass is a string, it specifies the window class name. The class name can be any name
      #              registered with RegisterClass or RegisterClassEx, or any of the predefined control-class names,
      #              or it can be MAKEINTATOM(0x800). In this latter case, 0x8000 is the atom for a menu class. For
      #              more information, see the Remarks section of this topic.
      #  lpszWindow:: <in> Pointer to a null-terminated string that specifies the window name (the window's title).
      #               If this parameter is NULL, all window names match.
      #
      #  *Returns*:: If the function succeeds, the return value is a handle to the window that has the specified
      #              class and window names. If the function fails, the return value is NULL. For extended error info,
      #              call GetLastError.
      #  ---
      #  *Remarks*:
      #  - Only DIRECT children of given parent window being searched, not ALL its the descendants. This behavior is
      #    different from EnumChildWindows which enumerates also non-direct descendants.
      #  - If the lpszWindow parameter is not nil, FindWindowEx calls the GetWindowText function to retrieve the window
      #    name for comparison. For a description of a potential problem that can arise, see the Remarks section of
      #    GetWindowText.
      #  - An application can call this function in the following way.
      #         find_window_ex( nil, nil, MAKEINTATOM(0x8000), nil )
      #    0x8000 is the atom for a menu class. When an application calls this function, the function checks whether
      #    a context menu is being displayed that the application created.
      #
      # :call-seq:
      #   win_handle = find_window_ex( win_handle, after_child, class_name, win_name )
      #
      function :FindWindowEx, [:HWND, :HWND, :pointer, :pointer], :HWND, zeronil: true

      ##
      # GetWindowText returns the text of the specified window's title bar (if it has one).
      # If the specified window is a control, the text of the control is copied. However, GetWindowText
      # cannot retrieve the text of a control in another application.
      #
      # [*Syntax*] int GetWindowText( HWND hWnd, LPTSTR lpString, int nMaxCount );
      #
      # *Original* Parameters:
      # hWnd:: Handle to the window and, indirectly, the class to which the window belongs.
      # lpString:: Long Pointer to the buffer that is to receive the text string.
      # nMaxCount:: Specifies the length, in TCHAR, of the buffer pointed to by the text parameter.
      #             The class name string is truncated if it is longer than the buffer and is always null-terminated.
      # *Original* Return:: Length, in characters, of the copied string, not including the terminating null
      #                     character (if success). Zero indicates that the window has no title bar or text,
      #                     if the title bar is empty, or if the window or control handle is invalid.
      #                     For extended error information, call GetLastError.
      # ---
      # Enhanced API requires only win_handle and returns rstripped text
      #
      # *Enhanced* Parameters:
      # win_handle:: Handle to the window and, indirectly, the class to which the window belongs.
      # *Returns*:: Window title bar text or nil. If the window has no title bar or text, if the title bar
      #             is empty, or if the window or control handle is invalid, the return value is *NIL*.
      #             To get extended error information, call GetLastError.
      # ---
      # *Remarks*: This function CANNOT retrieve the text of an edit control in ANOTHER app.
      # - If the target window is owned by the current process, GetWindowText causes a WM_GETTEXT message to
      #   be sent to the specified window or control. If the target window is owned by another process and has
      #   a caption, GetWindowText retrieves the window caption text. If the window does not have a caption,
      #   the return value is a null string. This allows to call GetWindowText without becoming unresponsive
      #   if the target window owner process is not responding. However, if the unresponsive target window
      #   belongs to the calling app, GetWindowText will cause the calling app to become unresponsive.
      # - To retrieve the text of a control in another process, send a WM_GETTEXT message directly instead
      #   of calling GetWindowText.
      #
      #:call-seq:
      #   text = [get_]window_text( win_handle )
      #
      function :GetWindowText, [:HWND, :pointer, :int], :int, &return_string

      ##
      # GetWindowTextW is a Unicode version of GetWindowText (returns rstripped utf-8 string)
      # API improved to require only win_handle and return rstripped string
      #
      #:call-seq:
      #   text = [get_]window_text_w( win_handle )
      #
      function :GetWindowTextW, [:HWND, :pointer, :int], :int, &return_string('utf-8')

      ##
      # GetClassName retrieves the name of the class to which the specified window belongs.
      # [*Syntax*] int GetClassName( HWND hWnd, LPTSTR lpClassName, int nMaxCount );
      # *Original* Parameters:
      # hWnd:: <in> Handle to the window and, indirectly, the class to which the window belongs.
      # lpClassName:: <out> Pointer to the buffer that is to receive the class name string.
      # nMaxCount:: <in> Specifies the length, in TCHAR, of the buffer pointed to by the lpClassName parameter.
      #             The class name string is truncated if it is longer than the buffer and is always null-terminated.
      # *Original* Return:: Length, in characters, of the copied string, not including the terminating null character,
      #                     indicates success. Zero indicates that the window has no title bar or text, if the title
      #                     bar is empty, or if the window or control handle is invalid.
      # ---
      # API improved to require only win_handle and return rstripped string
      #
      # *Enhanced* Parameters:
      # win_handle:: Handle to the window and, indirectly, the class to which the window belongs.
      # *Returns*:: Name of the class or *nil* if function fails. For extended error information, call GetLastError.
      #
      #:call-seq:
      #   text = [get_]class_name( win_handle )
      #
      function :GetClassName, [:HWND, :pointer, :int], :int, &return_string

      ##
      # GetClassNameW is a Unicode version of GetClassName (returns rstripped utf-8 string)
      # API improved to require only win_handle and return rstripped string
      #
      #:call-seq:
      #   text = [get_]class_name_w( win_handle )
      #
      function :GetClassNameW, [:HWND, :pointer, :int], :int, &return_string('utf-8')

      ##
      # ShowWindow shows and hides windows (sets the specified window's show state).
      #
      # [*Syntax*] BOOL ShowWindow( HWND hWnd, int nCmdShow);
      #
      # hWnd:: Handle to the window.
      # nCmdShow:: Specifies how the window is to be shown. This parameter is ignored the first time an
      #            application calls ShowWindow, if the program that launched the application provides a
      #            STARTUPINFO structure. Otherwise, the first time ShowWindow is called, the value should
      #            be the value obtained  by the WinMain function in its nCmdShow parameter. In subsequent
      #            calls, cmd may be:
      #            SW_HIDE, SW_MAXIMIZE, SW_MINIMIZE, SW_SHOW, SW_SHOWMAXIMIZED, SW_SHOWMINIMIZED, SW_SHOWMINNOACTIVE,
      #            SW_SHOWNA, SW_SHOWNOACTIVATE, SW_SHOWNORMAL, SW_RESTORE, SW_SHOWDEFAULT, SW_FORCEMINIMIZE
      #
      # *Returns*:: *True* if the window was PREVIOUSLY visible, otherwise *false*
      #
      #:call-seq:
      #   was_visible = show_window( win_handle, cmd )
      #
      function :ShowWindow, [:HWND, :int], :int, boolean: true,
               &->(api, handle, cmd=SW_SHOW) { api.call handle, cmd }

      ##
      # The CloseWindow function MINIMIZES (but does not destroy) the specified window.
      #
      # [*Syntax*]: BOOL CloseWindow( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window to be minimized.
      #
      # *Returns*:: If the function succeeds, the return value is nonzero (*true* in snake_case method). If the function
      #             fails, the return value is zero (*false). To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # To destroy a window, an application must use the DestroyWindow function.
      #
      function :CloseWindow, [:HWND], :int, boolean: true

      ##
      # DestroyWindow function destroys the specified window. The function sends WM_DESTROY and WM_NCDESTROY messages
      # to the window to deactivate it and remove the keyboard focus from it. The function also destroys the window's
      # menu, flushes the thread message queue, destroys timers, removes clipboard ownership, and breaks the clipboard
      # viewer chain (if the window is at the top of the viewer chain).
      #
      # If the specified window is a parent or owner window, DestroyWindow automatically destroys the associated child
      # or owned windows when it destroys the parent or owner window. The function first destroys child or owned
      # windows, and then it destroys the parent or owner window.
      #
      # DestroyWindow also destroys modeless dialog boxes created by the CreateDialog function.
      #
      # [*Syntax*]: BOOL DestroyWindow( HWND hWnd );
      #
      # hWnd:: <in> Handle to the window to be destroyed.
      #
      # *Returns*:: If the function succeeds, the return value is nonzero (snake_case method: *true*). If the function
      #             fails, the return value is zero (*false*). To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # A thread <b>cannot use DestroyWindow to destroy a window created by a different thread.</b> Use a convenience
      # method destroy_unowned_window instead (it relies on 
      # If the window being destroyed is a child window that does not have the WS_EX_NOPARENTNOTIFY style, a
      # WM_PARENTNOTIFY message is sent to the parent.
      #
      function :DestroyWindow, [:HWND], :int, boolean: true

      ##
      # GetWindowThreadProcessId retrieves the identifier of the thread that created the specified window
      # and, optionally, the identifier of the process that created the window.
      #
      # [*Syntax*] DWORD GetWindowThreadProcessId( HWND hWnd, LPDWORD lpdwProcessId );
      #
      # *Original* Parameters:
      # hWnd:: <in> Handle to the window.
      # lpdwProcessId:: <out> Pointer to a variable that receives the process identifier. If this parameter
      #                 is not NULL, GetWindowThreadProcessId copies the identifier of the process to the
      #                 variable; otherwise, it does not.
      # *Original* Return:: The identifier of the thread that created the window.
      # ---
      # API improved to accept window handle as a single arg and return a pair of [thread, process] ids
      #
      # *New* Parameters:
      # handle:: Handle to the window.
      # *Returns*: Pair of identifiers of the thread and process_id that created the window.
      #
      #:call-seq:
      #   thread, process_id = [get_]window_thread_process_id( win_handle )
      #
      function :GetWindowThreadProcessId, [:HWND, :pointer], :long,
               &->(api, handle) {
               process = FFI::MemoryPointer.new(:long).write_long(1)
               thread = api.call(handle, process)
               thread == 0 ? [nil, nil] : [thread, process.read_long()] }
      # weird lambda literal instead of normal block is needed because current version of RDoc
      # goes crazy if block is attached to meta-definition

      ##
      # GetWindowRect retrieves the dimensions of the specified window bounding rectangle.
      # Dimensions are given relative to the upper-left corner of the screen.
      #
      # [*Syntax*] BOOL GetWindowRect( HWND hWnd, LPRECT lpRect );
      #
      # *Original* Parameters:
      # hWnd::  <in> Handle to the window.
      # lpRect:: <out> Pointer to a structure that receives the screen coordinates of the upper-left and
      #          lower-right corners of the window.
      # *Original* Return:: Nonzero indicates success. Zero indicates failure. For error info, call GetLastError.
      # ---
      # API improved to accept only window handle and return 4-member dimensions array (left, top, right, bottom)
      #
      # *New* Parameters:
      # win_handle:: Handle to the window
      # *Returns*:: Array(left, top, right, bottom) - rectangle dimensions
      # ---
      # *Remarks*: As a convention for the RECT structure, the bottom-right coordinates of the returned rectangle
      # are exclusive. In other words, the pixel at (right, bottom) lies immediately outside the rectangle.
      #
      #:call-seq:
      #   rect = [get_]window_rect( win_handle )
      #
      function :GetWindowRect, [:HWND, :pointer], :int,
               &->(api, handle) {
               rect = FFI::MemoryPointer.new(:long, 4)
               res = api.call handle, rect
               res == 0 ? [nil, nil, nil, nil] :  rect.read_array_of_long(4) }

      ##
      # EnumWindowsProc is an application-defined callback function that receives top-level window handles
      # as a result of a call to the EnumWindows, EnumChildWindows or EnumDesktopWindows function.
      #
      # [*Syntax*] BOOL CALLBACK EnumWindowsProc( HWND hwnd, LPARAM lParam );
      #
      # hWnd:: <in> Handle to a top-level window.
      # lParam:: <in> Specifies the application-defined value given in EnumWindows or EnumDesktopWindows.
      # *Return* *Value*:: To continue enumeration, the callback function must return TRUE;
      #                    to stop enumeration, it must return FALSE.
      # ---
      # Remarks:
      # - An application must register this callback function by passing its address to EnumWindows,
      #   EnumChildWindows or EnumDesktopWindows.
      # - You must ensure that the callback function sets SetLastError if it fails.
      #
      # :call-seq:
      #  EnumWindowsProc callback block: {|win_handle, value| your callback code }
      #
      callback :EnumWindowsProc, [:HWND, :long], :bool

      ##
      # The EnumWindows function enumerates all top-level windows on the screen by passing the handle to
      # each window, in turn, to an application-defined callback function. EnumWindows continues until
      # the last top-level window is enumerated or the callback function returns FALSE.
      #
      # [*Syntax*] BOOL EnumWindows( WNDENUMPROC lpEnumFunc, LPARAM lParam );
      #
      # *Original* Parameters:
      # lpEnumFunc:: <in> Pointer to an application-defined callback function of EnumWindowsProc type.
      # lParam:: <in> Specifies an application-defined value(message) to be passed to the callback function.
      # *Original* Return:: Nonzero if the function succeeds, zero if the function fails. GetLastError for error info.
      #                     If callback returns zero, the return value is also zero. In this case, the callback
      #                     function should call SetLastError to obtain a meaningful error code to be returned to
      #                     the caller of EnumWindows.
      # ---
      # API improved to accept blocks (instead of callback objects) with message as an optional argument
      #
      # *New* Parameters:
      # message:: Specifies an application-defined value(message) to be passed to the callback block.
      # attached block:: Serves as an application-defined callback function (see EnumWindowsProc).
      # *Returns*:: *True* if the function succeeds, *false* if the function fails. GetLastError for error info.
      #             If callback returned zero/false, the return value is also false. In this case, the callback
      #             function should call SetLastError to obtain a meaningful error code to be returned to the
      #             caller of EnumWindows.
      # ---
      # *Remarks*: The EnumWindows function does not enumerate child windows, with the exception of a few top-level
      # windows owned by the system that have the WS_CHILD style. This function is more reliable than calling
      # the GetWindow function in a loop. An application that calls GetWindow to perform this task risks being
      # caught in an infinite loop or referencing a handle to a window that has been destroyed.
      #
      # :call-seq:
      #   handles = enum_windows( [value=0] ) {|handle, value| your callback procedure }
      #
      function :EnumWindows, [:EnumWindowsProc, :long], :int8, &return_enum

      ##
      # EnumDesktopWindows Function enumerates all top-level windows associated with the specified desktop.
      # It passes the handle to each window, in turn, to an application-defined callback function.
      #
      # [*Syntax*] BOOL WINAPI EnumDesktopWindows( __in_opt HDESK hDesktop, __in WNDENUMPROC lpfn,  __in LPARAM lParam);
      #
      # *Original* Parameters:
      # hDesktop:: A handle to the desktop whose top-level windows are to be enumerated. This handle is returned by
      #            the CreateDesktop, GetThreadDesktop, OpenDesktop, or OpenInputDesktop function, and must have the
      #            DESKTOP_ENUMERATE access right. For more information, see Desktop Security and Access Rights.
      #            If this parameter is NULL, the current desktop is used.
      # lpfn:: A pointer to an application-defined EnumWindowsProc callback.
      # lParam:: An application-defined value to be passed to the callback.
      # *Return*:: If the function fails or is unable to perform the enumeration, the return value is zero.
      #            To get extended error information, call GetLastError. You must ensure that the callback function
      #            sets SetLastError if it fails.
      # ---
      # API enhanced to return *true*/*false* instead of nonzero/zero, and message value is optional (defaults to 0).
      #
      # *Enhanced*12 34 Parameters:
      # desktop:: A handle to the desktop whose top-level windows are to be enumerated.
      # value:: Specifies an application-defined value(message) to be passed to the callback (default 0).
      # attached block:: Serves as an application-defined callback function (see EnumWindowsProc).
      # ---
      # *Remarks*:
      # - Windows Server 2003 and Windows XP/2000: If there are no windows on the desktop, GetLastError returns
      #   ERROR_INVALID_HANDLE.
      # - The EnumDesktopWindows function repeatedly invokes the callback function until the last top-level window
      #   is enumerated or the callback function returns FALSE.
      # ---
      # *Requirements*:
      # Client Requires Windows Vista, Windows XP, or Windows 2000 Professional.
      #
      # :call-seq:
      #   handles = enum_desktop_windows( desktop_handle, [value=0] ) {|handle, value| your callback procedure }
      #
      function :EnumDesktopWindows, [:ulong, :EnumWindowsProc, :long], :int8, &return_enum

      ##
      # The EnumChildWindows function enumerates the child windows that belong to the specified parent window by
      # passing the handle of each child window, in turn, to an application-defined callback. EnumChildWindows
      # continues until the last child window is enumerated or the callback function returns FALSE.
      #
      # [*Syntax*] BOOL EnumChildWindows( HWND hWndParent, WNDENUMPROC lpEnumFunc, LPARAM lParam );
      #
      # *Original* Parameters:
      # hWndParent:: <in> Handle to the parent window whose child windows are to be enumerated. If this parameter
      #              is NULL, this function is equivalent to EnumWindows.
      #              Windows 95/98/Me: hWndParent cannot be NULL.
      # lpEnumFunc:: <in> Pointer to an application-defined callback. For more information, see EnumChildProc.
      # lParam:: <in> Specifies an application-defined value to be passed to the callback function.
      #
      # *Return*:: Not used!
      # ---
      # API improved to accept blocks (instead of callback objects) and parent handle (value is optional, default 0)
      #
      # *New* Parameters:
      # parent:: Handle to the parent window whose child windows are to be enumerated.
      # value:: Specifies an application-defined value(message) to be passed to the callback function.
      # attached block:: Serves as an application-defined callback function (see EnumWindowsProc).
      # ---
      # *Remarks*:
      # - If a child window has created child windows of its own, EnumChildWindows enumerates those windows as well.
      # - A child window that is moved or repositioned in the Z order during the enumeration process will be properly
      #   enumerated. The function does not enumerate a child window that is destroyed before being enumerated or that
      #   is created during the enumeration process.
      #
      #:call-seq:
      #   handles = enum_child_windows( parent_handle, [value=0] ) {|handle, value| your callback procedure }
      #
      function :EnumChildWindows, [:HWND, :EnumWindowsProc, :long], :int8, &return_enum

      ##
      # GetForegroundWindow function returns a handle to the foreground window (the window with which the user
      # is currently working). The system assigns a slightly higher priority to the thread that creates the
      # foreground window than it does to other threads.
      #
      # [*Syntax*]  HWND GetForegroundWindow(VOID);
      #
      # *Returns*:: The return value is a handle to the foreground window. The foreground window can be NULL in
      #             certain circumstances, such as when a window is losing activation.
      #
      #:call-seq:
      #   win_handle = [get_]foreground_window()
      #
      function :GetForegroundWindow, [], :HWND, zeronil: true

      ##
      # SetForegroundWindow function puts the thread that created the specified window into the foreground
      # and activates the window. Keyboard input is directed to the window, and various visual cues are 
      # changed for the user. The system assigns a slightly higher priority to the thread that created the
      # foreground window than it does to other threads.
      #
      # [*Syntax*] BOOL SetForegroundWindow( HWND hWnd );
      #
      # hWnd:: [in] Handle to the window that should be activated and brought to the foreground.
      #
      # *Returns*:: If the window was brought to the foreground, the return value is nonzero.
      # If the window was not brought to the foreground, the return value is zero.
      # ---
      # *Remarks*:
      # Windows 98/Me: The system restricts which processes can set the foreground window. A process can set
      # the foreground window only if one of the following conditions is true:
      # - The process is the foreground process.
      # - The process was started by the foreground process.
      # - The process received the last input event.
      # - There is no foreground process.
      # - The foreground process is being debugged.
      # - The foreground is not locked (see LockSetForegroundWindow).
      # - The foreground lock time-out has expired (see SPI_GETFOREGROUNDLOCKTIMEOUT in SystemParametersInfo).
      # - Windows 2000/XP: No menus are active.
      #
      # With this change, an application cannot force a window to the foreground while the user is working
      # with another window. Instead, Foreground and Background Windows will activate the window (see
      # SetActiveWindow) and call the function to notify the user. However, on Microsoft Windows 98 and
      # Windows Millennium Edition (Windows Me), if a nonforeground thread calls SetForegroundWindow and
      # passes the handle of a window that was not created by the calling thread, the window is not flashed on
      # the taskbar. To have SetForegroundWindow behave the same as it did on Windows 95 and Microsoft Windows
      # NT 4.0, change the foreground lock timeout value when the application is installed. This can be done
      # from the setup or installation application with the following function call:
      # SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, (LPVOID)0, SPIF_SENDWININICHANGE |
      # SPIF_UPDATEINIFILE);
      # This method allows SetForegroundWindow on Windows 98/Windows Me and Windows 2000/Windows XP to behave
      # the same as Windows 95 and Windows NT 4.0, respectively, for all applications. The setup application
      # should warn the user that this is being done so that the user isn't surprised by the changed behavior.
      # On Windows Windows 2000 and Windows XP, the call fails unless the calling thread can change the
      # foreground window, so this must be called from a setup or patch application. For more information, see
      # Foreground and Background Windows.
      # A process that can set the foreground window can enable another process to set the foreground window
      # by calling the AllowSetForegroundWindow function. The process specified by dwProcessId loses the
      # ability to set the foreground window the next time the user generates input, unless the input is
      # directed at that process, or the next time a process calls AllowSetForegroundWindow, unless that
      # process is specified.
      # The foreground process can disable calls to SetForegroundWindow by calling the LockSetForegroundWindow function.
      #
      # ---
      # <b>Enhanced (snake_case) API: returns true/false</b>
      #
      # :call-seq:
      #  success = set_foreground_window(h_wnd)
      #
      function :SetForegroundWindow, [:HWND], :int8, boolean: true

      ##
      # The GetActiveWindow function retrieves the window handle to the active window attached to
      # the calling thread's message queue.
      #
      # [*Syntax*]  HWND GetActiveWindow(VOID);
      #
      # *Returns*:: The return value is the handle to the active window attached to the calling
      #             thread's message queue. Otherwise, the return value is NULL.
      #
      #  Remarks: To get the handle to the foreground window, you can use GetForegroundWindow.
      #  To get the window handle to the active window in the message queue for another thread, use GetGuiThreadInfo.
      #
      #:call-seq:
      #   win_handle = [get_]active_window()
      #
      function :GetActiveWindow, [], :HWND, zeronil: true

      ##
      # The GetWindow function retrieves a handle to a window that has the specified relationship (Z-Order or
      # owner) to the specified window.
      #
      # [*Syntax*] HWND GetWindow( HWND hWnd, UINT uCmd );
      #
      # hWnd:: [in] Handle to a window. The window handle retrieved is relative to this window, based on the
      #        value of the uCmd parameter.
      # uCmd:: [in] Specifies the relationship between the specified window and the window whose handle is to
      #        be retrieved. This parameter can be one of the following values.
      #        GW_CHILD - The retrieved handle identifies the child window at the top of the Z order, if the specified
      #                   window is a parent window; otherwise, the retrieved handle is NULL. The function examines
      #                   only child windows of the specified window. It does not examine descendant windows.
      #        GW_ENABLEDPOPUP - Windows 2000/XP: The retrieved handle identifies the enabled popup window owned by
      #                          the specified window (the search uses the first such window found using GW_HWNDNEXT);
      #                          otherwise, if there are no enabled popup windows, the retrieved handle is that of the
      #                          specified window.
      #        GW_HWNDFIRST - The retrieved handle identifies the window of the same type that is highest in Z order.
      #                       If the specified window is a topmost window, the handle identifies the topmost window
      #                       that is highest in the Z order. If the specified window is a top-level window, the handle
      #                       identifies the top-level window that is highest in the Z order. If the specified window
      #                       is a child window, the handle identifies the sibling window that is highest in Z order.
      #        GW_HWNDLAST -  The retrieved handle identifies the window of the same type that is lowest in the Z order.
      #                       If the specified window is a topmost window, the handle identifies the topmost window that
      #                       is lowest in the Z order. If the specified window is a top-level window, the handle
      #                       identifies the top-level window that is lowest in the Z order. If the specified window is
      #                       a child window, the handle identifies the sibling window that is lowest in the Z order.
      #        GW_HWNDNEXT -  The retrieved handle identifies the window below the specified window in the Z order.
      #                       If the specified window is a topmost window, the handle identifies the topmost window
      #                       below the specified window. If the specified window is a top-level window, the handle
      #                       identifies the top-level window below the specified window. If the specified window is
      #                       a child window, the handle identifies the sibling window below the specified window.
      #        GW_HWNDPREV -  The retrieved handle identifies the window above the specified window in the Z order.
      #                       If the specified window is a topmost window, the handle identifies the topmost window
      #                       above the specified window. If the specified window is a top-level window, the handle
      #                       identifies the top-level window above the specified window. If the specified window is
      #                       a child window, the handle identifies the sibling window above the specified window.
      #        GW_OWNER - The retrieved handle identifies the specified window's owner window, if any. For more
      #                   information, see Owned Windows.
      # *Returns*:: If the function succeeds, the return value is a window handle. If no window exists with
      #             the specified relationship to the specified window, the return value is NULL. To get
      #             extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # The EnumChildWindows function is more reliable than calling GetWindow in a loop. An application that
      # calls GetWindow to perform this task risks being caught in an infinite loop or referencing a handle to
      # a window that has been destroyed.
      # Function Information
      #
      # ---
      # <b>Enhanced (snake_case) API: returns nil instead of 0 in case of failure</b>
      #
      # :call-seq:
      #  window_handle = get_window(h_wnd, u_cmd)
      #
      function :GetWindow, [:HWND, :UINT], :HWND, zeronil: true

      ##
      # The GetParent function retrieves a handle to the specified window's parent OR OWNER.
      # To retrieve a handle to a specified ancestor, use the GetAncestor function.
      #
      # [*Syntax*] HWND GetParent( HWND hWnd );
      #
      # hWnd:: [in] Handle to the window whose parent window handle is to be retrieved.
      #
      # *Returns*:: If the window is a child window, the return value is a handle to the parent window. If the
      #             window is a top-level window, the return value is a handle to the owner window. If the
      #             window is a top-level unowned window or if the function fails, the return value is NULL.
      #             To get extended error information, call GetLastError. For example, this would determine,
      #             when the function returns NULL, if the function failed or the window was a top-level window.
      # ---
      # *Remarks*:
      # Note that, despite its name, this function can return an owner window instead of a parent window. To
      # obtain the parent window and not the owner, use GetAncestor with the GA_PARENT flag.
      #
      # ---
      # <b>Enhanced (snake_case) API: returns nil instead of 0 in case of failure</b>
      #
      # :call-seq:
      #  parent = get_parent(h_wnd)
      #
      function :GetParent, [:HWND], :HWND, zeronil: true

      ##
      # The GetAncestor function retrieves the handle to the ancestor of the specified window.
      #
      # [*Syntax*] HWND GetAncestor( HWND hwnd, UINT gaFlags );
      #
      # hwnd:: [in] Handle to the window whose ancestor is to be retrieved. If this parameter is the desktop
      #        window, the function returns NULL.
      # gaFlags:: [in] Specifies the ancestor to be retrieved. This parameter can be one of the following values:
      #           GA_PARENT - Retrieves parent window. Unlike GetParent function, this does NOT include the owner.
      #           GA_ROOT - Retrieves the root window by walking the chain of parent windows.
      #           GA_ROOTOWNER - Retrieves the owned root window by walking the chain of parent and owner windows
      #                          returned by GetParent.
      #
      # *Returns*:: The return value is the handle to the ancestor window.
      # ---
      # <b>Enhanced (snake_case) API: returns nil instead of 0 in case of failure</b>
      #
      # :call-seq:
      #  ancestor = get_ancestor(hwnd, ga_flags)
      #
      function :GetAncestor, [:HWND, :UINT], :HWND, zeronil: true


      # Convenience wrapper methods:

      ##
      # Hides the window and activates another window
      #
      def hide_window( win_handle )
        show_window(win_handle, SW_HIDE)
      end

      ##
      # Tests if given window handle points to foreground (topmost) window
      #
      def foreground?( win_handle )
        win_handle == foreground_window
      end

      ##
      # Shuts down the window <b>created by different thread</b> by posting WM_SYSCOMMAND, SC_CLOSE message to it.
      # This closely emulates user clicking on X button of the target window. As it would be expected, this
      # actually gives the target window chance to close gracefully (it may ask user to save data and stuff).
      # I have not found so far how to REALLY destroy window in different thread without it asking user anything.
      #
      def shut_window( win_handle )
        post_message(win_handle, Win::Gui::Message::WM_SYSCOMMAND, Win::Gui::Message::SC_CLOSE, nil)
      end

      ##
      # Returns text associated with window by sending WM_GETTEXT message to it.
      # ---
      # *Remarks*: It is *different* from GetWindowText that returns only window title
      #
      def text( win_handle, buffer_size=1024 )
        buffer = FFI::MemoryPointer.new :char, buffer_size
        num_chars = send_message win_handle, Win::Gui::Message::WM_GETTEXT, buffer.size, buffer
        num_chars == 0 ?  nil : buffer.get_bytes(0, num_chars)
      end
    end
  end
end

