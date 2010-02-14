require 'win/library'

module Win

  # Contains constants, functions and wrappers related to Windows manipulation
  #
  module Window
    # Internal constants:

    # Windows keyboard-related Constants:
    # ? move to keyboard.rb?
    KEY_DELAY  = 0.00001

    include Win::Library

    #General constants:

    # Windows Message Get Text
    WM_GETTEXT = 0x000D
    # Windows Message Sys Command
    WM_SYSCOMMAND = 0x0112
    # Sys Command Close
    SC_CLOSE = 0xF060

    # Key down keyboard event (the key is being depressed)
    KEYEVENTF_KEYDOWN = 0
    # Key up keyboard event (the key is being released)
    KEYEVENTF_KEYUP = 2
    # Extended kb event. If specified, the scan code was preceded by a prefix byte having the value 0xE0 (224).
    KEYEVENTF_EXTENDEDKEY = 1

    # Virtual key codes:

    # Control-break processing
    VK_CANCEL   = 0x03
    #  Backspace? key
    VK_BACK     = 0x08
    #  Tab key
    VK_TAB      = 0x09
    #  Shift key
    VK_SHIFT    = 0x10
    #  Ctrl key
    VK_CONTROL  = 0x11
    #  ENTER key
    VK_RETURN   = 0x0D
    #  ALT key
    VK_ALT      = 0x12
    #  ALT key alias
    VK_MENU     = 0x12
    #  PAUSE key
    VK_PAUSE    = 0x13
    #  CAPS LOCK key
    VK_CAPITAL  = 0x14
    #  ESC key
    VK_ESCAPE   = 0x1B
    #  SPACEBAR
    VK_SPACE    = 0x20
    #  PAGE UP key
    VK_PRIOR    = 0x21
    #  PAGE DOWN key
    VK_NEXT     = 0x22
    #  END key
    VK_END      = 0x23
    #  HOME key
    VK_HOME     = 0x24
    #  LEFT ARROW key
    VK_LEFT     = 0x25
    #  UP ARROW key
    VK_UP       = 0x26
    #  RIGHT ARROW key
    VK_RIGHT    = 0x27
    #  DOWN ARROW key
    VK_DOWN     = 0x28
    #  SELECT key
    VK_SELECT   = 0x29
    #  PRINT key
    VK_PRINT    = 0x2A
    #  EXECUTE key
    VK_EXECUTE  = 0x2B
    #  PRINT SCREEN key
    VK_SNAPSHOT = 0x2C
    #  INS key
    VK_INSERT   = 0x2D
    #  DEL key
    VK_DELETE   = 0x2E
    #  HELP key
    VK_HELP     = 0x2F

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
      # Default callback just pushes all passed handles into Array that is returned if Enum function call was successful.
      # If runtime block is given it is added to the end of default callback (handles Array is still collected/returned).
      # If Enum function call failed, method returns nil, otherwise an Array of window handles.
      #
      def return_enum #:nodoc:
        lambda do |api, *args, &block|
          args.push 0 if args.size == api.prototype.size - 2 # If value is missing, it defaults to 0
          handles = []

          # Insert callback proc into appropriate place of args Array
          args[api.prototype.find_index(:enum_callback), 0] =
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
          buffer.put_string(0, "\x00" * 1023)
          args += [buffer, 1024]
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
    # Tests whether the specified window handle identifies an existing window.
    #   A thread should not use IsWindow for a window that it did not create because the window
    #   could be destroyed after this function was called. Further, because window handles are
    #   recycled the handle could even point to a different window.
    #
    # :call-seq:
    # window?( win_handle )
    #
    function 'IsWindow', 'L', 'L'

    ##
    # Tests if the specified window, its parent window, its parent's parent window, and so forth,
    # have the WS_VISIBLE style. Because the return value specifies whether the window has the
    # WS_VISIBLE style, it may be true even if the window is totally obscured by other windows.
    #
    # :call-seq:
    #   [window_]visible?( win_handle )
    #
    function 'IsWindowVisible', 'L', 'L', aliases: :visible?

    ##
    # Tests whether the specified window is maximized.
    #
    # :call-seq:
    #   zoomed?( win_handle ), maximized?( win_handle )
    #
    function 'IsZoomed', 'L', 'L', aliases: :maximized?

    ##
    # Tests whether the specified window is maximized.
    #
    # :call-seq:
    #   iconic?( win_handle ), minimized?( win_handle )
    #
    function 'IsIconic', 'L', 'L', aliases: :minimized?

    ##
    # Tests whether a window is a child (or descendant) window of a specified parent window.
    # A child window is the direct descendant of a specified parent window if that parent window
    # is in the chain of parent windows; the chain of parent windows leads from the original overlapped
    # or pop-up window to the child window.
    #
    # :call-seq:
    #   child?( win_handle )
    #
    function 'IsChild', 'LL', 'L'

    ##
    # Returns a handle to the top-level window whose class and window name match the specified strings.
    # This function does not search child windows. This function does not perform a case-sensitive search.
    #
    # Parameters:
    #   class_name (P) - String that specifies (window) class name OR class atom created by a previous
    #     call to the RegisterClass(Ex) function. The atom must be in the low-order word of class_name;
    #     the high-order word must be zero. The class name can be any name registered with RegisterClass(Ex),
    #     or any of the predefined control-class names. If this parameter is nil, it finds any window whose
    #     title matches the win_title parameter.
    #   win_name (P) - String that specifies the window name (title). If nil, all names match.
    # Return Value (L): found window handle or NIL if nothing found
    #
    # :call-seq:
    #   win_handle = find_window( class_name, win_name )
    #
    function 'FindWindow', 'PP', 'L', zeronil: true

    ##
    # Unicode version of find_window (strings must be encoded as utf-16LE AND terminate with "\x00\x00")
    #
    # :call-seq:
    #   win_handle = find_window_w( class_name, win_name )
    #
    function 'FindWindowW', 'PP', 'L', zeronil: true

    ##
    # Retrieves a handle to a CHILD window whose class name and window name match the specified strings.
    #   The function searches child windows, beginning with the one following the specified child window.
    #   This function does NOT perform a case-sensitive search.
    #
    # Parameters:
    #   parent (L) - Handle to the parent window whose child windows are to be searched.
    #     If nil, the function uses the desktop window as the parent window.
    #     The function searches among windows that are child windows of the desktop.
    #   after_child (L) - Handle to a child window. Search begins with the NEXT child window in the Z order.
    #     The child window must be a direct child window of parent, not just a descendant window.
    #     If after_child is nil, the search begins with the first child window of parent.
    #   win_class (P), win_title (P) - Strings that specify window class and name(title). If nil, anything matches.
    # Returns (L): found child window handle or NIL if nothing found
    #
    # :call-seq:
    #   win_handle = find_window_ex( win_handle, after_child, class_name, win_name )
    #
    function 'FindWindowEx', 'LLPP', 'L', zeronil: true

    ##
    # Returns the text of the specified window's title bar (if it has one).
    #   If the specified window is a control, the text of the control is copied. However, GetWindowText
    #   cannot retrieve the text of a control in another application.
    #
    # Original Parameters:
    #   win_handle (L) - Handle to the window and, indirectly, the class to which the window belongs.
    #   text (P) - Long Pointer to the buffer that is to receive the text string.
    #   max_count (I) - Specifies the length, in TCHAR, of the buffer pointed to by the text parameter.
    #   The class name string is truncated if it is longer than the buffer and is always null-terminated.
    # Original Return Value (L): Length, in characters, of the copied string, not including the terminating null
    #   character, indicates success. Zero indicates that the window has no title bar or text, if the title bar
    #   is empty, or if the window or control handle is invalid. For extended error information, call GetLastError.
    #
    # Enhanced API requires only win_handle and returns rstripped text
    #
    # Enhanced Parameters:
    #   win_handle (L) - Handle to the window and, indirectly, the class to which the window belongs.
    # Returns: Window title bar text or nil
    #   If the window has no title bar or text, if the title bar is empty, or if the window or control handle
    #   is invalid, the return value is NIL. To get extended error information, call GetLastError.
    #
    # Remarks: This function CANNOT retrieve the text of an edit control in ANOTHER app.
    #   If the target window is owned by the current process, GetWindowText causes a WM_GETTEXT message to
    #   be sent to the specified window or control. If the target window is owned by another process and has
    #   a caption, GetWindowText retrieves the window caption text. If the window does not have a caption,
    #   the return value is a null string. This allows to call GetWindowText without becoming unresponsive
    #   if the target window owner process is not responding. However, if the unresponsive target window
    #   belongs to the calling app, GetWindowText will cause the calling app to become unresponsive.
    #   To retrieve the text of a control in another process, send a WM_GETTEXT message directly instead
    #   of calling GetWindowText.
    #
    #:call-seq:
    #   text = [get_]window_text( win_handle )
    #
    function 'GetWindowText', 'LPI', 'L', &return_string

    ##
    # Unicode version of get_window_text (returns rstripped utf-8 string)
    # API improved to require only win_handle and return rstripped string
    #
    #:call-seq:
    #   text = [get_]window_text_w( win_handle )
    #
    function 'GetWindowTextW', 'LPI', 'L', &return_string('utf-8')

    ##
    # Retrieves the name of the class to which the specified window belongs.
    #
    # Original Parameters:
    #   win_handle (L) - Handle to the window and, indirectly, the class to which the window belongs.
    #   class_name (P) - Long Pointer to the buffer that is to receive the class name string.
    #   max_count (I) - Specifies the length, in TCHAR, of the buffer pointed to by the class_name parameter.
    #   The class name string is truncated if it is longer than the buffer and is always null-terminated.
    # Original Return Value (L): Length, in characters, of the copied string, not including the terminating null
    #   character, indicates success. Zero indicates that the window has no title bar or text, if the title bar
    #   is empty, or if the window or control handle is invalid. For extended error information, call GetLastError.
    #
    # API improved to require only win_handle and return rstripped string
    #
    # Enhanced Parameters:
    #   win_handle (L) - Handle to the window and, indirectly, the class to which the window belongs.
    # Returns: Name of the class or NIL if function fails. For extended error information, call GetLastError.
    #
    #:call-seq:
    #   text = [get_]class_name( win_handle )
    #
    function 'GetClassName', 'LPI', 'I', &return_string

    ##
    # Unicode version of get_class_name (returns rstripped utf-8 string)
    # API improved to require only win_handle and return rstripped string
    #
    #:call-seq:
    #   text = [get_]class_name_w( win_handle )
    #
    function 'GetClassNameW', 'LPI', 'I', &return_string('utf-8')

    ##
    # Shows and hides windows.
    #
    # Parameters:
    #   win_handle (L) - Handle to the window.
    #   cmd (I) - Specifies how the window is to be shown. This parameter is ignored the first time an
    #     application calls ShowWindow, if the program that launched the application provides a STARTUPINFO
    #     structure. Otherwise, the first time ShowWindow is called, the value should be the value obtained
    #     by the WinMain function in its nCmdShow parameter. In subsequent calls, cmd may be:
    # SW_HIDE, SW_MAXIMIZE, SW_MINIMIZE, SW_SHOW, SW_SHOWMAXIMIZED, SW_SHOWMINIMIZED, SW_SHOWMINNOACTIVE,
    # SW_SHOWNA, SW_SHOWNOACTIVATE, SW_SHOWNORMAL, SW_RESTORE, SW_SHOWDEFAULT, SW_FORCEMINIMIZE
    #
    # Original Return Value: - Nonzero if the window was PREVIOUSLY visible, otherwise zero
    # Enhanced Returns: - True if the window was PREVIOUSLY visible, otherwise false
    #
    #:call-seq:
    #   was_visible = show_window( win_handle, cmd )
    #
    function 'ShowWindow', 'LI', 'I', boolean: true

    # Hides the window and activates another window
    def hide_window(win_handle)
      show_window(win_handle, SW_HIDE)
    end

    ##
    # Retrieves the identifier of the thread that created the specified window
    #   and, optionally, the identifier of the process that created the window.
    #
    # Original Parameters:
    #   handle (L) - Handle to the window.
    #   process (P) - A POINTER to a (Long) variable that receives the process identifier.
    # Original Return (L): Identifier of the thread that created the window.
    #
    # API improved to accept window handle as a single arg and return a pair of [thread, process] ids
    #
    # New Parameters:
    #   handle (L) - Handle to the window.
    # Returns: Pair of identifiers of the thread and process_id that created the window.
    #
    #:call-seq:
    #   thread, process_id = [get_]window_tread_process_id( win_handle )
    #
    function 'GetWindowThreadProcessId', [:long, :pointer], :long, &->(api, *args) {
    namespace.enforce_count( args, api.prototype, -1)
    process = FFI::MemoryPointer.new(:long)
    process.write_long(1)
    thread = api.call(args.first, process)
    thread == 0 ? [nil, nil] : [thread, process.read_long()] }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

    ##
    # Retrieves the dimensions of the specified window bounding rectangle.
    #   Dimensions are given relative to the upper-left corner of the screen.
    #
    # Original Parameters:
    #   win_handle (L) - Handle to the window.
    #   rect (P) - Long pointer to a RECT structure that receives the screen coordinates of the upper-left and
    #     lower-right corners of the window.
    # Original Return Value: Nonzero indicates success. Zero indicates failure. For error info, call GetLastError.
    #
    # API improved to accept only window handle and return 4-member dimensions array (left, top, right, bottom)
    #
    # New Parameters:
    #   win_handle (L) - Handle to the window
    # New Return: Array(left, top, right, bottom) - rectangle dimensions
    #
    # Remarks: As a convention for the RECT structure, the bottom-right coordinates of the returned rectangle
    #   are exclusive. In other words, the pixel at (right, bottom) lies immediately outside the rectangle.
    #
    #:call-seq:
    #   rect = [get_]window_rect( win_handle )
    #
    function 'GetWindowRect', 'LP', 'I', &->(api, *args) {
    namespace.enforce_count( args, api.prototype, -1)
    rect = FFI::MemoryPointer.new(:long, 4)
    rect.write_array_of_long([0, 0, 0, 0])
    res = api.call args.first, rect
    res == 0 ? [nil, nil, nil, nil] : rect.read_array_of_long(4) }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

    # This is an application-defined callback function that receives top-level window handles as a result of a call
    # to the EnumWindows, EnumChildWindows or EnumDesktopWindows function.
    #
    # Syntax: BOOL CALLBACK EnumWindowsProc( HWND hwnd, LPARAM lParam );
    #
    # Parameters:
    #   hwnd (L) - [out] Handle to a top-level window.
    #   lParam (L) - [in] Specifies the application-defined value given in EnumWindows or EnumDesktopWindows.
    # Return Values:
    #   TRUE continues enumeration. FALSE stops enumeration.
    #
    # Remarks: An application must register this callback function by passing its address to EnumWindows or EnumDesktopWindows.
    callback :enum_callback, 'LL', :bool

    ##
    # The EnumWindows function enumerates all top-level windows on the screen by passing the handle to
    #   each window, in turn, to an application-defined callback function. EnumWindows continues until
    #   the last top-level window is enumerated or the callback function returns FALSE.
    #
    # Original Parameters:
    #   callback [K] - Pointer to an application-defined callback function (see EnumWindowsProc).
    #   value [P] - Specifies an application-defined value(message) to be passed to the callback function.
    # Original Return: Nonzero if the function succeeds, zero if the function fails. GetLastError for error info.
    #   If callback returns zero, the return value is also zero. In this case, the callback function should
    #   call SetLastError to obtain a meaningful error code to be returned to the caller of EnumWindows.
    #
    # API improved to accept blocks (instead of callback objects) and message as a single arg
    #
    # New Parameters:
    #   message [P] - Specifies an application-defined value(message) to be passed to the callback function.
    #   block given to method invocation serves as an application-defined callback function (see EnumWindowsProc).
    # Returns: True if the function succeeds, false if the function fails. GetLastError for error info.
    #   If callback returns zero, the return value is also zero. In this case, the callback function should
    #   call SetLastError to obtain a meaningful error code to be returned to the caller of EnumWindows.
    #
    # Remarks: The EnumWindows function does not enumerate child windows, with the exception of a few top-level
    #   windows owned by the system that have the WS_CHILD style. This function is more reliable than calling
    #   the GetWindow function in a loop. An application that calls GetWindow to perform this task risks being
    #   caught in an infinite loop or referencing a handle to a window that has been destroyed.
    #
    #:call-seq:
    #   handles = enum_windows( [value] ) {|handle, message| your callback procedure }
    #
    function'EnumWindows', [:enum_callback, :long], :bool, &return_enum

    ##
    #EnumDesktopWindows Function
    #
    #Enumerates all top-level windows associated with the specified desktop. It passes the handle to each window, in turn, to an application-defined callback function.
    #
    #
    #Syntax
    #BOOL WINAPI EnumDesktopWindows(
    #  __in_opt  HDESK hDesktop,
    #  __in      WNDENUMPROC lpfn,
    #  __in      LPARAM lParam
    #);
    #
    #Parameters
    #hDesktop
    #A handle to the desktop whose top-level windows are to be enumerated. This handle is returned by the CreateDesktop, GetThreadDesktop, OpenDesktop, or OpenInputDesktop function, and must have the DESKTOP_ENUMERATE access right. For more information, see Desktop Security and Access Rights.
    #
    #If this parameter is NULL, the current desktop is used.
    #
    #lpfn
    #A pointer to an application-defined EnumWindowsProc callback function.
    #
    #lParam
    #An application-defined value to be passed to the callback function.
    #
    #Return Value
    #If the function fails or is unable to perform the enumeration, the return value is zero.
    #
    #To get extended error information, call GetLastError.
    #
    #You must ensure that the callback function sets SetLastError if it fails.
    #
    #Windows Server 2003 and Windows XP/2000:  If there are no windows on the desktop, GetLastError returns ERROR_INVALID_HANDLE.
    #Remarks
    #The EnumDesktopWindows function repeatedly invokes the lpfn callback function until the last top-level window is enumerated or the callback function returns FALSE.
    #
    #Requirements
    #Client Requires Windows Vista, Windows XP, or Windows 2000 Professional.
    function'EnumDesktopWindows', [:ulong, :enum_callback, :long], :bool, &return_enum

    ##
    # Enumerates child windows to a given window.
    #
    # Original Parameters:
    #   parent (L) - Handle to the parent window whose child windows are to be enumerated.
    #   callback [K] - Pointer to an application-defined callback function (see EnumWindowsProc).
    #   message [P] - Specifies an application-defined value(message) to be passed to the callback function.
    # Original Return: Not used (?!)
    #   If callback returns zero, the return value is also zero. In this case, the callback function should
    #   call SetLastError to obtain a meaningful error code to be returned to the caller of EnumWindows.
    #   If it is nil, this function is equivalent to EnumWindows. Windows 95/98/Me: parent cannot be NULL.
    #
    # API improved to accept blocks (instead of callback objects) and parent handle (value is optional, default 0)
    # New Parameters:
    #   parent (L) - Handle to the parent window whose child windows are to be enumerated.
    #   value (P) - Specifies an application-defined value(message) to be passed to the callback function.
    #   block given to method invocation serves as an application-defined callback function (see EnumChildProc).
    #
    # Remarks:
    #   If a child window has created child windows of its own, EnumChildWindows enumerates those windows as well.
    #   A child window that is moved or repositioned in the Z order during the enumeration process will be properly enumerated.
    #   The function does not enumerate a child window that is destroyed before being enumerated or that is created during the enumeration process.
    #
    #:call-seq:
    #   handles = enum_child_windows( parent_handle, [value = 0] ) {|handle, message| your callback procedure }
    #
    function 'EnumChildWindows', [:ulong, :enum_callback, :long], :bool, &return_enum

    ##
    # GetForegroundWindow function returns a handle to the foreground window (the window with which the user
    # is currently working). The system assigns a slightly higher priority to the thread that creates the
    # foreground window than it does to other threads.
    #
    # Syntax:  HWND GetForegroundWindow(VOID);
    #
    # Return Value: The return value is a handle to the foreground window. The foreground window can be NULL in
    # certain circumstances, such as when a window is losing activation.
    #
    #:call-seq:
    #   win_handle = [get_]foreground_window()
    #
    function 'GetForegroundWindow', [], 'L'

    ##
    # Tests if given window handle points to foreground (topmost) window
    #
    def foreground?(win_handle)
      win_handle == foreground_window
    end

    ##
    # The GetActiveWindow function retrieves the window handle to the active window attached to
    # the calling thread's message queue.
    #
    # Syntax:  HWND GetActiveWindow(VOID);
    #
    # Return Value: The return value is the handle to the active window attached to the calling
    # thread's message queue. Otherwise, the return value is NULL.
    #
    #  Remarks: To get the handle to the foreground window, you can use GetForegroundWindow.
    #  To get the window handle to the active window in the message queue for another thread, use GetGUIThreadInfo.
    #
    #:call-seq:
    #   win_handle = [get_]active_window()
    #
    function 'GetActiveWindow', [], 'L'

    ##
    # The keybd_event function synthesizes a keystroke. The system can use such a synthesized keystroke to generate
    # a WM_KEYUP or WM_KEYDOWN message. The keyboard driver's interrupt handler calls the keybd_event function.
    #
    # !!!! Windows NT/2000/XP/Vista:This function has been superseded. Use SendInput instead.
    #
    # Syntax: VOID keybd_event( BYTE bVk, BYTE bScan, DWORD dwFlags, PTR dwExtraInfo);
    #
    # Parameters:
    #   bVk [C] - [in] Specifies a virtual-key code. The code must be a value in the range 1 to 254.
    #      For a complete list, see Virtual-Key Codes.
    #   bScan [C] - [in] Specifies a hardware scan code for the key.
    #   dwFlags [L] - [in] Specifies various aspects of function operation. This parameter can be
    #     one or more of the following values:
    # KEYEVENTF_EXTENDEDKEY, KEYEVENTF_KEYUP, KEYEVENTF_KEYDOWN
    #   dwExtraInfo [L] -[in] Specifies an additional value associated with the key stroke.
    #
    # Return Value: none
    #
    # Remarks: An application can simulate a press of the PRINTSCRN key in order to obtain a screen snapshot and save
    # it to the clipboard. To do this, call keybd_event with the bVk parameter set to VK_SNAPSHOT.
    #
    # Windows NT/2000/XP: The keybd_event function can toggle the NUM LOCK, CAPS LOCK, and SCROLL LOCK keys.
    # Windows 95/98/Me: The keybd_event function can toggle only the CAPS LOCK and SCROLL LOCK keys.
    #
    function 'keybd_event', 'IILL', 'V'

    function 'PostMessage', 'LLLL', 'L'
    function 'SendMessage', 'LLLP', 'L'
    function 'GetDlgItem', 'LL', 'L'

  end
end
