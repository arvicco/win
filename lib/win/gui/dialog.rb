require 'win/library'
require 'win/gui/window'

module Win
  module Gui

    # Contains constants and Win32 API functions related to dialog manipulation.
    # Windows dialog basics can be found here:
    # http://msdn.microsoft.com/en-us/library/ms644996#init_box
    module Dialog
      include Win::Library
      include Win::Gui::Window

      # Message Box flags:

      # To indicate the buttons displayed in the message box, specify one of the following values:

      # The message box contains one push button: OK. This is the default.
      MB_OK                        = 0x00000000
      # The message box contains two push buttons: OK and Cancel.
      MB_OKCANCEL                  = 0x00000001
      # The message box contains three push buttons: Abort, Retry, and Ignore (considered obsolete)
      MB_ABORTRETRYIGNORE          = 0x00000002
      # The message box contains three push buttons: Yes, No, and Cancel.
      MB_YESNOCANCEL               = 0x00000003
      # The message box contains two push buttons: Yes and No.
      MB_YESNO                     = 0x00000004
      # The message box contains two push buttons: Retry and Cancel.
      MB_RETRYCANCEL               = 0x00000005
      #  The message box contains three push buttons: Cancel, Try Again, Continue (Win 2000/XP).
      # Use this message box type instead of MB_ABORTRETRYIGNORE.
      MB_CANCELTRYCONTINUE         = 0x00000006

      # To display an icon in the message box, specify one of the following values:

      # A stop-sign icon appears in the message box.
      MB_ICONHAND                  = 0x00000010
      # A question-mark icon appears in the message box. The question-mark message icon is no longer
      # recommended because it does not clearly represent a specific type of message and because the phrasing
      # of a message as a question could apply to any message type. In addition, users can confuse the message
      # symbol question mark with Help information. Therefore, do not use this question mark message symbol in
      # your message boxes. The system continues to support its inclusion only for backward compatibility.
      MB_ICONQUESTION              = 0x00000020
      # An exclamation-point icon appears in the message box.
      MB_ICONEXCLAMATION           = 0x00000030
      # An icon consisting of a lowercase letter i in a circle appears in the message box.
      MB_ICONASTERISK              = 0x00000040
      MB_USERICON                  = 0x00000080
      # An exclamation-point icon appears in the message box.
      MB_ICONWARNING               = MB_ICONEXCLAMATION
      # A stop-sign icon appears in the message box.
      MB_ICONERROR                 = MB_ICONHAND
      # An icon consisting of a lowercase letter i in a circle appears in the message box.
      MB_ICONINFORMATION           = MB_ICONASTERISK
      # A stop-sign icon appears in the message box.
      MB_ICONSTOP                  = MB_ICONHAND

      # To indicate the default button, specify one of the following values:

      # The first button is the default button.
      # MB_DEFBUTTON1 is the default unless MB_DEFBUTTON2, MB_DEFBUTTON3, or MB_DEFBUTTON4 is specified.
      MB_DEFBUTTON1                = 0x00000000
      # The second button is the default button.
      MB_DEFBUTTON2                = 0x00000100
      # The 3rd button is the default button.
      MB_DEFBUTTON3                = 0x00000200
      # The 4th button is the default button.
      MB_DEFBUTTON4                = 0x00000300

      # To indicate the modality of the dialog box, specify one of the following values:

      # The user must respond to the message box before continuing work in the window identified by the hWnd
      # parameter. However, the user can move to the windows of other threads and work in those windows.
      # Depending on the hierarchy of windows in the application, the user may be able to move to other
      # windows within the thread. All child windows of the parent of the message box are automatically 
      # disabled, but pop-up windows are not.
      # MB_APPLMODAL is the default if neither MB_SYSTEMMODAL nor MB_TASKMODAL is specified.
      MB_APPLMODAL                 = 0x00000000
      # Same as MB_APPLMODAL except that the message box has the WS_EX_TOPMOST style. Use system-modal message
      # boxes to notify the user of serious, potentially damaging errors that require immediate attention (for
      # example, running out of memory). This flag has no effect on the user's ability to interact with
      # windows other than those associated with hWnd.
      MB_SYSTEMMODAL               = 0x00001000
      # Same as MB_APPLMODAL except that all the top-level windows belonging to the current thread are
      # disabled if the hWnd parameter is NULL. Use this flag when the calling application or library does not
      # have a window handle available but still needs to prevent input to other windows in the calling thread
      # without suspending other threads.
      MB_TASKMODAL                 = 0x00002000

      # To specify other options, use one or more of the following values.

      # Adds a Help button to the message box. When the user clicks the Help button or presses F1,
      # the system sends a WM_HELP message to the owner.
      MB_HELP                      = 0x00004000
      MB_NOFOCUS                   = 0x00008000
      # The message box becomes the foreground window. Internally, the system calls the SetForegroundWindow
      # function for the message box.
      MB_SETFOREGROUND             = 0x00010000
      # Windows NT/2000/XP: Same as desktop of the interactive window station. For more information, see
      # Window Stations.
      # Windows NT 4.0 and earlier: If the current input desktop is not the default desktop, MessageBox fails.
      # Windows 2000/XP: If the current input desktop is not the default desktop, MessageBox does not return
      # until the user switches to the default desktop.
      # Windows 95/98/Me: This flag has no effect.
      MB_DEFAULT_DESKTOP_ONLY      = 0x00020000
      # The message box is created with the WS_EX_TOPMOST window style.
      MB_TOPMOST                   = 0x00040000
      # The text is right-justified.
      MB_RIGHT                     = 0x00080000
      # Displays message and caption text using right-to-left reading order on Hebrew and Arabic systems.
      MB_RTLREADING                = 0x00100000
      # Assume Win2k or later
      # Windows NT/2000/XP: The caller is a service notifying the user of an event. The function displays a
      # message box on the current active desktop, even if there is no user logged on to the computer.
      # Terminal Services: If the calling thread has an impersonation token, the function directs the message
      # box to the session specified in the impersonation token.
      # If this flag is set, the hWnd parameter must be NULL. This is so that the message box can appear on a
      # desktop other than the desktop corresponding to the hWnd.
      # For more information on the changes between Microsoft Windows NT 3.51 and Windows NT 4.0, see Remarks.
      # For information on security considerations in regard to using this flag, see Interactive Services.
      MB_SERVICE_NOTIFICATION      = 0x00200000
      # Windows NT/2000/XP: This value corresponds to the value defined for MB_SERVICE_NOTIFICATION for
      # Windows NT version 3.51.
      MB_SERVICE_NOTIFICATION_NT3X = 0x00040000
      MB_TYPEMASK                  = 0x0000000F
      MB_ICONMASK                  = 0x000000F0
      MB_DEFMASK                   = 0x00000F00
      MB_MODEMASK                  = 0x00003000
      MB_MISCMASK                  = 0x0000C000

      # IDs of standard dialog controls and items:

      # These are returned as user input from modal dialog:
      IDOK        = 0x01  # The OK button was selected.
      IDCANCEL    = 0x02  # The Cancel button was selected.
      IDABORT     = 0x03  # The Abort button was selected.
      IDRETRY     = 0x04  # The Retry button was selected.
      IDIGNORE    = 0x05  # The Ignore button was selected.
      IDYES       = 0x06  # The YES button was selected.
      IDNO        = 0x07  # The NO button was selected.
      IDTRYAGAIN  = 0x10  # The Try Again button was selected.
      IDCONTINUE  = 0x11  # The Continue button was selected.

      # These are not returned, their presence helps to programmatically identify type of present dialog:
      ErrorIcon = 0x14  # ID of Error Icon (this dialog informs about some Error)

      ##
      # DialogProc is an application-defined callback function used with the CreateDialog and DialogBox
      # families of functions. It processes messages sent to a modal or modeless dialog box. The DLGPROC
      # type defines a pointer to this callback function. DialogProc is a placeholder for the
      # application-defined function name.
      #
      # [*Syntax*] INT_PTR CALLBACK DialogProc( HWND hwndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam );
      #
      # hwndDlg:: [in] Handle to the dialog box.
      # uMsg:: [in] Specifies the message.
      # wParam:: [in] Specifies additional message-specific information.
      # lParam:: [in] Specifies additional message-specific information.
      #
      # *Returns*:: Typically, the dialog box procedure should return TRUE if it processed the message, and
      #             FALSE if it did not. If the dialog box procedure returns FALSE, the dialog manager
      #             performs the default dialog operation in response to the message.
      # If the dialog box procedure processes a message that requires a specific return value, the dialog box
      # procedure should set the desired return value by calling SetWindowLong(hwndDlg, DWL_MSGRESULT,
      # lResult) immediately before returning TRUE. Note that you must call SetWindowLong immediately before
      # returning TRUE; doing so earlier may result in the DWL_MSGRESULT value being overwritten by a nested
      # dialog box message.
      # The following messages are exceptions to the general rules stated above. Consult the documentation for
      # the specific message for details on the semantics of the return value.
      # WM_CHARTOITEM
      # WM_COMPAREITEM
      # WM_CTLCOLORBTN
      # WM_CTLCOLORDLG
      # WM_CTLCOLOREDIT
      # WM_CTLCOLORLISTBOX
      # WM_CTLCOLORSCROLLBAR
      # WM_CTLCOLORSTATIC
      # WM_INITDIALOG
      # WM_QUERYDRAGICON
      # WM_VKEYTOITEM
      # ---
      # *Remarks*:
      # You should use the dialog box procedure only if you use the dialog box class for the dialog box. This
      # is the default class and is used when no explicit class is specified in the dialog box template.
      # Although the dialog box procedure is similar to a window procedure, it must not call the DefWindowProc
      # function to process unwanted messages. Unwanted messages are processed internally by the dialog box
      # window procedure.
      # ---
      # *See* *Also*:
      # Dialog Boxes Overview, CreateDialog, CreateDialogIndirect, CreateDialogIndirectParam,
      # CreateDialogParam, DefWindowProc, DialogBox, DialogBoxIndirect, DialogBoxIndirectParam,
      # DialogBoxParam, SetFocus, WM_INITDIALOG
      #
      callback :DialogProc, [:HWND, :UINT, :WPARAM, :LPARAM], :int

      ##
      # The GetDlgItem function retrieves a handle to a control in the specified dialog box.
      #
      # [*Syntax*]  HWND GetDlgItem( HWND hDlg, int nIDDlgItem );
      #
      # hDlg:: <in> Handle to the dialog box that contains the control.
      # nIDDlgItem:: <in> Specifies the identifier of the control to be retrieved.
      # *Returns*:: If the function succeeds, the return value is the window handle of the specified control.
      #             If the function fails, the return value is NULL, indicating an invalid dialog box handle
      #             or a nonexistent control. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # You can use the GetDlgItem function with any parent-child window pair, not just with dialog boxes.
      # As long as the hDlg parameter specifies a parent window and the child window has a unique identifier
      # (as specified by the hMenu parameter in the CreateWindow or CreateWindowEx function that created the 
      # child window), GetDlgItem returns a valid handle to the child window.
      # ---
      # <b>Enhanced (snake_case) API: returns nil if function fails</b>
      #
      # :call-seq:
      #   control_handle = [get_]dlg_item( dialog_handle, control_id )
      #
      function :GetDlgItem, [:ulong, :int], :ulong, zeronil: true

      ##
      # MessageBox Function
      # --------------------------------------------------------------------------------
      # The MessageBox function creates, displays, and operates a message box. The message box contains an
      # application-defined message and title, along with any combination of predefined icons and push
      # buttons.
      #
      # [*Syntax*] int MessageBox( HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType );
      #
      # hWnd:: [in] Handle to the owner window of the message box to be created. If this parameter is NULL,
      #        the message box has no owner window.
      # lpText:: [in] Pointer to a null-terminated string that contains the message to be displayed.
      # lpCaption:: [in] Pointer to a null-terminated string that contains the dialog box title. If this
      #             parameter is NULL, the default title Error is used.
      # uType:: [in] Specifies the contents and behavior of the dialog box. This parameter can be a
      #         combination of flags from the following groups of flags.
      #         To indicate the buttons displayed in the message box, specify one of the following values.
      #         MB_ABORTRETRYIGNORE, MB_CANCELTRYCONTINUE, MB_HELP, MB_OK, MB_OKCANCEL, MB_RETRYCANCEL
      #         MB_YESNO, MB_YESNOCANCEL
      #         To display an icon in the message box, specify one of the following values.
      #         MB_ICONEXCLAMATION, MB_ICONWARNING, MB_ICONINFORMATION, MB_ICONASTERISK, MB_ICONQUESTION
      #         MB_ICONSTOP, MB_ICONERROR, MB_ICONHAND
      #         To indicate the default button, specify one of the following values.
      #         MB_DEFBUTTON1, MB_DEFBUTTON2, MB_DEFBUTTON3, MB_DEFBUTTON4
      #         To indicate the modality of the dialog box, specify one of the following values.
      #         MB_APPLMODAL, MB_SYSTEMMODAL, MB_TASKMODAL
      #         To specify other options, use one or more of the following values.
      #         MB_DEFAULT_DESKTOP_ONLY, MB_RIGHT, MB_RTLREADING, MB_SETFOREGROUND, MB_TOPMOST
      #         MB_SERVICE_NOTIFICATION, MB_SERVICE_NOTIFICATION_NT3X
      #         For more information on the changes between Windows NT 3.51 and Windows NT 4.0, see Remarks.
      #
      # *Returns*:: If a message box has a Cancel button, the function returns the IDCANCEL value if either
      #             the ESC key is pressed or the Cancel button is selected. If the message box has no Cancel
      #             button, pressing ESC has no effect.
      # If the function fails, the return value is zero. To get extended error information, call GetLastError.
      # If the function succeeds, the return value is one of the following menu-item values.
      # IDABORT:: Abort button was selected.
      # IDCANCEL:: Cancel button was selected.
      # IDCONTINUE:: Continue button was selected.
      # IDIGNORE:: Ignore button was selected.
      # IDNO:: No button was selected.
      # IDOK:: OK button was selected.
      # IDRETRY:: Retry button was selected.
      # IDTRYAGAIN:: Try Again button was selected.
      # IDYES:: Yes button was selected.
      # ---
      # *Remarks*:
      # Adding two right-to-left marks (RLMs), represented by Unicode formatting character U+200F, in the
      # beginning of a MessageBox display string is interpreted by the Win32 MessageBox rendering engine so as
      # to cause the reading order of the MessageBox to be rendered as right-to-left (RTL).
      # When you use a system-modal message box to indicate that the system is low on memory, the strings
      # pointed to by the lpText and lpCaption parameters should not be taken from a resource file because an
      # attempt to load the resource may fail.
      # If you create a message box while a dialog box is present, use a handle to the dialog box as the hWnd
      # parameter. The hWnd parameter should not identify a child window, such as a control in a dialog box.
      # Windows 95/98/Me: The system can support a maximum of 16,364 window handles.
      # Windows NT/2000/XP: The value of MB_SERVICE_NOTIFICATION changed starting with Windows NT 4.0. Windows
      # NT 4.0 provides backward compatibility for preexisting services by mapping the old value to the new
      # value in the implementation of MessageBox. This mapping is done only for executables that have a
      # version number earlier than 4.0, as set by the linker.
      # To build a service that uses MB_SERVICE_NOTIFICATION and can run on both Microsoft Windows NT 3.x and
      # Windows NT 4.0, you can do one of the following.
      # At link-time, specify a version number less than 4.0.
      # At link-time, specify version 4.0. At run-time, use the GetVersionEx function to check the system
      # version. Then, when running on Windows NT 3.x, use MB_SERVICE_NOTIFICATION_NT3X; and on Windows NT
      # 4.0, use MB_SERVICE_NOTIFICATION.
      # Windows 95/98/Me: Even though MessageBoxW exists, it is supported by the Microsoft Layer for Unicode
      # on Windows 95/98/Me Systems to give more consistent behavior across all Windows operating systems.
      # ---
      # *See* *Also*:
      # Dialog Boxes Overview, FlashWindow, MessageBeep, MessageBoxEx, MessageBoxIndirect, SetForegroundWindow
      # ---
      # <b>Enhanced (snake_case) API: accepts text and caption, uType is optional. Returns nil if function fails</b>
      #
      # :call-seq:
      #  selected_item = message_box(owner_handle, text, caption, type)
      #
      function :MessageBox, [:HWND, :LPCTSTR, :LPCTSTR, :UINT], :int, zeronil: true,
               &->(api, handle, text, caption, type=MB_OK) {
                  text_pointer = FFI::MemoryPointer.from_string(text)
                  caption_pointer = FFI::MemoryPointer.from_string(caption)
                  api.call handle, text_pointer, caption_pointer, type }

      # Untested:

      ##
      function :CreateDialogIndirectParam, ['L', 'P', 'L', :DialogProc, 'L'], 'L'
      ##
      function :CreateDialogParam, ['L', 'P', 'L', :DialogProc, 'L'], 'L'
      ##
      function :DialogBoxIndirectParam, ['L', 'P', 'L', :DialogProc, 'L'], 'P'
      ##
      function :DialogBoxParam, ['L', 'P', 'L', :DialogProc, 'L'], 'P'
      ##
      function :EndDialog, 'LP', 'B'
      ##
      function :GetDialogBaseUnits, 'V', 'L'
      ##
      function :GetDlgCtrlID, 'L', 'I'
      ##
      function :GetDlgItemText, 'LIPI', 'I'
      ##
      function :GetNextDlgGroupItem, 'LLI', 'L'
      ##
      function :GetNextDlgTabItem, 'LLI', 'L'
      ##
      function :IsDialogMessage, 'LP', 'B'
      ##
      function :MapDialogRect, 'LP', 'B'
      ##
      function :MessageBoxEx, 'LPPII', 'I'
      ##
      function :MessageBoxIndirect, 'P', 'I'
      ##
      function :SendDlgItemMessage, 'LIILL', 'L'
      ##
      function :SetDlgItemInt, 'LIII', 'L'
      ##
      function :SetDlgItemText, 'LIP', 'B'

      # Macros from WinUser.h

      def CreateDialog(hInstance, lpName, hParent, lpDialogFunc)
         CreateDialogParam(hInstance, lpName, hParent, lpDialogFunc, 0)
      end

      def CreateDialogIndirect(hInst, lpTemp, hPar, lpDialFunc)
         CreateDialogIndirectParam(hInst, lpTemp, hPar, lpDialFunc, 0)
      end

      def DialogBox(hInstance, lpTemp, hParent, lpDialogFunc)
         DialogBoxParam(hInstance, lpTemp, hParent, lpDialogFunc, 0)
      end

      def DialogBoxIndirect(hInst, lpTemp, hParent, lpDialogFunc)
         DialogBoxParamIndirect(hInst, lpTemp, hParent, lpDialogFunc, 0)
      end
    end
  end
end


