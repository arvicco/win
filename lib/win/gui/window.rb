require 'win/library'

module Win
  module Gui
    # Contains constants and Win32API functions related to window manipulation
    #
    module Window
      include Win::Library

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
      # hWnd:: [in] Handle to the window to test.
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
      function :IsWindow, [:ulong], :int, boolean: true

      ##
      # The IsWindowVisible function retrieves the visibility state of the specified window.
      # [*Syntax*] BOOL IsWindowVisible( HWND hWnd );
      #
      # hWnd:: [in] Handle to the window to test.
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
      function :IsWindowVisible, [:ulong], :int, boolean: true, aliases: :visible?

      ##
      # Tests whether the specified window is maximized.
      # [*Syntax*] BOOL IsZoomed( HWND hWnd );
      #
      # hWnd:: [in] Handle to the window to test.
      #
      # *Returns*:: If the window is zoomed (maximized), the return value is *true*.
      #             If the window is not zoomed (maximized), the return value is *false*.
      #
      # :call-seq:
      #   zoomed?( win_handle ), maximized?( win_handle )
      #
      function :IsZoomed, [:ulong], :int, boolean: true, aliases: :maximized?

      ##
      # Tests whether the specified window is minimized.
      # [*Syntax*] BOOL IsIconic( HWND hWnd );
      #
      # hWnd:: [in] Handle to the window to test.
      #
      # *Returns*:: If the window is iconic (minimized), the return value is *true*.
      #             If the window is not iconic (minimized), the return value is *false*.
      #
      # :call-seq:
      #   iconic?( win_handle ), minimized?( win_handle )
      #
      function :IsIconic, [:ulong], :int, boolean: true, aliases: :minimized?

      ##
      # Tests whether a window is a child (or descendant) window of a specified parent window.
      # A child window is the direct descendant of a specified parent window if that parent window
      # is in the chain of parent windows; the chain of parent windows leads from the original overlapped
      # or pop-up window to the child window.
      #
      # [*Syntax*] BOOL IsChild( HWND hWndParent, HWND hWnd);
      #
      # hWndParent:: [in] Handle to the parent window.
      # hWnd:: [in] Handle to the window to be tested.
      #
      # *Returns*::  If the window is a child or descendant window of the specified parent window,
      #              the return value is *true*. If the window is not a child or descendant window of
      #              the specified parent window, the return value is *false*.
      # :call-seq:
      #   child?( win_handle )
      #
      function :IsChild, [:ulong, :ulong], :int, boolean: true

      ##
      # The FindWindow function retrieves a handle to the top-level window whose class name and window name
      # match the specified strings. This function does not search child windows. This function does not
      # perform a case-sensitive search.
      #
      # To search child windows, beginning with a specified child window, use the FindWindowEx function.
      #
      # [*Syntax*] HWND FindWindow( LPCTSTR lpClassName, LPCTSTR lpWindowName );
      #
      # lpClassName:: [in] Pointer to a null-terminated string that specifies the class name or a class
      #               atom created by a previous call to the RegisterClass or RegisterClassEx function.
      #               The atom must be in the low-order word of lpClassName; the high-order word must be zero.
      #               If lpClassName points to a string, it specifies the window class name. The class name
      #               can be any name registered with RegisterClass or RegisterClassEx, or any of the
      #               predefined control-class names.
      #               If lpClassName is NULL, it finds any window whose title matches the lpWindowName parameter.
      # lpWindowName:: [in] Pointer to a null-terminated string that specifies the window name (the window's title).
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
      function :FindWindow, [:pointer, :pointer], :ulong, zeronil: true

      ##
      # Unicode version of FindWindow (strings must be encoded as utf-16LE AND terminate with "\x00\x00")
      #
      # :call-seq:
      #   win_handle = find_window_w( class_name, win_name )
      #
      function :FindWindowW, [:pointer, :pointer], :ulong, zeronil: true

      ##
      #  The FindWindowEx function retrieves a handle to a window whose class name and window name match the specified
      #  strings. The function searches child windows, beginning with the one following the specified child window.
      #  This function does not perform a case-sensitive search.
      #
      #  [*Syntax*] HWND FindWindowEx( HWND hwndParent, HWND hwndChildAfter, LPCTSTR lpszClass, LPCTSTR lpszWindow );
      #
      #  hwndParent:: [in] Handle to the parent window whose child windows are to be searched.
      #               If hwndParent is NULL, the function uses the desktop window as the parent window.
      #               The function searches among windows that are child windows of the desktop.
      #               Microsoft Windows 2000 and Windows XP: If hwndParent is HWND_MESSAGE, the function
      #               searches all message-only windows.
      #  hwndChildAfter:: [in] Handle to a child window. The search begins with the next child window in the Z order.
      #                   The child window must be a direct child window of hwndParent, not just a descendant window.
      #                   If hwndChildAfter is NULL, the search begins with the first child window of hwndParent.
      #                   Note that if both hwndParent and hwndChildAfter are NULL, the function searches all
      #                   top-level and message-only windows.
      #  lpszClass:: [in] Pointer to a null-terminated string that specifies the class name or a class atom created
      #              by a previous call to the RegisterClass or RegisterClassEx function. The atom must be placed in
      #              the low-order word of lpszClass; the high-order word must be zero.
      #              If lpszClass is a string, it specifies the window class name. The class name can be any name
      #              registered with RegisterClass or RegisterClassEx, or any of the predefined control-class names,
      #              or it can be MAKEINTATOM(0x800). In this latter case, 0x8000 is the atom for a menu class. For
      #              more information, see the Remarks section of this topic.
      #  lpszWindow:: [in] Pointer to a null-terminated string that specifies the window name (the window's title).
      #               If this parameter is NULL, all window names match.
      #
      #  *Returns*:: If the function succeeds, the return value is a handle to the window that has the specified
      #              class and window names. If the function fails, the return value is NULL. For extended error info,
      #              call GetLastError.
      #  ---
      #  *Remarks*:
      #  - If the lpszWindow parameter is not NULL, FindWindowEx calls the GetWindowText function to retrieve the window name for comparison. For a description of a potential problem that can arise, see the Remarks section of GetWindowText.
      #  - An application can call this function in the following way.
      #         find_window_ex( nil, nil, MAKEINTATOM(0x8000), nil )
      #    0x8000 is the atom for a menu class. When an application calls this function, the function checks whether
      #    a context menu is being displayed that the application created.
      #
      # :call-seq:
      #   win_handle = find_window_ex( win_handle, after_child, class_name, win_name )
      #
      function :FindWindowEx, [:ulong, :ulong, :pointer, :pointer], :ulong, zeronil: true

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
      function :GetWindowText, [:ulong, :pointer, :int], :int, &return_string

      ##
      # GetWindowTextW is a Unicode version of GetWindowText (returns rstripped utf-8 string)
      # API improved to require only win_handle and return rstripped string
      #
      #:call-seq:
      #   text = [get_]window_text_w( win_handle )
      #
      function :GetWindowTextW, [:ulong, :pointer, :int], :int, &return_string('utf-8')

      ##
      # GetClassName retrieves the name of the class to which the specified window belongs.
      # [*Syntax*] int GetClassName( HWND hWnd, LPTSTR lpClassName, int nMaxCount );
      # *Original* Parameters:
      # hWnd:: [in] Handle to the window and, indirectly, the class to which the window belongs.
      # lpClassName:: [out] Pointer to the buffer that is to receive the class name string.
      # nMaxCount:: [in] Specifies the length, in TCHAR, of the buffer pointed to by the lpClassName parameter.
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
      function :GetClassName, [:ulong, :pointer, :int], :int, &return_string

      ##
      # GetClassNameW is a Unicode version of GetClassName (returns rstripped utf-8 string)
      # API improved to require only win_handle and return rstripped string
      #
      #:call-seq:
      #   text = [get_]class_name_w( win_handle )
      #
      function :GetClassNameW, [:ulong, :pointer, :int], :int, &return_string('utf-8')

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
      function :ShowWindow, [:ulong, :int], :int, boolean: true

      ##
      # GetWindowThreadProcessId retrieves the identifier of the thread that created the specified window
      # and, optionally, the identifier of the process that created the window.
      #
      # [*Syntax*] DWORD GetWindowThreadProcessId( HWND hWnd, LPDWORD lpdwProcessId );
      #
      # *Original* Parameters:
      # hWnd:: [in] Handle to the window.
      # lpdwProcessId:: [out] Pointer to a variable that receives the process identifier. If this parameter
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
      #   thread, process_id = [get_]window_tread_process_id( win_handle )
      #
      function :GetWindowThreadProcessId, [:ulong, :pointer], :long,
               &->(api, *args) {
               namespace.enforce_count( args, api.prototype, -1)
               process = FFI::MemoryPointer.new(:long).write_long(1)
               thread = api.call(args.first, process)
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
      # hWnd::  [in] Handle to the window.
      # lpRect:: [out] Pointer to a structure that receives the screen coordinates of the upper-left and
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
      function :GetWindowRect, [:ulong, :pointer], :int,
               &->(api, *args) {
               namespace.enforce_count( args, api.prototype, -1)
               rect = FFI::MemoryPointer.new(:long, 4)
               #rect.write_array_of_long([0, 0, 0, 0])
               res = api.call args.first, rect
               res == 0 ? [nil, nil, nil, nil] :  rect.read_array_of_long(4) }
      # weird lambda literal instead of normal block is needed because current version of RDoc
      # goes crazy if block is attached to meta-definition

      ##
      # EnumWindowsProc is an application-defined callback function that receives top-level window handles
      # as a result of a call to the EnumWindows, EnumChildWindows or EnumDesktopWindows function.
      #
      # [*Syntax*] BOOL CALLBACK EnumWindowsProc( HWND hwnd, LPARAM lParam );
      #
      # hWnd:: [in] Handle to a top-level window.
      # lParam:: [in] Specifies the application-defined value given in EnumWindows or EnumDesktopWindows.
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
      callback :EnumWindowsProc, [:ulong, :long], :bool

      ##
      # The EnumWindows function enumerates all top-level windows on the screen by passing the handle to
      #   each window, in turn, to an application-defined callback function. EnumWindows continues until
      #   the last top-level window is enumerated or the callback function returns FALSE.
      #
      # [*Syntax*] BOOL EnumWindows( WNDENUMPROC lpEnumFunc, LPARAM lParam );
      #
      # *Original* Parameters:
      # lpEnumFunc:: [in] Pointer to an application-defined callback function of EnumWindowsProc type.
      # lParam:: [in] Specifies an application-defined value(message) to be passed to the callback function.
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
      function :EnumWindows, [:EnumWindowsProc, :long], :bool, &return_enum

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
      function :EnumDesktopWindows, [:ulong, :EnumWindowsProc, :long], :bool, &return_enum

      ##
      # The EnumChildWindows function enumerates the child windows that belong to the specified parent window by
      # passing the handle of each child window, in turn, to an application-defined callback. EnumChildWindows
      # continues until the last child window is enumerated or the callback function returns FALSE.
      #
      # [*Syntax*] BOOL EnumChildWindows( HWND hWndParent, WNDENUMPROC lpEnumFunc, LPARAM lParam );
      #
      # *Original* Parameters:
      # hWndParent:: [in] Handle to the parent window whose child windows are to be enumerated. If this parameter
      #              is NULL, this function is equivalent to EnumWindows.
      #              Windows 95/98/Me: hWndParent cannot be NULL.
      # lpEnumFunc:: [in] Pointer to an application-defined callback. For more information, see EnumChildProc.
      # lParam:: [in] Specifies an application-defined value to be passed to the callback function.
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
      function :EnumChildWindows, [:ulong, :EnumWindowsProc, :long], :bool, &return_enum

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
      function :GetForegroundWindow, [], :ulong, zeronil: true

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
      #  To get the window handle to the active window in the message queue for another thread, use GetGUIThreadInfo.
      #
      #:call-seq:
      #   win_handle = [get_]active_window()
      #
      function :GetActiveWindow, [], :ulong, zeronil: true

      # Convenience wrapper methods:

      ##
      # Hides the window and activates another window
      #
      def hide_window(win_handle)
        show_window(win_handle, SW_HIDE)
      end

      ##
      # Tests if given window handle points to foreground (topmost) window
      #
      def foreground?(win_handle)
        win_handle == foreground_window
      end
    end
  end
end

