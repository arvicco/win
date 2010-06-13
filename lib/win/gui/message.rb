require 'win/library'

module Win
  module Gui
    #  Contains constants and Win32API functions related to Windows messaging
    #
    #  Below is a table of system-defined message prefixes:
    #
    #  *Prefix*:: *Message* *category* 
    #  ABM:: Application desktop toolbar
    #  BM:: Button control
    #  CB:: Combo box control
    #  CBEM:: Extended combo box control
    #  CDM:: Common dialog box
    #  DBT:: Device
    #  DL::  Drag list box
    #  DM::  Default push button control
    #  DTM:: Date and time picker control
    #  EM::  Edit control
    #  HDM:: Header control
    #  HKM:: Hot key control
    #  IPM:: IP address control
    #  LB::  List box control
    #  LVM:: List view control
    #  MCM:: Month calendar control
    #  PBM:: Progress bar
    #  PGM:: Pager control
    #  PSM:: Property sheet
    #  RB::  Rebar control
    #  SB::  Status bar window
    #  SBM:: Scroll bar control
    #  STM:: Static control
    #  TB::  Toolbar
    #  TBM:: Trackbar
    #  TCM:: Tab control
    #  TTM:: Tooltip control
    #  TVM:: Tree-view control
    #  UDM:: Up-down control
    #  WM::  General window

    module Message
      extend Win::Library

      # General window messages cover a wide range of information and requests, including messages for mouse and
      # keyboard input, menu and dialog box input, window creation and management, and Dynamic Data Exchange (DDE).
      # General window messages WM/WA:

      #
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

      # Sys Commands (wParam to use with WM_SYSCOMMAND message):

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

      # Queue status flags:

      #
      QS_KEY           = 0x0001
      QS_MOUSEMOVE     = 0x0002
      QS_MOUSEBUTTON   = 0x0004
      QS_MOUSE         = (QS_MOUSEMOVE | QS_MOUSEBUTTON)
      QS_POSTMESSAGE   = 0x0008
      QS_TIMER         = 0x0010
      QS_PAINT         = 0x0020
      QS_SENDMESSAGE   = 0x0040
      QS_HOTKEY        = 0x0080
      QS_ALLPOSTMESSAGE= 0x0100
      QS_RAWINPUT      = 0x0400
      QS_INPUT         = (QS_MOUSE | QS_KEY | QS_RAWINPUT)
      QS_ALLEVENTS     = (QS_INPUT | QS_POSTMESSAGE | QS_TIMER | QS_PAINT | QS_HOTKEY)
      QS_ALLINPUT      = (QS_ALLEVENTS | QS_SENDMESSAGE)
      QS_SMRESULT      = 0x8000

      # PeekMessage flags:

      # Messages are not removed from the queue after processing by PeekMessage (default)
      PM_NOREMOVE      = 0x0000
      # Messages are removed from the queue after processing by PeekMessage.
      PM_REMOVE        = 0x0001
      # You can optionally combine the value PM_NOYIELD with either PM_NOREMOVE or PM_REMOVE. This flag
      # prevents the system from releasing any thread that is waiting for the caller to go idle (see WaitForInputIdle).
      PM_NOYIELD       = 0x0002
      # By default, all message types are processed. To specify that only certain
      # message should be processed, specify one or more of the following values.
      # PM_QS_INPUT - Windows 98/Me, Windows 2000/XP: Process mouse and keyboard messages.
      PM_QS_INPUT      = (QS_INPUT << 16)
      # PM_QS_POSTMESSAGE - Win 98/Me/2000/XP: Process all posted messages, including timers and hotkeys.
      PM_QS_POSTMESSAGE= ((QS_POSTMESSAGE | QS_HOTKEY | QS_TIMER) << 16)
      # PM_QS_PAINT - Windows 98/Me, Windows 2000/XP: Process paint messages.
      PM_QS_PAINT      = (QS_PAINT << 16)
      # PM_QS_SENDMESSAGE - Windows 98/Me, Windows 2000/XP: Process all sent messages.
      PM_QS_SENDMESSAGE= (QS_SENDMESSAGE << 16)

      # The MSG structure contains message information from a thread's message queue.
      #
      #  typedef struct {
      #     HWND hwnd;
      #     UINT message;
      #     WPARAM wParam;
      #     LPARAM lParam;
      #     DWORD time;
      #     POINT pt;
      #  } MSG, *PMSG;
      #
      #  hwnd:: Handle to the window whose window procedure receives the message. NULL when the message is a thread message.
      #  message:: Message identifier. Applications can only use the low word; the high word is reserved by the system.
      #  wParam:: Additional info about the message. Exact meaning depends on the value of the message member.
      #  lParam:: Additional info about the message. Exact meaning depends on the value of the message member.
      #  time:: Specifies the time at which the message was posted.
      #  pt:: POINT structure - the cursor position, in screen coordinates, when the message was posted.
      #       (in my definition, it is changed to two longs: x, y - has the same effect, just avoid nested structs)
      class Msg < FFI::Struct
        layout :hwnd, :ulong,
               :message, :uint,
               :w_param, :long,
               :l_param, :pointer,
               :time, :uint32,
               :x, :long,
               :y, :long
      end

      ##
      # The SendAsyncProc function is an application-defined callback function used with the SendMessageCallback
      # function. The system passes the message to the callback function after passing the message to the
      # destination window procedure. SendAsyncProc is a placeholder for the application-defined function name.
      #
      # [*Syntax*] VOID SendAsyncProc( HWND hwnd, UINT uMsg, ULONG_PTR dwData, LRESULT lResult );
      #
      # hwnd:: <in> Handle to the window whose window procedure received the message. If SendMessageCallback
      #        function was called with its hwnd parameter set to HWND_BROADCAST, the system calls the
      #        SendAsyncProc function once for each top-level window.
      # uMsg:: <in> Specifies the message.
      # dwData:: <in> Specifies an application-defined value sent from the SendMessageCallback function.
      # lResult:: <in> Specifies the result of the message processing. This value depends on the message.
      #
      # :call-seq:
      #  SendAsyncProc callback block: {|handle, msg, data, l_result| your callback code }
      #
      callback :SendAsyncProc, [:HWND, :uint, :ulong, :long], :void

      ##
      #  The SendMessageCallback function sends the specified message to a window or windows. It calls the window
      #  procedure for the specified window and returns immediately. After the window procedure processes the message,
      #  the system calls the specified callback function, passing the result of the message processing and an
      #  application-defined value to the callback function.
      #
      #  [*Syntax*] BOOL SendMessageCallback( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam,
      #             SENDASYNCPROC lpCallBack, ULONG_PTR dwData);
      #
      #  hWnd:: <in> Handle to the window whose window procedure will receive the message. If this parameter is
      #         HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or
      #         invisible, unowned, overlapped and pop-up windows; but the message is not sent to child windows.
      #  Msg:: <in> Specifies the message to be sent.
      #  wParam:: <in> Specifies additional message-specific information.
      #  lParam:: <in> Specifies additional message-specific information.
      #  lpCallBack:: <in> Pointer to a callback function that the system calls after the window procedure processes
      #               the message. For more information, see SendAsyncProc. If hWnd is HWND_BROADCAST, the system calls
      #               SendAsyncProc callback function once for each top-level window.
      #  dwData:: <in> Specifies an application-defined value to be sent to the callback function pointed to by
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
      #  success = send_message_callback(handle, msg, w_param, l_param, [data=0])
      #            {|handle, msg, data, l_result| callback code }
      #
      function :SendMessageCallback, [:HWND, :uint, :uint, :pointer, :SendAsyncProc, :ulong], :int8, boolean: true,
               &->(api, handle, msg, w_param, l_param, data=0, &block){
               api.call(handle, msg, w_param, l_param, block, data)}


      ##
      # The PostMessage function places (posts) a message in the message queue associated with the thread that
      # created the specified window and returns without waiting for the thread to process the message.
      # To post a message in the message queue associate with a thread, use the PostThreadMessage function.
      #
      # [*Syntax*] BOOL PostMessage( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
      #
      # hWnd::   <in> Handle to the window whose window procedure will receive the message. If this parameter is
      #          HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or
      #          invisible unowned windows, overlapped windows, and pop-up windows; but the message is not posted to
      #          child windows. If it is NULL, the function behaves like a call to PostThreadMessage()
      #          with the dwThreadId parameter set to the identifier of the current thread.
      # Msg:: <in> Specifies the message to be posted.
      # wParam:: <in> Specifies additional message-specific information.
      # lParam:: <in> Specifies additional message-specific information (can be either :pointer or :long).
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
      # ---
      # <b>Enhanced (snake_case) API: accepts either long or pointer lParam</b>
      #
      #:call-seq:
      # success = post_message(handle, msg, w_param, l_param)
      #
      function :PostMessage, [:ulong, :uint, :uint, :pointer], :int,
               boolean: true, camel_name: :PostMessagePointer, snake_name: :post_message_pointer
      function :PostMessage, [:ulong, :uint, :uint, :long], :int,
               boolean: true, camel_name: :PostMessageLong, snake_name: :post_message_long

      def PostMessage(handle, msg, w_param, l_param)
        # Routes call depending on lParam type (:pointer or :long)
        case l_param
          when Integer
            PostMessageLong(handle, msg, w_param, l_param)
          else
            PostMessagePointer(handle, msg, w_param, l_param)
        end
      end

      def post_message(handle, msg, w_param, l_param, &block)
        if block
          block[PostMessage(handle, msg, w_param, l_param)]
        else
          PostMessage(handle, msg, w_param, l_param) != 0
        end
      end

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
      # hWnd:: <in> Handle to the window whose window procedure will receive the message. If this parameter is
      #        HWND_BROADCAST, the message is sent to all top-level windows in the system, including disabled or
      #        invisible unowned windows, overlapped windows, and pop-up windows; but the message is not sent to
      #        child windows.
      #        Microsoft Windows Vista and later. Message sending is subject to User Interface Privilege Isolation
      #        (UIPI). The thread of a process can send messages only to message queues of threads in processes of
      #        lesser or equal integrity level.
      # Msg:: <in> Specifies the message to be sent.
      # wParam:: <in> Specifies additional message-specific information.
      # lParam:: <in/out?> Specifies additional message-specific information.
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
      function :SendMessage, [:ulong, :uint, :uint, :pointer], :int   # LPARAM different from PostMessage!

      ##
      # :method: :SendMessageLong?
      # We need to attach another SendMessage function, this time accepting :long instead of :pointer lParam.
      # I do not know yet how to make FFI attach functions with same name, but different signature...
      #
      # function :SendMessage, [:ulong, :uint, :uint, :long], :int, alias: send_message_long?

      ##
      # The GetMessage function retrieves a message from the calling thread's message queue. The function
      # dispatches incoming sent messages until a posted message is available for retrieval.
      # Unlike GetMessage, the PeekMessage function does not wait for a message to be posted before returning.
      #
      # [*Syntax*]  BOOL GetMessage( LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax );
      #
      # lpMsg:: <out> Pointer to an MSG structure that receives message information from the thread's message
      #         queue.
      # hWnd:: <in> Handle to the window whose messages are to be retrieved. The window must belong to the current
      #        thread. If hWnd is NULL, GetMessage retrieves messages for any window that belongs to the current
      #        thread, and any messages on the current thread's message queue whose hwnd value is NULL (see the MSG
      #        structure). Therefore if hWnd is NULL, both window messages and thread messages are processed.
      #        If hWnd is -1, GetMessage retrieves only messages on the current thread's message queue whose hwnd
      #        value is NULL, that is, thread messages as posted by PostMessage (when the hWnd parameter is NULL) or
      #        PostThreadMessage.
      # wMsgFilterMin:: <in> Specifies the integer value of the lowest message value to be retrieved. Use WM_KEYFIRST
      #                 to specify the first keyboard message or WM_MOUSEFIRST to specify the first mouse message.
      #                 Windows XP: Use WM_INPUT here and in wMsgFilterMax to specify only the WM_INPUT messages.
      #                 If wMsgFilterMin and wMsgFilterMax are both zero, GetMessage returns all available messages
      #                 (that is, no range filtering is performed).
      # wMsgFilterMax:: <in> Specifies the integer value of the highest message value to be retrieved. Use
      #                 WM_KEYLAST to specify the last keyboard message or WM_MOUSELAST to specify the last
      #                 mouse message.
      #
      # *Returns*:: If the function retrieves a message other than WM_QUIT, the return value is nonzero.
      #             If the function retrieves the WM_QUIT message, the return value is zero.
      #             If there is an error, the return value is -1. For example, the function fails if hWnd is an invalid
      #             window handle or lpMsg is an invalid pointer. To get extended error information, call GetLastError.
      # *Warning*
      # Because the return value can be nonzero, zero, or -1, avoid code like this:
      #   while (GetMessage( lpMsg, hWnd, 0, 0)) ...
      # The possibility of a -1 return value means that such code can lead to fatal application errors.
      # Instead, use code like this:
      #   while( (bRet = GetMessage( msg, hWnd, 0, 0 )) != 0)
      #     if (bRet == -1)
      #       // handle the error and possibly exit
      #     else
      #       TranslateMessage(msg);
      #       DispatchMessage(msg);
      #     end
      #   end
      # ---
      # *Remarks*:
      # An application typically uses the return value to determine whether to end the main message loop and
      # exit the program.
      #
      # The GetMessage function retrieves messages associated with the window identified by the hWnd parameter
      # or any of its children, as specified by the IsChild function, and within the range of message values
      # given by the wMsgFilterMin and wMsgFilterMax parameters. Note that an application can only use the low
      # word in the wMsgFilterMin and wMsgFilterMax parameters; the high word is reserved for the system.
      # Note that GetMessage always retrieves WM_QUIT messages, no matter which values you specify for
      # wMsgFilterMin and wMsgFilterMax.
      #
      # During this call, the system delivers pending, nonqueued messages, that is, messages sent to windows
      # owned by the calling thread using the SendMessage, SendMessageCallback, SendMessageTimeout, or
      # SendNotifyMessage function. Then the first queued message that matches the specified filter is
      # retrieved. The system may also process internal events. If no filter is specified, messages are
      # processed in the following order:
      # 1. Sent messages
      # 2. Posted messages
      # 3. Input (hardware) messages and system internal events
      # 4. Sent messages (again)
      # 5. WM_PAINT messages
      # 6. WM_TIMER messages
      #
      # To retrieve input messages before posted messages, use the wMsgFilterMin and wMsgFilterMax parameters.
      # GetMessage does not remove WM_PAINT messages from the queue. The messages remain in the queue until
      # processed.
      #
      # Windows XP: If a top-level window stops responding to messages for more than several seconds, the 
      # system considers the window to be not responding and replaces it with a ghost window that has the same
      # z-order, location, size, and visual attributes. This allows the user to move it, resize it, or even
      # close the application. However, these are the only actions available because the application is
      # actually not responding. When in the debugger mode, the system does not generate a ghost window.
      # ---
      # <b>Enhanced (snake_case) API: makes all args optional, returns: *false* if WM_QUIT was posted,
      # *nil* if error was encountered, and retrieved Msg (FFI structure) in all other cases </b>
      #
      # :call-seq:
      #  msg = get_message([msg], [handle=0], [msg_filter_min=0], [msg_filter_max=0])
      #
      function :GetMessage, [:pointer, :HWND, :uint, :uint], :int8,
               &->(api, msg=Msg.new, handle=0, msg_filter_min=0, msg_filter_max=0){
               case api.call(msg, handle, msg_filter_min, msg_filter_max)
                 when 0
                   false
                 when -1
                   nil
                 else
                   msg
               end }
      # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

      ##
      # The PeekMessage function dispatches incoming sent messages, checks the thread message queue for a
      # posted message, and retrieves the message (if any exist).
      #
      # [*Syntax*]  BOOL PeekMessage( LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax,
      #                               UINT wRemoveMsg );
      #
      # lpMsg:: <out> Pointer to an MSG structure that receives message information.
      # hWnd:: <in> Handle to the window whose messages are to be retrieved. The window must belong to the current
      #        thread. If hWnd is NULL, PeekMessage retrieves messages for any window that belongs to the current
      #        thread, and any messages on the current thread's message queue whose hwnd value is NULL (see MSG).
      #        Therefore if hWnd is NULL, both window messages and thread messages are processed.
      #        If hWnd is -1, PeekMessage retrieves only messages on the current thread's message queue whose hwnd
      #        value is NULL, that is, thread messages as posted by PostMessage (when the hWnd parameter is NULL) or
      #        PostThreadMessage.
      # wMsgFilterMin:: <in> Specifies the value of the first message in the range of messages to be examined.
      #                 Use WM_KEYFIRST to specify the first keyboard message or WM_MOUSEFIRST to specify the
      #                 first mouse message. If wMsgFilterMin and wMsgFilterMax are both zero, PeekMessage returns all
      #                 available messages (that is, no range filtering is performed).
      # wMsgFilterMax:: <in> Specifies the value of the last message in the range of messages to be examined.
      #                 Use WM_KEYLAST to specify the last keyboard message or WM_MOUSELAST to specify the
      #                 last mouse message.
      # wRemoveMsg:: <in> Specifies how messages are handled. This parameter can be one of the following values.
      #              - PM_NOREMOVE - Messages are not removed from the queue after processing by PeekMessage.
      #              - PM_REMOVE - Messages are removed from the queue after processing by PeekMessage.
      #              You can optionally combine the value PM_NOYIELD with either PM_NOREMOVE or PM_REMOVE. This flag
      #              prevents the system from releasing any thread that is waiting for the caller to go idle (see
      #              WaitForInputIdle). By default, all message types are processed. To specify that only certain
      #              message should be processed, specify one or more of the following values.
      #              - PM_QS_INPUT - Windows 98/Me, Windows 2000/XP: Process mouse and keyboard messages.
      #              - PM_QS_PAINT - Windows 98/Me, Windows 2000/XP: Process paint messages.
      #              - PM_QS_POSTMESSAGE - Win 98/Me/2000/XP: Process all posted messages, including timers and hotkeys.
      #              - PM_QS_SENDMESSAGE - Windows 98/Me, Windows 2000/XP: Process all sent messages.
      #
      # *Returns*:: If a message is available, returns nonzero. If no messages are available, the return value is zero.
      # ---
      # *Remarks*:
      # PeekMessage retrieves messages associated with the window identified by the hWnd parameter or any of
      # its children as specified by the IsChild function, and within the range of message values given by the
      # wMsgFilterMin and wMsgFilterMax parameters. Note that an application can only use the low word in the
      # wMsgFilterMin and wMsgFilterMax parameters; the high word is reserved for the system.
      #
      # Note that PeekMessage always retrieves WM_QUIT messages, no matter which values you specify for
      # wMsgFilterMin and wMsgFilterMax.
      #
      # During this call, the system delivers pending, nonqueued messages, that is, messages sent to windows
      # owned by the calling thread using the SendMessage, SendMessageCallback, SendMessageTimeout, or
      # SendNotifyMessage function. Then the first queued message that matches the specified filter is
      # retrieved. The system may also process internal events. If no filter is specified, messages are
      # processed in the following order:
      # 1. Sent messages
      # 2. Posted messages
      # 3. Input (hardware) messages and system internal events
      # 4. Sent messages (again)
      # 5. WM_PAINT messages
      # 6. WM_TIMER messages
      #
      # To retrieve input messages before posted messages, use the wMsgFilterMin and wMsgFilterMax parameters.
      #
      # The PeekMessage function normally does not remove WM_PAINT messages from the queue. WM_PAINT messages
      # remain in the queue until they are processed. However, if a WM_PAINT message has a NULL update region,
      # PeekMessage does remove it from the queue.
      #
      # Windows XP: If a top-level window stops responding to messages for more than several seconds, the
      # system considers the window to be not responding and replaces it with a ghost window that has the same
      # z-order, location, size, and visual attributes. This allows the user to move it, resize it, or even
      # close the application. However, these are the only actions available because the application is
      # actually not responding. When an application is being debugged, the system does not generate a ghost
      # window.
      # ---
      # <b>Enhanced (snake_case) API: makes all args optional, returns *nil* if no message in queue,
      # returns retrieved Msg (FFI structure) if there is message in queue</b>
      #
      # :call-seq:
      #  msg = peek_message([msg], [handle], [msg_filter_min], [msg_filter_max], [remove_msg])
      #
      function :PeekMessage, [:pointer, :HWND, :uint, :uint, :uint], :int8,
               &->(api, msg=Msg.new, handle=0, msg_filter_min=0, msg_filter_max=0, remove_msg=PM_NOREMOVE){
               res = api.call(msg, handle, msg_filter_min, msg_filter_max, remove_msg)
               res == 0 ? nil : msg }

      ##
      # The TranslateMessage function translates virtual-key messages into character messages. The character
      # messages are posted to the calling thread's message queue, to be read the next time the thread calls
      # the GetMessage or PeekMessage function.
      #
      # [*Syntax*]  BOOL TranslateMessage( const MSG *lpMsg );
      #
      # lpMsg:: <in> Pointer to an MSG structure that contains message information retrieved from the calling
      #         thread's message queue by using the GetMessage or PeekMessage function.
      #
      # *Returns*:: If the message is translated (that is, a character message is posted to the thread's
      #             message queue), the return value is nonzero.
      #             If the message is WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, or WM_SYSKEYUP, the return value is
      #             nonzero, regardless of the translation.
      #             If the message is not translated (that is, a character message is not posted to the thread's
      #             message queue), the return value is zero.
      # ---
      # *Remarks*:
      # The TranslateMessage function does not modify the message pointed to by the lpMsg parameter.
      #
      # WM_KEYDOWN and WM_KEYUP combinations produce a WM_CHAR or WM_DEADCHAR message. WM_SYSKEYDOWN and
      # WM_SYSKEYUP combinations produce a WM_SYSCHAR or WM_SYSDEADCHAR message.
      #
      # TranslateMessage produces WM_CHAR messages only for keys that are mapped to ASCII characters by the
      # keyboard driver.
      #
      # If applications process virtual-key messages for some other purpose, they should not call
      # TranslateMessage. For instance, an application should not call TranslateMessage if the
      # TranslateAccelerator function returns a nonzero value. Note that the application is responsible for
      # retrieving and dispatching input messages to the dialog box. Most applications use the main message
      # loop for this. However, to permit the user to move to and to select controls by using the keyboard,
      # the application must call IsDialogMessage. For more information, see Dialog Box Keyboard Interface.
      # ---
      # <b>Enhanced (snake_case) API: returns true/false instead of nonzero/zero</b>
      #
      # :call-seq:
      #  success = translate_message(msg)
      #
      function :TranslateMessage, [:pointer], :int8, boolean: true

      ##
      # The DispatchMessage function dispatches a message to a window procedure. It is typically used to
      # dispatch a message retrieved by the GetMessage function.
      #
      # [*Syntax*] LRESULT DispatchMessage( const MSG *lpmsg );
      #
      # lpmsg:: <in> Pointer to an MSG structure that contains the message.
      #
      # *Returns*:: The return value specifies the value returned by the window procedure. Although its
      #             meaning depends on the message being dispatched, the return value generally is ignored.
      # ---
      # *Remarks*:
      # The MSG structure must contain valid message values. If the lpmsg parameter points to a WM_TIMER
      # message and the lParam parameter of the WM_TIMER message is not NULL, lParam points to a function that
      # is called instead of the window procedure.
      #
      # Note that the application is responsible for retrieving and dispatching input messages to the dialog
      # box. Most applications use the main message loop for this. However, to permit the user to move to and
      # to select controls by using the keyboard, the application must call IsDialogMessage. For more
      # information, see Dialog Box Keyboard Interface.
      # ---
      # <b>Enhanced (snake_case) API: </b>
      #
      # :call-seq:
      #  dispatch_message(msg)
      #
      function :DispatchMessage, [:pointer], :long

      # Untested:

      ##
      function :BroadcastSystemMessage, 'LPIIL', 'L'
      ##
      try_function :BroadcastSystemMessageEx, 'LPILLP', 'L'   # Windows XP or later only
      ##
      function :DefWindowProc, 'LLLL', 'L'
      ##
      function :GetInputState, 'V', 'B'
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
      function :WaitMessage, 'V', 'B'
    end
  end
end

