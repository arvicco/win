require 'win/library'

module Win
  module Gui
    # Contains constants and Win32API functions related to end user input
    #
    module Input
      include Win::Library

      # Windows keyboard-related Constants:

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

#  Public Type MOUSEINPUT
#  dx As Long
#  dy As Long
#  mouseData As Long
#  dwFlags As Long
#  time As Long
#  dwExtraInfo As Long
#  End Type
#
#  Public Type INPUT_TYPE
#  dwType As Long
#  xi(0 To 23) As Byte
#  End Type



      # dwFlags:
      # Specifies that the dx and dy parameters contain normalized absolute coordinates. If not set, those parameters
      # contain relative data: the change in position since the last reported position. This flag can be set, or not
      # set, regardless of what kind of mouse or mouse-like device, if any, is connected to the system. For further
      # information about relative mouse motion, see mouse_event Remarks section.
      MOUSEEVENTF_ABSOLUTE = 0x8000
      #Specifies that movement occurred.
      MOUSEEVENTF_MOVE = 0x01
      #Specifies that the left button is down.
      MOUSEEVENTF_LEFTDOWN = 0x02
      #Specifies that the left button is up.
      MOUSEEVENTF_LEFTUP  = 0x04
      #Specifies that the right button is down.
      MOUSEEVENTF_RIGHTDOWN = 0x08
      #Specifies that the right button is up.
      MOUSEEVENTF_RIGHTUP = 0x010
      #Specifies that the middle button is down.
      MOUSEEVENTF_MIDDLEDOWN = 0x20
      #Specifies that the middle button is up.
      MOUSEEVENTF_MIDDLEUP = 0x040
      #Windows NT/2000/XP: Specifies that the wheel has been moved, if the mouse has a wheel. The amount of movement
      #is specified in dwData
      MOUSEEVENTF_WHEEL = 0x80
      #Windows 2000/XP: Specifies that an X button was pressed.
      MOUSEEVENTF_XDOWN = 0x100
      #Windows 2000/XP: Specifies that an X button was released.
      MOUSEEVENTF_XUP = 0x200

      # dwData:
      # One wheel click is defined as WHEEL_DELTA, which is 120.
      WHEEL_DELTA = 120
      # Set if the first X button was pressed or released.
      XBUTTON1    = 1
      # Set if the second X button was pressed or released.
      XBUTTON2    = 2
      # Indicates NO data if dwFlags are NOT any of MOUSEEVENTF_WHEEL, MOUSEEVENTF_XDOWN, or MOUSEEVENTF_XUP
      INPUT_MOUSE = 0


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

      ##
      # The mouse_event function synthesizes mouse motion and button clicks.
      # !!!! Windows NT/2000/XP: This function has been superseded. Use SendInput instead.
      #
      # Syntax: VOID mouse_event( DWORD dwFlags, DWORD dx, DWORD dy, DWORD dwData, ULONG_PTR dwExtraInfo );
      #
      # Parameters:
      #   flags (I) - [in] Specifies various aspects of mouse motion and button clicking. This parameter can be
      #     certain combinations of the following values. The values that specify mouse button status are set to
      #     indicate changes in status, not ongoing conditions. For example, if the left mouse button is pressed
      #     and held down, MOUSEEVENTF_LEFTDOWN is set when the left button is first pressed, but not for subsequent
      #     motions. Similarly, MOUSEEVENTF_LEFTUP is set only when the button is first released. You cannot specify
      #     both MOUSEEVENTF_WHEEL and either MOUSEEVENTF_XDOWN or MOUSEEVENTF_XUP simultaneously, because they
      #     both require use of the dwData field:
      # MOUSEEVENTF_ABSOLUTE, MOUSEEVENTF_MOVE, MOUSEEVENTF_LEFTDOWN, MOUSEEVENTF_LEFTUP, MOUSEEVENTF_RIGHTDOWN,
      # MOUSEEVENTF_RIGHTUP, MOUSEEVENTF_MIDDLEDOWN, MOUSEEVENTF_MIDDLEUP, MOUSEEVENTF_WHEEL, MOUSEEVENTF_XDOWN,
      # MOUSEEVENTF_XUP
      #   dx (I) - [in] Specifies the mouse's absolute position along the x-axis or its amount of motion since the
      #     last mouse event was generated, depending on the setting of MOUSEEVENTF_ABSOLUTE. Absolute data is
      #     specified as the mouse's actual x-coordinate; relative data is specified as the number of mickeys moved.
      #     A mickey is the amount that a mouse has to move for it to report that it has moved.
      #   dy (I) - [in] Specifies the mouse's absolute position along the y-axis or its amount of motion since the
      #     last mouse event was generated, depending on the setting of MOUSEEVENTF_ABSOLUTE. Absolute data is
      #     specified as the mouse's actual y-coordinate; relative data is specified as the number of mickeys moved.
      #   data (I) - [in] If flags contains MOUSEEVENTF_WHEEL, then data specifies the amount of wheel movement.
      #     A positive value indicates that the wheel was rotated forward, away from the user; a negative value
      #     indicates that the wheel was rotated backward, toward the user. One wheel click is defined as
      #     WHEEL_DELTA, which is 120. If flags contains MOUSEEVENTF_WHHEEL, then data specifies the amount of
      #     wheel movement. A positive value indicates that the wheel was rotated to the right; a negative value
      #     indicates that the wheel was rotated to the left. One wheel click is defined as WHEEL_DELTA, which is 120.
      #     Windows 2000/XP: If flags contains MOUSEEVENTF_XDOWN or MOUSEEVENTF_XUP, then data specifies which X
      #     buttons were pressed or released. This value may be any combination of the following flags.
      #     If flags is not MOUSEEVENTF_WHEEL, MOUSEEVENTF_XDOWN, or MOUSEEVENTF_XUP, then data should be zero.
      # XBUTTON1 - Set if the first X button was pressed or released.
      # XBUTTON2 - Set if the second X button was pressed or released.
      #   extra_info (P) - [in] Specifies an additional value associated with the mouse event. An application
      #     calls GetMessageExtraInfo to obtain this extra information.
      #
      # NO Return Value
      #
      # Remarks: If the mouse has moved, indicated by MOUSEEVENTF_MOVE being set, dx and dy hold information about
      # that motion. The information is specified as absolute or relative integer values. If MOUSEEVENTF_ABSOLUTE
      # value is specified, dx and dy contain normalized absolute coordinates between 0 and 65,535. The event
      # procedure maps these coordinates onto the display surface. Coordinate (0,0) maps onto the upper-left corner
      # of the display surface, (65535,65535) maps onto the lower-right corner. If the MOUSEEVENTF_ABSOLUTE value
      # is not specified, dx and dy specify relative motions from when the last mouse event was generated (the last
      # reported position). Positive values mean the mouse moved right (or down); negative values mean the mouse
      # moved left (or up). Relative mouse motion is subject to the settings for mouse speed and acceleration level.
      # An end user sets these values using the Mouse application in Control Panel. An application obtains and sets
      # these values with the SystemParametersInfo function. The system applies two tests to the specified relative
      # mouse motion when applying acceleration. If the specified distance along either the x or y axis is greater
      # than the first mouse threshold value, and the mouse acceleration level is not zero, the operating system
      # doubles the distance. If the specified distance along either the x- or y-axis is greater than the second
      # mouse threshold value, and the mouse acceleration level is equal to two, the operating system doubles the
      # distance that resulted from applying the first threshold test. It is thus possible for the operating system
      # to multiply relatively-specified mouse motion along the x- or y-axis by up to four times. Once acceleration
      # has been applied, the system scales the resultant value by the desired mouse speed. Mouse speed can range
      # from 1 (slowest) to 20 (fastest) and represents how much the pointer moves based on the distance the mouse
      # moves. The default value is 10, which results in no additional modification to the mouse motion. The
      # mouse_event function is used to synthesize mouse events by applications that need to do so. It is also used
      # by applications that need to obtain more information from the mouse than its position and button state.
      # For example, if a tablet manufacturer wants to pass pen-based information to its own applications, it can
      # write a DLL that communicates directly to the tablet hardware, obtains the extra information, and saves it
      # in a queue. The DLL then calls mouse_event with the standard button and x/y position data, along with,
      # in the dwExtraInfo parameter, some pointer or index to the queued extra information. When the application
      # needs the extra information, it calls the DLL with the pointer or index stored in dwExtraInfo, and the DLL
      # returns the extra information.
      #
      #
      function 'mouse_event', 'IIIIP', 'V'

      ##
      # SetCursorPos Function moves the cursor to the specified screen coordinates. If the new coordinates are not
      # within the screen rectangle set by the most recent ClipCursor function call, the system automatically adjusts
      # the coordinates so that the cursor stays within the rectangle.
      #
      # Syntax: BOOL SetCursorPos( int X, int Y );
      #
      # Parameters:
      #  X (i) - [in] Specifies the new x-coordinate of the cursor, in screen coordinates.
      #  Y (i) - [in] Specifies the new y-coordinate of the cursor, in screen coordinates.
      #
      # Return Value: Nonzero if successful or zero otherwise. To get extended error information, call GetLastError.
      # Enhanced to return true/false instead of nonzero/zero
      #
      # Remarks: The cursor is a shared resource. A window should move the cursor only when the cursor is in the
      # window's client area. The calling process must have WINSTA_WRITEATTRIBUTES access to the window station.
      # The input desktop must be the current desktop when you call SetCursorPos. Call OpenInputDesktop to determine
      # whether the current desktop is the input desktop. If it is not, call SetThreadDesktop with the HDESK returned
      # by OpenInputDesktop to switch to that desktop.
      #
      # :call-seq:
      #   success = set_cursor_pos(x,y)
      #
      function :SetCursorPos, [:int, :int], :bool
      
    end
  end
end
