require 'win/library'

module Win
  module GUI
    # Contains constants and Win32API functions related to inter-Window messaging
    #
    module Message
      include Win::Library

      # Window messages:

      WM_NULL           = 0x0000
      WA_INACTIVE       = 0x0000
      WM_CREATE         = 0x0001
      WA_ACTIVE         = 0x0001
      WM_DESTROY        = 0x0002
      WA_CLICKACTIVE    = 0x0002
      WM_MOVE           = 0x0003
      WM_SIZE           = 0x0005
      WM_ACTIVATE       = 0x0006
      WM_SETFOCUS       = 0x0007
      WM_KILLFOCUS      = 0x0008
      WM_ENABLE         = 0x000A
      WM_SETREDRAW      = 0x000B
      WM_SETTEXT        = 0x000C
      # Windows Message Get Text
      WM_GETTEXT        = 0x000D
      WM_GETTEXTLENGTH  = 0x000E
      WM_PAINT          = 0x000F
      WM_CLOSE          = 0x0010
      WM_QUERYENDSESSION= 0x0011
      WM_QUIT           = 0x0012
      WM_QUERYOPEN      = 0x0013
      WM_ERASEBKGND     = 0x0014
      WM_SYSCOLORCHANGE = 0x0015
      WM_ENDSESSION     = 0x0016
      WM_SHOWWINDOW     = 0x0018
      WM_WININICHANGE   = 0x001A
      WM_SETTINGCHANGE  = WM_WININICHANGE
      WM_DEVMODECHANGE  = 0x001B
      WM_ACTIVATEAPP    = 0x001C
      WM_FONTCHANGE     = 0x001D
      WM_TIMECHANGE     = 0x001E
      WM_CANCELMODE     = 0x001F
      WM_SETCURSOR      = 0x0020
      WM_MOUSEACTIVATE  = 0x0021
      WM_CHILDACTIVATE  = 0x0022
      WM_QUEUESYNC      = 0x0023
      WM_GETMINMAXINFO  = 0x0024
      WM_PAINTICON      = 0x0026
      WM_ICONERASEBKGND = 0x0027
      WM_NEXTDLGCTL     = 0x0028
      WM_SPOOLERSTATUS  = 0x002A
      WM_DRAWITEM       = 0x002B
      WM_MEASUREITEM    = 0x002C
      WM_DELETEITEM     = 0x002D
      WM_VKEYTOITEM     = 0x002E
      WM_CHARTOITEM     = 0x002F
      WM_SETFONT        = 0x0030
      WM_GETFONT        = 0x0031
      WM_SETHOTKEY      = 0x0032
      WM_GETHOTKEY      = 0x0033
      WM_QUERYDRAGICON  = 0x0037
      WM_COMPAREITEM    = 0x0039
      WM_COMPACTING     = 0x0041
      WM_COMMNOTIFY                 = 0x0044  # no longer supported
      WM_WINDOWPOSCHANGING          = 0x0046
      WM_WINDOWPOSCHANGED           = 0x0047
      WM_POWER                      = 0x0048
      WM_COPYDATA                   = 0x004A
      WM_CANCELJOURNAL              = 0x004B
      WM_NOTIFY                     = 0x004E
      WM_INPUTLANGCHANGEREQUEST     = 0x0050
      WM_INPUTLANGCHANGE            = 0x0051
      WM_TCARD                      = 0x0052
      WM_HELP                       = 0x0053
      WM_USERCHANGED                = 0x0054
      WM_NOTIFYFORMAT               = 0x0055
      WM_CONTEXTMENU                = 0x007B
      WM_STYLECHANGING              = 0x007C
      WM_STYLECHANGED               = 0x007D
      WM_DISPLAYCHANGE              = 0x007E
      WM_GETICON                    = 0x007F
      WM_SETICON                    = 0x0080
      WM_NCCREATE                   = 0x0081
      WM_NCDESTROY                  = 0x0082
      WM_NCCALCSIZE                 = 0x0083
      WM_NCHITTEST                  = 0x0084
      WM_NCPAINT                    = 0x0085
      WM_NCACTIVATE                 = 0x0086
      WM_GETDLGCODE                 = 0x0087
      WM_SYNCPAINT                  = 0x0088
      WM_NCMOUSEMOVE                = 0x00A0
      WM_NCLBUTTONDOWN              = 0x00A1
      WM_NCLBUTTONUP                = 0x00A2
      WM_NCLBUTTONDBLCLK            = 0x00A3
      WM_NCRBUTTONDOWN              = 0x00A4
      WM_NCRBUTTONUP                = 0x00A5
      WM_NCRBUTTONDBLCLK            = 0x00A6
      WM_NCMBUTTONDOWN              = 0x00A7
      WM_NCMBUTTONUP                = 0x00A8
      WM_NCMBUTTONDBLCLK            = 0x00A9
      WM_NCXBUTTONDOWN              = 0x00AB
      WM_NCXBUTTONUP                = 0x00AC
      WM_NCXBUTTONDBLCLK            = 0x00AD
      WM_INPUT                      = 0x00FF
      WM_KEYFIRST                   = 0x0100
      WM_KEYDOWN                    = 0x0100
      WM_KEYUP                      = 0x0101
      WM_CHAR                       = 0x0102
      WM_DEADCHAR                   = 0x0103
      WM_SYSKEYDOWN                 = 0x0104
      WM_SYSKEYUP                   = 0x0105
      WM_SYSCHAR                    = 0x0106
      WM_SYSDEADCHAR                = 0x0107
      WM_UNICHAR                    = 0x0109
      WM_IME_STARTCOMPOSITION       = 0x010D
      WM_IME_ENDCOMPOSITION         = 0x010E
      WM_IME_COMPOSITION            = 0x010F
      WM_IME_KEYLAST                = 0x010F
      WM_INITDIALOG                 = 0x0110
      WM_COMMAND                    = 0x0111
      # Windows Message Sys Command
      WM_SYSCOMMAND                 = 0x0112
      WM_TIMER                      = 0x0113
      WM_HSCROLL                    = 0x0114
      WM_VSCROLL                    = 0x0115
      WM_INITMENU                   = 0x0116
      WM_INITMENUPOPUP              = 0x0117
      WM_MENUSELECT                 = 0x011F
      WM_MENUCHAR                   = 0x0120
      WM_ENTERIDLE                  = 0x0121
      WM_MENURBUTTONUP              = 0x0122
      WM_MENUDRAG                   = 0x0123
      WM_MENUGETOBJECT              = 0x0124
      WM_UNINITMENUPOPUP            = 0x0125
      WM_MENUCOMMAND                = 0x0126
      WM_CHANGEUISTATE              = 0x0127
      WM_UPDATEUISTATE              = 0x0128
      WM_QUERYUISTATE               = 0x0129
      WM_CTLCOLORMSGBOX             = 0x0132
      WM_CTLCOLOREDIT               = 0x0133
      WM_CTLCOLORLISTBOX            = 0x0134
      WM_CTLCOLORBTN                = 0x0135
      WM_CTLCOLORDLG                = 0x0136
      WM_CTLCOLORSCROLLBAR          = 0x0137
      WM_CTLCOLORSTATIC             = 0x0138
      WM_MOUSEFIRST                 = 0x0200
      WM_MOUSEMOVE                  = 0x0200
      WM_LBUTTONDOWN                = 0x0201
      WM_LBUTTONUP                  = 0x0202
      WM_LBUTTONDBLCLK              = 0x0203
      WM_RBUTTONDOWN                = 0x0204
      WM_RBUTTONUP                  = 0x0205
      WM_RBUTTONDBLCLK              = 0x0206
      WM_MBUTTONDOWN                = 0x0207
      WM_MBUTTONUP                  = 0x0208
      WM_MBUTTONDBLCLK              = 0x0209
      WM_MOUSEWHEEL                 = 0x020A
      WM_XBUTTONDOWN                = 0x020B
      WM_XBUTTONUP                  = 0x020C
      WM_XBUTTONDBLCLK              = 0x020D
      WM_MOUSELAST                  = 0x020D # Win2k or later
      WM_PARENTNOTIFY               = 0x0210
      WM_ENTERMENULOOP              = 0x0211
      WM_EXITMENULOOP               = 0x0212
      WM_NEXTMENU                   = 0x0213
      WM_SIZING                     = 0x0214
      WM_CAPTURECHANGED             = 0x0215
      WM_MOVING                     = 0x0216
      WM_POWERBROADCAST             = 0x0218
      WM_DEVICECHANGE               = 0x0219
      WM_MDICREATE                  = 0x0220
      WM_MDIDESTROY                 = 0x0221
      WM_MDIACTIVATE                = 0x0222
      WM_MDIRESTORE                 = 0x0223
      WM_MDINEXT                    = 0x0224
      WM_MDIMAXIMIZE                = 0x0225
      WM_MDITILE                    = 0x0226
      WM_MDICASCADE                 = 0x0227
      WM_MDIICONARRANGE             = 0x0228
      WM_MDIGETACTIVE               = 0x0229
      WM_MDISETMENU                 = 0x0230
      WM_ENTERSIZEMOVE              = 0x0231
      WM_EXITSIZEMOVE               = 0x0232
      WM_DROPFILES                  = 0x0233
      WM_MDIREFRESHMENU             = 0x0234
      WM_IME_SETCONTEXT             = 0x0281
      WM_IME_NOTIFY                 = 0x0282
      WM_IME_CONTROL                = 0x0283
      WM_IME_COMPOSITIONFULL        = 0x0284
      WM_IME_SELECT                 = 0x0285
      WM_IME_CHAR                   = 0x0286
      WM_IME_REQUEST                = 0x0288
      WM_IME_KEYDOWN                = 0x0290
      WM_IME_KEYUP                  = 0x0291
      WM_MOUSEHOVER                 = 0x02A1
      WM_MOUSELEAVE                 = 0x02A3
      WM_NCMOUSEHOVER               = 0x02A0
      WM_NCMOUSELEAVE               = 0x02A2
      WM_WTSSESSION_CHANGE          = 0x02B1
      WM_TABLET_FIRST               = 0x02c0
      WM_TABLET_LAST                = 0x02df
      WM_CUT                        = 0x0300
      WM_COPY                       = 0x0301
      WM_PASTE                      = 0x0302
      WM_CLEAR                      = 0x0303
      WM_UNDO                       = 0x0304
      WM_RENDERFORMAT               = 0x0305
      WM_RENDERALLFORMATS           = 0x0306
      WM_DESTROYCLIPBOARD           = 0x0307
      WM_DRAWCLIPBOARD              = 0x0308
      WM_PAINTCLIPBOARD             = 0x0309
      WM_VSCROLLCLIPBOARD           = 0x030A
      WM_SIZECLIPBOARD              = 0x030B
      WM_ASKCBFORMATNAME            = 0x030C
      WM_CHANGECBCHAIN              = 0x030D
      WM_HSCROLLCLIPBOARD           = 0x030E
      WM_QUERYNEWPALETTE            = 0x030F
      WM_PALETTEISCHANGING          = 0x0310
      WM_PALETTECHANGED             = 0x0311
      WM_HOTKEY                     = 0x0312
      WM_PRINT                      = 0x0317
      WM_PRINTCLIENT                = 0x0318
      WM_APPCOMMAND                 = 0x0319
      WM_THEMECHANGED               = 0x031A
      WM_HANDHELDFIRST              = 0x0358
      WM_HANDHELDLAST               = 0x035F
      WM_AFXFIRST                   = 0x0360
      WM_AFXLAST                    = 0x037F
      WM_PENWINFIRST                = 0x0380
      WM_PENWINLAST                 = 0x038F
      # User-specific (non-reserved) messages above this one (WM_USER+1, etc...)
      WM_USER                       = 0x0400
      # App-specific (non-reserved) messages above this one (WM_App+1, etc...)
      WM_APP                        = 0x8000

      # Sys Commands:

      #
      SC_SIZE         = 0xF000
      SC_MOVE         = 0xF010
      SC_MINIMIZE     = 0xF020
      SC_MAXIMIZE     = 0xF030
      SC_NEXTWINDOW   = 0xF040
      SC_PREVWINDOW   = 0xF050
      # Sys Command Close
      SC_CLOSE        = 0xF060
      SC_VSCROLL      = 0xF070
      SC_HSCROLL      = 0xF080
      SC_MOUSEMENU    = 0xF090
      SC_KEYMENU      = 0xF100
      SC_ARRANGE      = 0xF110
      SC_RESTORE      = 0xF120
      SC_TASKLIST     = 0xF130
      SC_SCREENSAVE   = 0xF140
      SC_HOTKEY       = 0xF150
      SC_DEFAULT      = 0xF160
      SC_MONITORPOWER = 0xF170
      SC_CONTEXTHELP  = 0xF180

      ##
      function :BroadcastSystemMessage, 'LPIIL', 'L'

      ##
      function :DefWindowProc, 'LLLL', 'L'

      ##
      function :DispatchMessage, 'P', 'L'

      ##
      function :GetInputState, 'V', 'B'

      ##
      function :GetMessage, 'PLII', 'B'

      ##
      function :GetMessageExtraInfo, 'V', 'L'

      ##
      function :GetMessagePos, 'V', 'L'

      ##
      function :GetMessageTime, 'V', 'L'

      ##
      function :GetQueueStatus, 'I', 'L'

      ##
      function :InSendMessage, 'V', 'B'

      ##
      function :InSendMessageEx, 'L', 'L'

      ##
      function :PeekMessage, 'PLIII', 'B'

      ##
      function :PostQuitMessage, 'I', 'V'

      ##
      function :PostThreadMessage, 'LILL', 'B'

      ##
      function :RegisterWindowMessage, 'P', 'I'

      ##
      function :ReplyMessage, 'L', 'B'

      ##
      function :SendMessageTimeout, 'LILLIIP', 'L'

      ##
      function :SendNotifyMessage, 'LILLIIP', 'L'

      ##
      function :SetMessageExtraInfo, 'L', 'L'

      ##
      function :TranslateMessage, 'P', 'B'

      ##
      function :WaitMessage, 'V', 'B'

      ##
      # The SendAsyncProc function is an application-defined callback function used with the SendMessageCallback
      # function. The system passes the message to the callback function after passing the message to the
      # destination window procedure. SendAsyncProc is a placeholder for the application-defined function name.
      #
      # [*Syntax*] VOID SendAsyncProc( HWND hwnd, UINT uMsg, ULONG_PTR dwData, LRESULT lResult );
      #
      # hwnd:: [in] Handle to the window whose window procedure received the message. If SendMessageCallback
      #        function was called with its hwnd parameter set to HWND_BROADCAST, the system calls the
      #        SendAsyncProc function once for each top-level window.
      # uMsg:: [in] Specifies the message.
      # dwData:: [in] Specifies an application-defined value sent from the SendMessageCallback function.
      # lResult:: [in] Specifies the result of the message processing. This value depends on the message.
      #
      # :call-seq:
      #  SendAsyncProc callback block: {|handle, msg, data, l_result| your callbackcode }
      #
      callback :SendAsyncProc, [:long, :uint, :ulong, :ulong, :long], :void

      ##
      #  The SendMessageCallback function sends the specified message to a window or windows. It calls the window
      #  procedure for the specified window and returns immediately. After the window procedure processes the message,
      #  the system calls the specified callback function, passing the result of the message processing and an
      #  application-defined value to the callback function.
      #
      #  [*Syntax*] BOOL SendMessageCallback( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam,
      #             SENDASYNCPROC lpCallBack, ULONG_PTR dwData);
      #
      #  hWnd:: [in] Handle to the window whose window procedure will receive the message. If this parameter is
      #         HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or invisible
      #         unowned windows, overlapped windows, and pop-up windows; but the message is not sent to child windows.
      #  Msg:: [in] Specifies the message to be sent.
      #  wParam:: [in] Specifies additional message-specific information.
      #  lParam:: [in] Specifies additional message-specific information.
      #  lpCallBack:: [in] Pointer to a callback function that the system calls after the window procedure processes
      #               the message. For more information, see SendAsyncProc. If hWnd is HWND_BROADCAST, the system calls the
      #               SendAsyncProc callback function once for each top-level window.
      #  dwData:: [in] Specifies an application-defined value to be sent to the callback function pointed to by
      #           the lpCallBack parameter.
      #  *Returns*:: Nonzero if the function succeeds, zero if it fails. For extended error info, call GetLastError.
      #  ---
      #  *Remarks*:
      #  - If you send a message in the range below WM_USER to the asynchronous message functions (PostMessage,
      #    SendNotifyMessage, and SendMessageCallback), its message parameters cannot include pointers. Otherwise,
      #    the operation will fail. The functions will return before the receiving thread has had a chance
      #    to process the message and the sender will free the memory before it is used.
      #  - Applications that need to communicate using HWND_BROADCAST should use the RegisterWindowMessage function
      #    to obtain a unique message for inter-application communication.
      #  - The system only does marshalling for system messages (those in the range 0 to (WM_USER-1)). To send
      #    messages (>= WM_USER) to another process, you must do custom marshalling.
      #  - The callback function is called only when the thread that called SendMessageCallback also calls GetMessage,
      #    PeekMessage, or WaitMessage.
      #
      # :call-seq:
      #  success = send_message_callback(handle, msg, w_param, l_param, data)
      #            {|handle, msg, data, l_result| callback code }
      #
      function :SendMessageCallback, [:long, :uint, :uint, :long, :SendAsyncProc, :ulong], :int, boolean: true

      ##
      # The PostMessage function places (posts) a message in the message queue associated with the thread that
      # created the specified window and returns without waiting for the thread to process the message.
      # To post a message in the message queue associate with a thread, use the PostThreadMessage function.
      #
      # [*Syntax*] BOOL PostMessage( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
      #
      # hWnd::   [in] Handle to the window whose window procedure will receive the message. If this parameter is
      #          HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or
      #          invisible unowned windows, overlapped windows, and pop-up windows; but the message is not posted to
      #          child windows. If it is NULL, the function behaves like a call to PostThreadMessage()
      #          with the dwThreadId parameter set to the identifier of the current thread.
      # Msg:: [in] Specifies the message to be posted.
      # wParam:: [in] Specifies additional message-specific information.
      # lParam:: [in] Specifies additional message-specific information.
      #
      # *Returns*:: Nonzero if the function succeeds, zero if it fails. For extended error info, call GetLastError.
      # ---
      # *Remarks*:
      # - Microsoft Windows Vista and later. When a message is blocked by UIPI the last error, retrieved with
      #   GetLastError, is set to 5 (access denied). Messages in a message queue are retrieved by calls to the
      #   GetMessage or PeekMessage function.
      # - Applications that need to communicate using HWND_BROADCAST should use the RegisterWindowMessage function
      #   to obtain a unique message for inter-application communication.
      # - The system only does marshalling for system messages (those in the range 0 to (WM_USER-1)). To send other
      #   messages (those >= WM_USER) to another process, you must do custom marshalling.
      # - If you send a message in the range below WM_USER to the asynchronous message functions (PostMessage,
      #   SendNotifyMessage, and SendMessageCallback), its message parameters cannot include pointers. Otherwise,
      #   the operation will fail. The functions will return before the receiving thread has had a chance to
      #   process the message and the sender will free the memory before it is used. Use the PostQuitMessage
      #   instead of PostMessage to post WM_QUIT message.
      #
      #:call-seq:
      # success = post_message(handle, msg, w_param, l_param)
      #
      function :PostMessage, [:ulong, :uint, :long, :uint], :int, boolean: true

      ##
      # The SendMessage function sends the specified message to a window or windows. It calls the window procedure for
      # the specified window and does not return until the window procedure has processed the message.
      #
      # To send a message and return immediately, use the SendMessageCallback or SendNotifyMessage function. To post a
      # message to a thread's message queue and return immediately, use the PostMessage or PostThreadMessage function.
      #
      #
      # [*Syntax*] LRESULT SendMessage( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam );
      #
      # hWnd:: [in] Handle to the window whose window procedure will receive the message. If this parameter is
      #        HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or
      #        invisible unowned windows, overlapped windows, and pop-up windows; but the message is not sent to
      #        child windows.
      #        Microsoft Windows Vista and later. Message sending is subject to User Interface Privilege Isolation
      #        (UIPI). The thread of a process can send messages only to message queues of threads in processes of
      #        lesser or equal integrity level.
      # Msg:: [in] Specifies the message to be sent.
      # wParam:: [in] Specifies additional message-specific information.
      # lParam:: [in/out?] Specifies additional message-specific information.
      #
      # *Return*:: The return value specifies the result of the message processing; it depends on the message sent.
      # ---
      # *Remarks*:
      # - Microsoft Windows Vista and later. When a message is blocked by UIPI the last error, retrieved with
      #   GetLastError, is set to 5 (access denied).
      # - Applications that need to communicate using HWND_BROADCAST should use the RegisterWindowMessage function
      #   to obtain a unique message for inter-application communication.
      # - The system only does marshalling for system messages (those in the range 0 to (WM_USER-1)). To send other
      #   messages (those >= WM_USER) to another process, you must do custom marshalling.
      # - If the specified window was created by the calling thread, the window procedure is called immediately as
      #   a subroutine. If the specified window was created by a different thread, the system switches to that thread
      #   and calls the appropriate window procedure. Messages sent between threads are processed only when the
      #   receiving thread executes message retrieval code. The sending thread is blocked until the receiving thread
      #   processes the message. However, the sending thread will process incoming nonqueued messages while waiting
      #   for its message to be processed. To prevent this, use SendMessageTimeout with SMTO_BLOCK set. For more
      #   information on nonqueued messages, see Nonqueued Messages.
      #
      #:call-seq:
      # send_message(handle, msg, w_param, l_param)
      #
      function :SendMessage, [:ulong, :uint, :long, :pointer], :int   # LPARAM different from PostMessage!

    end
  end
end

