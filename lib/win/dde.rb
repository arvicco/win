require 'win/library'

module Win

  # Includes functions related to DDE exchange protocol in Windows
  #
  module Dde
    include Win::Library

    # Windows ANSI codepage:
    CP_WINANSI = 1004

    # DDE name service afCmd commands used by DdeNameService function:

    # Registers the service name.
    DNS_REGISTER = 1
    # Unregisters the service name. When hsz1 == 0L, ALL service names registered by the server will be unregistered.
    DNS_UNREGISTER = 2
    # Turns on service name initiation filtering. The filter prevents a server from receiving
    # XTYP_CONNECT transactions for service names it has not registered. This is the default
    # setting for this filter. If a server application does not register any service names,
    # the application cannot receive XTYP_WILDCONNECT transactions.
    DNS_FILTERON   = 4
    # Turns off service name initiation filtering. If this flag is specified, the server
    # receives an XTYP_CONNECT transaction whenever another DDE application calls the
    # DdeConnect function, regardless of the service name.
    DNS_FILTEROFF  = 8

    # Transaction confirmations:

    # Transaction confirmation
    DDE_FACK        = 0x8000
    # Server is too busy to process transaction
    DDE_FBUSY       = 0x4000
    DDE_FDEFERUPD   = 0x4000
    DDE_FACKREQ     = 0x8000
    DDE_FRELEASE    = 0x2000
    DDE_FREQUESTED  = 0x1000
    DDE_FAPPSTATUS  = 0x00ff
    # Transaction rejected
    DDE_FNOTPROCESSED    = 0

    # Transaction types:

    XTYPF_NOBLOCK       = 0x0002
    XTYPF_NODATA        = 0x0004
    XTYPF_ACKREQ        = 0x0008

    XCLASS_MASK         = 0xFC00
    XCLASS_BOOL         = 0x1000
    XCLASS_DATA         = 0x2000
    XCLASS_FLAGS        = 0x4000
    XCLASS_NOTIFICATION = 0x8000

    XTYP_ERROR           = XCLASS_NOTIFICATION | XTYPF_NOBLOCK
    XTYP_ADVDATA         = 0x0010 | XCLASS_FLAGS
    XTYP_ADVREQ          = 0x0020 | XCLASS_DATA | XTYPF_NOBLOCK
    XTYP_ADVSTART        = 0x0030 | XCLASS_BOOL
    XTYP_ADVSTOP         = 0x0040 | XCLASS_NOTIFICATION
    XTYP_EXECUTE         = 0x0050 | XCLASS_FLAGS
    # A client uses the XTYP_CONNECT transaction to establish a conversation. A DDE server callback function,
    # DdeCallback, receives this transaction when a client specifies a service name that the server supports
    # (and a topic name that is not NULL) in a call to the DdeConnect function.
    XTYP_CONNECT         = 0x0060 | XCLASS_BOOL | XTYPF_NOBLOCK
    XTYP_CONNECT_CONFIRM = 0x0070 | XCLASS_NOTIFICATION | XTYPF_NOBLOCK
    XTYP_XACT_COMPLETE   = 0x0080 | XCLASS_NOTIFICATION
    # A client uses the XTYP_POKE transaction to send unsolicited data to the server. DDE server callback function,
    # DdeCallback, receives this transaction when a client specifies XTYP_POKE in the DdeClientTransaction function.
    XTYP_POKE            = 0x0090 | XCLASS_FLAGS
    XTYP_REGISTER        = 0x00A0 | XCLASS_NOTIFICATION | XTYPF_NOBLOCK
    XTYP_REQUEST         = 0x00B0 | XCLASS_DATA
    XTYP_DISCONNECT      = 0x00C0 | XCLASS_NOTIFICATION | XTYPF_NOBLOCK
    XTYP_UNREGISTER      = 0x00D0 | XCLASS_NOTIFICATION | XTYPF_NOBLOCK
    XTYP_WILDCONNECT     = 0x00E0 | XCLASS_DATA | XTYPF_NOBLOCK
    XTYP_MONITOR         = 0X00F0 | XCLASS_NOTIFICATION | XTYPF_NOBLOCK
    XTYP_MASK            = 0x00F0
    XTYP_SHIFT           = 0x0004

    # Types Hash {TRANSACTION_TYPE=>'Type description')}
    TYPES = {
            XTYPF_NOBLOCK       => 'XTYPF_NOBLOCK',
            XTYPF_NODATA        => 'XTYPF_NODATA',
            XTYPF_ACKREQ        => 'XTYPF_ACKREQ',
            XCLASS_MASK         => 'XCLASS_MASK',
            XCLASS_BOOL         => 'XCLASS_BOOL',
            XCLASS_DATA         => 'XCLASS_DATA',
            XCLASS_FLAGS        => 'XCLASS_FLAGS',
            XCLASS_NOTIFICATION => 'XCLASS_NOTIFICATION',
            XTYP_ERROR          => 'XTYP_ERROR',
            XTYP_ADVDATA        => 'XTYP_ADVDATA',
            XTYP_ADVREQ         => 'XTYP_ADVREQ',
            XTYP_ADVSTART       => 'XTYP_ADVSTART',
            XTYP_ADVSTOP        => 'XTYP_ADVSTOP',
            XTYP_EXECUTE        => 'XTYP_EXECUTE',
            XTYP_CONNECT        => 'XTYP_CONNECT',
            XTYP_CONNECT_CONFIRM=> 'XTYP_CONNECT_CONFIRM',
            XTYP_XACT_COMPLETE  => 'XTYP_XACT_COMPLETE',
            XTYP_POKE           => 'XTYP_POKE',
            XTYP_REGISTER       => 'XTYP_REGISTER',
            XTYP_REQUEST        => 'XTYP_REQUEST',
            XTYP_DISCONNECT     => 'XTYP_DISCONNECT',
            XTYP_UNREGISTER     => 'XTYP_UNREGISTER',
            XTYP_WILDCONNECT    => 'XTYP_WILDCONNECT',
            XTYP_MONITOR        => 'XTYP_MONITOR',
            XTYP_MASK           => 'XTYP_MASK',
            XTYP_SHIFT          => 'XTYP_SHIFT'
    }


    # DdeInitialize afCmd flaggs:

    # Registers the application as a standard (nonmonitoring) DDEML application.
    APPCLASS_STANDARD         = 0
    # Makes it possible for the application to monitor DDE activity in the system.
    # This flag is for use by DDE monitoring applications. The application specifies the types of DDE
    # activity to monitor by combining one or more monitor flags with the APPCLASS_MONITOR flag.
    APPCLASS_MONITOR          = 0x00000001
    # ?
    APPCLASS_MASK             = 0x0000000F
    # Prevents the application from becoming a server in a DDE conversation. The application can only be a client.
    # This flag reduces consumption of resources by the DDEML. It includes the CBF_FAIL_ALLSVRXACTIONS flag.
    APPCMD_CLIENTONLY         = 0x00000010
    # Prevents the DDEML from sending XTYP_CONNECT and XTYP_WILDCONNECT transactions to the application until
    # the application has created its string handles and registered its service names or has turned off filtering
    # by a subsequent call to the DdeNameService or DdeInitialize function. This flag is always in effect when an
    # application calls DdeInitialize for the first time, regardless of whether the application specifies the flag.
    # On subsequent calls to DdeInitialize, not specifying this flag turns off the application's service-name
    # filters, but specifying it turns on the application's service name filters.
    APPCMD_FILTERINITS        = 0x00000020
    # ?
    APPCMD_MASK               = 0x00000FF0
    # Prevents the callback function from receiving XTYP_CONNECT transactions from the application's own instance.
    # This flag prevents an application from establishing a DDE conversation with its own instance. An application
    # should use this flag if it needs to communicate with other instances of itself but not with itself.
    CBF_FAIL_SELFCONNECTIONS  = 0x00001000
    # Prevents the callback function from receiving XTYP_CONNECT and XTYP_WILDCONNECT.
    CBF_FAIL_CONNECTIONS      = 0x00002000
    # Prevents the callback function from receiving XTYP_ADVSTART and XTYP_ADVSTOP transactions. The system returns
    # DDE_FNOTPROCESSED to each client that sends an XTYP_ADVSTART or XTYP_ADVSTOP transaction to the server.
    CBF_FAIL_ADVISES          = 0x00004000
    # Prevents the callback function from receiving XTYP_EXECUTE transactions. The system returns DDE_FNOTPROCESSED
    # to a client that sends an XTYP_EXECUTE transaction to the server.
    CBF_FAIL_EXECUTES         = 0x00008000
    # Prevents the callback function from receiving XTYP_POKE transactions. The system returns DDE_FNOTPROCESSED
    # to a client that sends an XTYP_POKE transaction to the server.
    CBF_FAIL_POKES            = 0x00010000
    # Prevents the callback function from receiving XTYP_REQUEST transactions. The system returns DDE_FNOTPROCESSED
    # to a client that sends an XTYP_REQUEST transaction to the server.
    CBF_FAIL_REQUESTS         = 0x00020000
    # Prevents the callback function from receiving server transactions. The system returns DDE_FNOTPROCESSED to each
    # client that sends a transaction to this application. This flag is equivalent to combining all CBF_FAIL_ flags.
    CBF_FAIL_ALLSVRXACTIONS   = 0x0003f000
    # Prevents the callback function from receiving XTYP_CONNECT_CONFIRM.
    CBF_SKIP_CONNECT_CONFIRMS = 0x00040000
    # Prevents the callback function from receiving XTYP_REGISTER notifications.
    CBF_SKIP_REGISTRATIONS    = 0x00080000
    # Prevents the callback function from receiving XTYP_UNREGISTER notifications.
    CBF_SKIP_UNREGISTRATIONS  = 0x00100000
    # Prevents the callback function from receiving XTYP_DISCONNECT notifications.
    CBF_SKIP_DISCONNECTS      = 0x00200000
    # Prevents the callback function from receiving any notifications. Equivalent to combining all CBF_SKIP_ flags.
    CBF_SKIP_ALLNOTIFICATIONS = 0x003c0000
    # Notifies the callback function whenever a DDE application creates, frees, or increments the usage count of
    # a string handle or whenever a string handle is freed as a result of a call to the DdeUninitialize function.
    MF_HSZ_INFO               = 0x01000000
    # Notifies the callback function whenever the system or an application sends a DDE message.
    MF_SENDMSGS               = 0x02000000
    # Notifies the callback function whenever the system or an application posts a DDE message.
    MF_POSTMSGS               = 0x04000000
    # Notifies the callback function whenever a transaction is sent to any DDE callback function in the system.
    MF_CALLBACKS              = 0x08000000
    # Notifies the callback function whenever a DDE error occurs.
    MF_ERRORS                 = 0x10000000
    #  Notifies the callback function whenever an advise loop is started or ended.
    MF_LINKS                  = 0x20000000
    # Notifies the callback function whenever a conversation is established or terminated.
    MF_CONV                   = 0x40000000
    # ?
    MF_MASK                   = 0xFF000000

    # Flags Hash {FLAG=>'Flag description')}
    FLAGS = {
            APPCLASS_STANDARD         => 'APPCLASS_STANDARD',
            APPCLASS_MONITOR          => 'APPCLASS_MONITOR',
            APPCLASS_MASK             => 'APPCLASS_MASK',
            APPCMD_CLIENTONLY         => 'APPCMD_CLIENTONLY',
            APPCMD_FILTERINITS        => 'APPCMD_FILTERINITS',
            APPCMD_MASK               => 'APPCMD_MASK',
            CBF_FAIL_SELFCONNECTIONS  => 'CBF_FAIL_SELFCONNECTIONS',
            CBF_FAIL_CONNECTIONS      => 'CBF_FAIL_CONNECTIONS',
            CBF_FAIL_ADVISES          => 'CBF_FAIL_ADVISES',
            CBF_FAIL_EXECUTES         => 'CBF_FAIL_EXECUTES',
            CBF_FAIL_POKES            => 'CBF_FAIL_POKES',
            CBF_FAIL_REQUESTS         => 'CBF_FAIL_REQUESTS',
            CBF_FAIL_ALLSVRXACTIONS   => 'CBF_FAIL_ALLSVRXACTIONS',
            CBF_SKIP_CONNECT_CONFIRMS => 'CBF_SKIP_CONNECT_CONFIRMS',
            CBF_SKIP_REGISTRATIONS    => 'CBF_SKIP_REGISTRATIONS',
            CBF_SKIP_UNREGISTRATIONS  => 'CBF_SKIP_UNREGISTRATIONS',
            CBF_SKIP_DISCONNECTS      => 'CBF_SKIP_DISCONNECTS',
            CBF_SKIP_ALLNOTIFICATIONS => 'CBF_SKIP_ALLNOTIFICATIONS',
            MF_HSZ_INFO               => 'MF_HSZ_INFO',
            MF_SENDMSGS               => 'MF_SENDMSGS',
            MF_POSTMSGS               => 'MF_POSTMSGS',
            MF_CALLBACKS              => 'MF_CALLBACKS',
            MF_ERRORS                 => 'MF_ERRORS',
            MF_LINKS                  => 'MF_LINKS',
            MF_CONV                   => 'MF_CONV',
            MF_MASK                   => 'MF_MASK'
    }

    # Error codes:

    # Returned if DDE Init successful
    DMLERR_NO_ERROR           = 0x00
    # First (lowest) error code
    DMLERR_FIRST         = 0x4000
    # A request for a synchronous advise transaction has timed out.
    DMLERR_ADVACKTIMEOUT = DMLERR_FIRST
    # The response to the transaction caused the DDE_FBUSY flag to be set
    DMLERR_BUSY = 0x4001
    # A request for a synchronous data transaction has timed out.
    DMLERR_DATAACKTIMEOUT = 0x4002
    # A DDEML function was called without first calling the DdeInitialize function, or an invalid instance
    # identifier was passed to a DDEML function.
    DMLERR_DLL_NOT_INITIALIZED = 0x4003
    # An application initialized as APPCLASS_MONITOR has attempted to perform a Dynamic Data Exchange (DDE) transaction,
    # or an application initialized as APPCMD_CLIENTONLY has attempted to perform server transactions.
    DMLERR_DLL_USAGE          = 0x4004
    # A request for a synchronous execute transaction has timed out.
    DMLERR_EXECACKTIMEOUT = 0x4005
    # A parameter failed to be validated by the DDEML. Some of the possible causes follow:
    # - The application used a data handle initialized with a different item name handle than was required by the
    #   transaction.
    # - The application used a data handle that was initialized with a different clipboard data format than was
    #   required by the transaction.
    # - The application used a client-side conversation handle with a server-side function or vice versa.
    # - The application used a freed data handle or string handle.
    # - More than one instance of the application used the same object.
    DMLERR_INVALIDPARAMETER   = 0x4006
    # A DDEML application has created a prolonged race condition (in which the server application
    # outruns the client), causing large amounts of memory to be consumed.
    DMLERR_LOW_MEMORY    = 0x4007
    # A memory allocation has failed.
    DMLERR_MEMORY_ERROR    = 0x4008
    # A transaction has failed.
    DMLERR_NOTPROCESSED    = 0x4009
    # A client's attempt to establish a conversation has failed.
    DMLERR_NO_CONV_ESTABLISHED    = 0x400a
    # A request for a synchronous poke transaction has timed out.
    DMLERR_POKEACKTIMEOUT    = 0x400b
    # An internal call to the PostMessage function has failed.
    DMLERR_POSTMSG_FAILED    = 0x400c
    # An application instance with a synchronous transaction already in progress attempted to initiate another
    # synchronous transaction, or the DdeEnableCallback function was called from within a DDEML callback function.
    DMLERR_REENTRANCY    = 0x400d
    # A server-side transaction was attempted on a conversation terminated by the client, or the server terminated
    # before completing a transaction.
    DMLERR_SERVER_DIED    = 0x400e
    # An internal error has occurred in the DDEML.
    DMLERR_SYS_ERROR    = 0x400f
    # A request to end an advise transaction has timed out.
    DMLERR_UNADVACKTIMEOUT    = 0x4010
    # An invalid transaction identifier was passed to a DDEML function. Once the application has returned from an
    # XTYP_XACT_COMPLETE callback, the transaction identifier for that callback function is no longer valid.
    DMLERR_UNFOUND_QUEUE_ID = 0x4011
    # Last (highest) error code
    DMLERR_LAST          = DMLERR_UNFOUND_QUEUE_ID

    # Errors Hash {ERROR_CODE=>'Error description')}
    ERRORS = {
            nil => 'No DDEML error',
            DMLERR_NO_ERROR => 'No DDEML error',
            DMLERR_ADVACKTIMEOUT => 'A request for a synchronous advise transaction has timed out.',
            DMLERR_BUSY => 'The response to the transaction caused the DDE_FBUSY flag to be set.',
            DMLERR_DATAACKTIMEOUT => 'A request for a synchronous data transaction has timed out.',
            DMLERR_DLL_NOT_INITIALIZED => 'A DDEML function was called without first calling the DdeInitialize ' +
                    'function, or an invalid instance identifier was passed to a DDEML function.',
            DMLERR_DLL_USAGE => 'An application initialized as APPCLASS_MONITOR has attempted to perform a DDE ' +
                    'transaction, or an application initialized as APPCMD_CLIENTONLY has attempted to perform ' +
                    'server transactions.',
            DMLERR_EXECACKTIMEOUT => 'A request for a synchronous execute transaction has timed out.',
            DMLERR_INVALIDPARAMETER => 'A parameter failed to be validated by the DDEML. Possible causes: ' +
                    'Application used a data handle initialized with a different item name handle than was required ' +
                    'by the transaction. ' +
                    'The application used a data handle that was initialized with a different clipboard data format ' +
                    'than was required by the transaction. ' +
                    'The application used a client-side conversation handle with server-side function or vice versa. ' +
                    'The application used a freed data handle or string handle. ' +
                    'More than one instance of the application used the same object.',
            DMLERR_LOW_MEMORY => 'A DDEML application has created a prolonged race condition (in which the server ' +
                    'application outruns the client), causing large amounts of memory to be consumed.',
            DMLERR_MEMORY_ERROR => 'A memory allocation has failed.',
            DMLERR_NO_CONV_ESTABLISHED => 'A client`s attempt to establish a conversation has failed.',
            DMLERR_NOTPROCESSED => 'A transaction has failed.',
            DMLERR_POKEACKTIMEOUT => 'A request for a synchronous poke transaction has timed out.',
            DMLERR_POSTMSG_FAILED => 'An internal call to the PostMessage function has failed.',
            DMLERR_REENTRANCY => 'An application instance with a synchronous transaction already in progress ' +
                    'attempted to initiate another synchronous transaction, or the DdeEnableCallback function ' +
                    'was called from within a DDEML callback function.',
            DMLERR_SERVER_DIED => 'A server-side transaction was attempted on a conversation terminated by the ' +
                    'client, or the server terminated before completing a transaction.',
            DMLERR_SYS_ERROR => 'An internal error has occurred in the DDEML.',
            DMLERR_UNADVACKTIMEOUT => 'A request to end an advise transaction has timed out.',
            DMLERR_UNFOUND_QUEUE_ID => 'An invalid transaction identifier was passed to a DDEML function. Once the ' +
                    'application has returned from an XTYP_XACT_COMPLETE callback, the transaction identifier for ' +
                    'that callback function is no longer valid.'
    }

    # Predefined Clipboard Formats:

    # The simplest form of Clipboard data. It is a null-terminated string containing a carriage return
    # and linefeed at the end of each line.
    CF_TEXT         = 1
    # A Windows version 2.x-compatible bitmap
    CF_BITMAP       = 2
    # A metafile picture structure. See docs for Microsoft Windows Software Development Kit.
    CF_METAFILEPICT = 3
    # Microsoft symbolic link (SYLK) format. Microsoft Excel for the Apple Macintosh was originally designed to use
    # SYLK format, and this format is now supported by Microsoft Excel on both the Windows and Macintosh platforms
    CF_SYLK         = 4
    # An ASCII format used by the VisiCalc spreadsheet program
    CF_DIF          = 5
    CF_TIFF         = 6
    CF_OEMTEXT      = 7
    CF_DIB          = 8
    CF_PALETTE      = 9
    CF_PENDATA      = 10
    CF_RIFF         = 11
    CF_WAVE         = 12
    CF_UNICODETEXT  = 13
    CF_ENHMETAFILE  = 14
    # Filename copied to clipboard
    CF_HDROP        = 15
    CF_LOCALE       = 16
    CF_MAX          = 17

    # DdeClientTransaction timeout value indicating async transaction
    TIMEOUT_ASYNC = 0xFFFFFFFF

    # The MONCBSTRUCT structure contains information about the current Dynamic Data Exchange (DDE)
    # transaction. A DDE debugging application can use this structure when monitoring transactions that the
    # system passes to the DDE callback functions of other applications.
    #
    # [*Typedef*] struct { UINT cb; DWORD dwTime; HANDLE hTask; DWORD dwRet; UINT wType; UINT wFmt; HCONV
    #             hConv; HSZ hsz1; HSZ hsz2; HDDEDATA hData; ULONG_PTR dwData1; ULONG_PTR dwData2;
    #             CONVCONTEXT cc; DWORD cbData; DWORD Data[8] } MONCBSTRUCT;
    #
    # cb:: Specifies the structure's size, in bytes.
    # dwTime:: Specifies the Windows time at which the transaction occurred. Windows time is the number of
    #          milliseconds that have elapsed since the system was booted.
    # hTask:: Handle to the task (app instance) containing the DDE callback function that received the transaction.
    # dwRet:: Specifies the value returned by the DDE callback function that processed the transaction.
    # wType:: Specifies the transaction type.
    # wFmt:: Specifies the format of the data exchanged (if any) during the transaction.
    # hConv:: Handle to the conversation in which the transaction took place.
    # hsz1:: Handle to a string.
    # hsz2:: Handle to a string.
    # hData:: Handle to the data exchanged (if any) during the transaction.
    # dwData1:: Specifies additional data.
    # dwData2:: Specifies additional data.
    # cc:: Specifies a CONVCONTEXT structure containing language information used to share data in different languages.
    # cbData:: Specifies the amount, in bytes, of data being passed with the transaction. This value can be
    #          more than 32 bytes.
    # Data:: Contains the first 32 bytes of data being passed with the transaction (8 * sizeof(DWORD)).
    # ---
    # *Information*:
    # Header Declared in Ddeml.h, include Windows.h

    class MonCbStruct < FFI::Struct # :nodoc:
      layout :cb, :uint,
             :dw_time, :uint32,
             :h_task, :ulong,
             :dw_ret, :uint32,
             :w_type, :uint,
             :w_fmt, :uint,
             :h_conv, :ulong,
             :hsz1, :ulong,
             :hsz2, :ulong,
             :h_data, :pointer,
             :dw_data1, :pointer,
             :dw_data2, :pointer,
             :cc, :pointer,
             :cb_data, :uint32,
             :data, [:uint32, 8]
    end

    # The MONCONVSTRUCT structure contains information about a Dynamic Data Exchange (DDE) conversation. A
    # DDE monitoring application can use this structure to obtain information about a conversation that has
    # been established or has terminated.
    #
    # [*Typedef*] struct { UINT cb; BOOL fConnect; DWORD dwTime; HANDLE hTask; HSZ hszSvc; HSZ hszTopic;
    #             HCONV hConvClient; HCONV hConvServer } MONCONVSTRUCT;
    #
    # cb:: Specifies the structure's size, in bytes.
    # fConnect:: Indicates whether the conversation is currently established. A value of TRUE indicates the
    #            conversation is established; FALSE indicates it is not.
    # dwTime:: Specifies the Windows time at which the conversation was established or terminated. Windows
    #          time is the number of milliseconds that have elapsed since the system was booted.
    # hTask:: Handle to a task (application instance) that is a partner in the conversation.
    # hszSvc:: Handle to the service name on which the conversation is established.
    # hszTopic:: Handle to the topic name on which the conversation is established.
    # hConvClient:: Handle to the client conversation.
    # hConvServer:: Handle to the server conversation.
    # ---
    # *Remarks*:
    #
    # Because string handles are local to the process, the hszSvc and hszTopic members are global atoms.
    # Similarly, conversation handles are local to the instance; therefore, the hConvClient and hConvServer
    # members are window handles.
    # The hConvClient and hConvServer members of the MONCONVSTRUCT structure do not hold the same value as
    # would be seen by the applications engaged in the conversation. Instead, they hold a globally unique
    # pair of values that identify the conversation.
    # ---
    # Structure Information:
    # Header Declared in Ddeml.h, include Windows.h
    #
    class MonConvStruct < FFI::Struct  # :nodoc:
      layout :cb, :uint,
             :f_connect, :uchar,
             :dw_time, :uint32,
             :h_task, :ulong,
             :hsz_svc, :ulong,
             :hsz_topic, :ulong,
             :h_conv_client, :ulong,
             :h_conv_server, :ulong
    end

    # The MONERRSTRUCT structure contains information about the current Dynamic Data Exchange (DDE) error. A
    # DDE monitoring application can use this structure to monitor errors returned by DDE Management Library
    # functions.
    #
    # [*Typedef*] struct { UINT cb; UINT wLastError; DWORD dwTime; HANDLE hTask } MONERRSTRUCT;
    #
    # cb:: Specifies the structure's size, in bytes.
    # wLastError:: Specifies the current error.
    # dwTime:: Specifies the Windows time at which the error occurred. Windows time is the number of
    #          milliseconds that have elapsed since the system was booted.
    # hTask:: Handle to the task (application instance) that called the DDE function that caused the error.
    # ---
    # Structure Information:
    # Header Declared in Ddeml.h, include Windows.h
    #
    class MonErrStruct < FFI::Struct # :nodoc:
      layout :cb, :uint,
             :w_last_error, :uint,
             :dw_time, :uint32,
             :h_task, :ulong
    end

    MH_CREATE  = 1
    MH_KEEP    = 2
    MH_DELETE  = 3
    MH_CLEANUP = 4

    # The MONHSZSTRUCT structure contains information about a Dynamic Data Exchange (DDE) string handle. A
    # DDE monitoring application can use this structure when monitoring the activity of the string manager
    # component of the DDE Management Library.
    #
    # [*Typedef*] struct { UINT cb; BOOL fsAction; DWORD dwTime; HSZ hsz; HANDLE hTask; TCHAR str[1] } MONHSZSTRUCT;
    #
    # cb:: Specifies the structure's size, in bytes.
    # fsAction:: Specifies the action being performed on the string identified by the hsz member.
    #            MH_CLEANUP:: An application is freeing its DDE resources, causing the system to delete string handles
    #                         the application had created. (The application called the DdeUninitialize function.)
    #            MH_CREATE:: An application is creating a string handle. (The app called the DdeCreateStringHandle)
    #            MH_DELETE:: An application is deleting a string handle. (The app called the DdeFreeStringHandle)
    #            MH_KEEP:: An application is increasing the usage count of a string handle. (The application called the
    #                      DdeKeepStringHandle function.)
    # dwTime:: Specifies the Windows time at which the action specified by the fsAction member takes place.
    #          Windows time is the number of milliseconds that have elapsed since the system was booted.
    # hsz:: Handle to the string. Because string handles are local to the process, this member is a global atom.
    # hTask:: Handle to the task (application instance) performing the action on the string handle.
    # str:: Pointer to the string identified by the hsz member.
    # ---
    # Structure Information
    # Header Declared in Ddeml.h, include Windows.h
    #
    class MonHszStruct < FFI::Struct # :nodoc:
      layout :cb, :uint,
             :fs_action, :uchar,
             :dw_time, :uint32,
             :hsz, :ulong,
             :h_task, :ulong,
             :str, :pointer
    end

    # The MONLINKSTRUCT structure contains information about a Dynamic Data Exchange (DDE) advise loop. A
    # DDE monitoring application can use this structure to obtain information about an advise loop that has
    # started or ended.
    #
    # [*Typedef*] struct { UINT cb; DWORD dwTime; HANDLE hTask; BOOL fEstablished; BOOL fNoData; HSZ hszSvc;
    #             HSZ hszTopic; HSZ hszItem; UINT wFmt; BOOL fServer; HCONV hConvServer; HCONV hConvClient }
    #             MONLINKSTRUCT;
    #
    # cb:: Specifies the structure's size, in bytes.
    # dwTime:: Specifies the Windows time at which the advise loop was started or ended. Windows time is the
    #          number of milliseconds that have elapsed since the system was booted.
    # hTask:: Handle to a task (application instance) that is a partner in the advise loop.
    # fEstablished:: Indicates whether an advise loop was successfully established. A value of TRUE
    #                indicates an advise loop was established; FALSE indicates it was not.
    # fNoData:: Indicates whether the XTYPF_NODATA flag is set for the advise loop. A value of TRUE
    #           indicates the flag is set; FALSE indicates it is not.
    # hszSvc:: Handle to the service name of the server in the advise loop.
    # hszTopic:: Handle to the topic name on which the advise loop is established.
    # hszItem:: Handle to the item name that is the subject of the advise loop.
    # wFmt:: Specifies the format of the data exchanged (if any) during the advise loop.
    # fServer:: Indicates whether the link notification came from the server. A value of TRUE indicates the
    #           notification came from the server; FALSE indicates otherwise.
    # hConvServer:: Handle to the server conversation.
    # hConvClient:: Handle to the client conversation.
    # ---
    # *Remarks*:
    # Because string handles are local to the process, the hszSvc, hszTopic, and hszItem members are global atoms.
    # The hConvClient and hConvServer members of the MONLINKSTRUCT structure do not hold the same value as
    # would be seen by the applications engaged in the conversation. Instead, they hold a globally unique
    # pair of values that identify the conversation.
    # ---
    # Structure Information
    # Header Declared in Ddeml.h, include Windows.h
    #
    class MonLinkStruct < FFI::Struct # :nodoc:
      layout :cb, :uint,
             :dw_time, :uint32,
             :h_task, :ulong,
             :f_established, :uchar,
             :f_no_data, :uchar,
             :hsz_svc, :ulong,
             :hsz_topic, :ulong,
             :hsz_item, :ulong,
             :w_fmt, :uint,
             :f_server, :uchar,
             :h_conv_server, :ulong,
             :h_conv_client, :ulong
    end

    # The MONMSGSTRUCT structure contains information about a Dynamic Data Exchange (DDE) message. A DDE
    # monitoring application can use this structure to obtain information about a DDE message that was sent
    # or posted.
    #
    # [*Typedef*] struct { UINT cb; HWND hwndTo; DWORD dwTime; HANDLE hTask; UINT wMsg; WPARAM wParam;
    #             LPARAM lParam; DDEML_MSG_HOOK_DATA dmhd } MONMSGSTRUCT;
    #
    # cb:: Specifies the structure's size, in bytes.
    # hwndTo:: Handle to the window that receives the DDE message.
    # dwTime:: Specifies the Windows time at which the message was sent or posted. Windows time is the
    #          number of milliseconds that have elapsed since the system was booted.
    # hTask:: Handle to the task (application instance) containing the window that receives the DDE message.
    # wMsg:: Specifies the identifier of the DDE message.
    # wParam:: Specifies the wParam parameter of the DDE message.
    # lParam:: Specifies the lParam parameter of the DDE message.
    # dmhd:: Specifies a DDEML_MSG_HOOK_DATA structure that contains additional information about the DDE message.
    # ---
    # Structure Information
    # Header Declared in Ddeml.h, include Windows.h
    #
    class MonMsgStruct < FFI::Struct # :nodoc:
      layout :cb, :uint,
             :hwnd_to, :ulong,
             :dw_time, :uint32,
             :h_task, :ulong,
             :w_msg, :uint,
             :w_param, :uint,
             :l_param, :long,
             :dmhd, :pointer
    end

    # The DDEML_MSG_HOOK_DATA structure contains information about a Dynamic Data Exchange (DDE) message,
    # and provides read access to the data referenced by the message. This structure is intended to be used
    # by a Dynamic Data Exchange Management Library (DDEML) monitoring application.
    #
    # [*Typedef*] struct { UINT_PTR uiLo; UINT_PTR uiHi; DWORD cbData; DWORD Data } DDEML_MSG_HOOK_DATA;
    #
    # uiLo:: Specifies the unpacked low-order word of the lParam parameter associated with the DDE message.
    # uiHi:: Specifies the unpacked high-order word of the lParam parameter associated with the DDE message.
    # cbData:: Specifies the amount, in bytes, of data being passed with the message. This value can be > 32.
    # Data:: Contains the first 32 bytes of data being passed with the message (8 * sizeof(DWORD)).
    # ---
    # Structure Information
    # Header Declared in Ddeml.h, include Windows.h
    #
    class DdemlMsgHookData < FFI::Struct # :nodoc:
      layout :ui_lo, :uint,
             :ui_hi, :uint,
             :cb_data, :uint32,
             :data, :uint32
    end

    ##
    # The RegisterClipboardFormat function registers a new clipboard format.
    # This format can then be used as a valid clipboard format.
    #
    # [*Syntax*] UINT RegisterClipboardFormat( LPCTSTR lpszFormat )
    #
    # lpszFormat:: <in> Pointer to a null-terminated string that names the new format.
    #
    # *Returns*:: :uint or nil. If the function succeeds, the return value identifies the registered clipboard format.
    #             If the function fails, the return value is *nil*(not zero). For error info, call GetLastError.
    # ---
    # *Remarks*:
    # If a registered format with the specified name already exists, a new format is not registered and the
    # return value identifies the existing format. This enables more than one application to copy and paste
    # data using the same registered clipboard format. Note that the comparison is case-insensitive.
    # Registered clipboard formats are identified by values in the range 0xC000 through 0xFFFF.
    # When registered clipboard formats are placed on or retrieved from the clipboard, they must be in the
    # form of an HGLOBAL value.
    #
    # :call-seq:
    #   format_id = register_clipboard_format( format_name )
    #
    function :RegisterClipboardFormat, [:pointer], :uint, zeronil: true

    ##
    # The DdeCallback function is an application-defined callback function used with the Dynamic Data Exchange
    # Management Library (DDEML) functions. It processes Dynamic Data Exchange (DDE) transactions. The PFNCALLBACK
    # type defines a pointer to this callback function. DdeCallback is a placeholder for the application-defined
    # function name.
    #
    # [*Syntax*] HDDEDATA CALLBACK DdeCallback( UINT uType, UINT uFmt, HCONV hconv, HDDEDATA hsz1, HDDEDATA hsz2,
    #            HDDEDATA hdata, HDDEDATA dwData1, HDDEDATA dwData2);
    # uType:: <in> Specifies the type of the current transaction. This parameter consists of a combination of
    #         transaction class flags and transaction type flags. The following table describes each of the
    #         transaction classes and provides a list of the transaction types in each class. For information
    #         about a specific transaction type, see the individual description of that type.
    #         - XCLASS_BOOL - A DDE callback function should return TRUE or FALSE when it finishes processing a
    #           transaction that belongs to this class. The XCLASS_BOOL class consists of the following types:
    #           - XTYP_ADVSTART
    #           - *XTYP_CONNECT*: A client uses the XTYP_CONNECT transaction to establish a conversation.
    #             hsz1:: Handle to the topic name.
    #             hsz2:: Handle to the service name.
    #             dwData1:: Pointer to a CONVCONTEXT structure that contains context information for the conversation.
    #                       If the client is not a Dynamic Data Exchange Management Library (DDEML) application,
    #                       this parameter is 0.
    #             dwData2:: Specifies whether the client is the same application instance as the server. If the
    #                       parameter is 1, the client is the same instance. If the parameter is 0, the client
    #                       is a different instance.
    #             *Returns*:: A server callback function should return TRUE to allow the client to establish a
    #                         conversation on the specified service name and topic name pair, or the function
    #                         should return FALSE to deny the conversation. If the callback function returns TRUE
    #                         and a conversation is successfully established, the system passes the conversation
    #                         handle to the server by issuing an XTYP_CONNECT_CONFIRM transaction to the server's
    #                         callback function (unless the server specified the CBF_SKIP_CONNECT_CONFIRMS flag
    #                         in the DdeInitialize function).
    #         - XCLASS_DATA - A DDE callback function should return a DDE handle, the CBR_BLOCK return code, or
    #           NULL when it finishes processing a transaction that belongs to this class. The XCLASS_DATA
    #           transaction class consists of the following types:
    #           - XTYP_ADVREQ
    #           - XTYP_REQUEST
    #           - XTYP_WILDCONNECT
    #         - XCLASS_FLAGS - A DDE callback function should return DDE_FACK, DDE_FBUSY, or DDE_FNOTPROCESSED
    #           when it finishes processing a transaction that belongs to this class. The XCLASS_FLAGS transaction
    #           class consists of the following types:
    #           - XTYP_ADVDATA
    #           - XTYP_EXECUTE
    #           - *XTYP_POKE*: A client uses the XTYP_POKE transaction to send unsolicited data to the server.
    #             uFmt:: Specifies the format of the data sent from the server.
    #             hconv:: Handle to the conversation.
    #             hsz1:: Handle to the topic name.
    #             hsz2:: Handle to the item name.
    #             hdata:: Handle to the data that the client is sending to the server.
    #             *Returns*:: A server callback function should return the DDE_FACK flag if it processes this
    #                         transaction, the DDE_FBUSY flag if it is too busy to process this transaction,
    #                         or the DDE_FNOTPROCESSED flag if it rejects this transaction.
    #         - XCLASS_NOTIFICATION - The transaction types that belong to this class are for notification purposes
    #           only. The return value from the callback function is ignored. The XCLASS_NOTIFICATION transaction
    #           class consists of the following types:
    #           - XTYP_ADVSTOP
    #           - XTYP_CONNECT_CONFIRM
    #           - XTYP_DISCONNECT
    #           - XTYP_ERROR
    #           - XTYP_MONITOR
    #           - XTYP_REGISTER
    #           - XTYP_XACT_COMPLETE
    #           - XTYP_UNREGISTER
    # uFmt:: <in> Specifies the format in which data is sent or received.
    # hconv:: <in> Handle to the conversation associated with the current transaction.
    # hsz1:: <in> Handle to a string. The meaning of this parameter depends on the type of the current transaction.
    #        For the meaning of this parameter, see the description of the transaction type.
    # hsz2:: <in> Handle to a string. The meaning of this parameter depends on the type of the current transaction.
    #        For the meaning of this parameter, see the description of the transaction type.
    # hdata:: <in> Handle to DDE data. The meaning of this parameter depends on the type of the current transaction.
    #         For the meaning of this parameter, see the description of the transaction type.
    # dwData1:: <in> Specifies transaction-specific data. For the meaning, see the description of the transaction type.
    # dwData2:: <in> Specifies transaction-specific data. For the meaning, see the description of the transaction type.
    # *Returns*:: The return value depends on the transaction class. For more information about the return values,
    #             see descriptions of the individual transaction types.
    # ---
    # *Remarks*:
    # - The callback function is called asynchronously for transactions that do not involve the creation or termination
    #   of conversations. An application that does not frequently accept incoming messages will have reduced DDE
    #   performance because the Dynamic Data Exchange Management Library (DDEML) uses messages to initiate transactions.
    # - An application must register the callback function by specifying a pointer to the function in a call to the
    #   DdeInitialize function.
    #
    # :call-seq:
    #  DdeCallback block: {|type, format, hconv, hsz1, hsz2, hdata, data1, data2| your code }
    #
    callback :DdeCallback, [:uint, :uint, :HCONV, :HDDEDATA, :HDDEDATA, :HDDEDATA, :HDDEDATA, :HDDEDATA], :HDDEDATA

    ##
    # The DdeInitialize function registers an application with the Dynamic Data Exchange Management Library (DDEML).
    # An application must call this function before calling any other DDEML function.
    #
    # [*Syntax*] UINT DdeInitialize( LPDWORD pidInst, PFNCALLBACK pfnCallback, DWORD afCmd, DWORD ulRes );
    #
    # pidInst:: <in, out> Pointer to the application instance identifier.
    #           At initialization, this parameter should point to 0. If the function succeeds, this parameter points
    #           to the instance identifier for the application. This value should be passed as the idInst parameter
    #           in all other DDEML functions that require it. If an application uses multiple instances of the DDEML
    #           dynamic-link library (DLL), the application should provide a different callback function for each
    #           instance. If pidInst points to a nonzero value, reinitialization of the DDEML is implied. In this
    #           case, pidInst must point to a valid application-instance identifier.
    # pfnCallback:: Pointer to the application-defined Dynamic Data Exchange DdeCallback function. This function
    #               processes DDE transactions sent by the system. For more information, see the DdeCallback.
    # afCmd:: <in> Specifies a set of APPCMD_, CBF_, and MF_ flags. The APPCMD_ flags provide special
    #         instructions to DdeInitialize. The CBF_ flags specify filters that prevent specific types of transactions
    #         from reaching the callback function. The MF_ flags specify the types of DDE activity that a DDE monitoring
    #         application monitors. Using these flags enhances the performance of a DDE application by eliminating
    #         unnecessary calls to the callback function. This parameter can be one or more of the following values:
    #         APPCLASS_MONITOR, APPCLASS_STANDARD, APPCMD_CLIENTONLY, APPCMD_FILTERINITS;
    #         CBF_FAIL_ALLSVRXACTIONS, CBF_FAIL_ADVISES, CBF_FAIL_CONNECTIONS, CBF_FAIL_EXECUTES, CBF_FAIL_POKES
    #         CBF_FAIL_REQUESTS, CBF_FAIL_SELFCONNECTIONS, CBF_SKIP_ALLNOTIFICATIONS, CBF_SKIP_CONNECT_CONFIRMS
    #         CBF_SKIP_DISCONNECTS, CBF_SKIP_REGISTRATIONS, CBF_SKIP_UNREGISTRATIONS;
    #         MF_CALLBACKS, MF_CONV, MF_ERRORS, MF_HSZ_INFO, MF_LINKS, MF_POSTMSGS, MF_SENDMSGS
    # ulRes:: Reserved; must be set to zero.
    #
    # *Returns*:: If the function succeeds, the return value is DMLERR_NO_ERROR. If the function fails, the return
    #             value is one of the following values:
    #             - DMLERR_DLL_USAGE
    #             - DMLERR_INVALIDPARAMETER
    #             - DMLERR_SYS_ERROR
    # ---
    # <b> Enhanced API accepts only 2 parameters (get rid of reserved hsz2):
    # instance_id:: (optional) Application instance identifier. At initialization, this parameter should be 0, nil
    #               or omitted altogether. If it is nonzero/non-nil, reinitialization of the DDEML is implied.
    # cmd(afCmd):: obligatory set of flags
    # ---
    # *Remarks*:
    # - An application that uses multiple instances of the DDEML must not pass DDEML objects between instances.
    # - A DDE monitoring application should not attempt to perform DDE operations (establish conversations,
    #   issue transactions, and so on) within the context of the same application instance.
    # - A synchronous transaction fails with a DMLERR_REENTRANCY error if any instance of the same task has
    #   a synchronous transaction already in progress.
    # - The CBF_FAIL_ALLSVRXACTIONS flag causes the DDEML to filter all server transactions and can be changed
    #   by a subsequent call to DdeInitialize. The APPCMD_CLIENTONLY flag prevents the DDEML from creating key
    #   resources for the server and cannot be changed by a subsequent call to DdeInitialize.
    # - There is an ANSI version and a Unicode version of DdeInitialize. The version called determines the
    #   type of the window procedures used to control DDE conversations (ANSI or Unicode), and the default
    #   value for the iCodePage member of the CONVCONTEXT structure (CP_WINANSI or CP_WINUNICODE).
    #
    # :call-seq:
    #  instance_id, status = dde_initialize( [instance_id = 0], cmd )
    #  {|type, format, hconv, hsz1, hsz2, hdata, data1, data2| your dde_callback block}
    #
    function :DdeInitialize, [:pointer, :DdeCallback, :uint32, :uint32], :uint,
             &->(api, old_id=0, cmd, &block){
             raise ArgumentError, 'No callback block' unless block
             old_id = 0 unless old_id
             id = FFI::MemoryPointer.new(:uint32).put_uint32(0, old_id)
             status = api.call(id, block, cmd, 0)
             id = status == 0 ? id.get_uint32(0) : nil
             [id, status] }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

    ##
    # The DdeUninitialize function frees all Dynamic Data Exchange Management Library (DDEML) resources associated
    # with the calling application.
    #
    # [*Syntax*] BOOL DdeUninitialize( DWORD idInst);
    #
    # idInst:: <in> Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # *Returns*:: If the function succeeds, the return value is nonzero.
    #             If the function fails, the return value is zero.
    # ---
    # *Remarks*
    # DdeUninitialize terminates any conversations currently open for the application.
    #
    # :call-seq:
    #  success = dde_uninitialize( instance_id )
    #
    function :DdeUninitialize, [:uint32], :int, boolean: true

    ##
    # The DdeCreateStringHandle function creates a handle that identifies the specified string.
    # A Dynamic Data Exchange (DDE) client or server application can pass the string handle as a
    # parameter to other Dynamic Data Exchange Management Library (DDEML) functions.
    #
    # [*Syntax*] HSZ DdeCreateStringHandle( DWORD idInst, LPTSTR psz, int iCodePage );
    #
    # idInst:: <in> Specifies the application instance identifier obtained by a previous call to the
    #          DdeInitialize function.
    # psz:: <in> Pointer to a buffer that contains the null-terminated string for which a handle
    #       is to be created. This string can be up to 255 characters. The reason for this limit is that
    #       DDEML string management functions are implemented using global atoms.
    # iCodePage:: <in> Specifies the code page used to render the string. This value should be either
    #             CP_WINANSI (the default code page) or CP_WINUNICODE, depending on whether the ANSI or Unicode
    #             version of DdeInitialize was called by the client application.
    #
    # *Returns*:: (L) or nil: If the function succeeds, the return value is a string handle.
    #             If the function fails, the return value is 0(changed to nil in enhanced version).
    #             The DdeGetLastError function can be used to get the error code, which can be one of the
    #             following values: DMLERR_NO_ERROR, DMLERR_INVALIDPARAMETER, DMLERR_SYS_ERROR
    # ---
    # <b> Enhanced (snake_case) API makes code_page param optional and returns *nil* if handle creation fails. </b>
    # ---
    # *Remarks*: The value of a string handle is not related to the case of the string it identifies.
    # When an application either creates a string handle or receives one in the callback function
    # and then uses the DdeKeepStringHandle function to keep it, the application must free that string
    # handle when it is no longer needed. An instance-specific string handle cannot be mapped from string
    # handle to string and back to string handle.
    #
    # :call-seq:
    #  string_handle = dde_create_string_handle( instance_id, string, code_page_id )
    #
    function :DdeCreateStringHandle, [:uint32, :pointer, :int], :ulong, zeronil: true,
             &->(api, instance_id, string, code_page=CP_WINANSI){
             string_pointer = FFI::MemoryPointer.from_string(string)
             api.call(instance_id, string_pointer, code_page) }

    ##
    # The DdeFreeStringHandle function frees a string handle in the calling application.
    #
    # [*Syntax*] BOOL DdeFreeStringHandle( DWORD idInst, HSZ hsz );
    #
    # idInst:: <in> Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # hsz:: <in, out> Handle to the string handle to be freed. This handle must have been created by a previous call
    #       to the DdeCreateStringHandle function.
    # *Returns*:: If the function succeeds, the return value is nonzero. If the function fails, it is zero.
    # ---
    # <b> Enhanced snake_case API returns boolean true/false as a success indicator. </b>
    # ---
    # *Remarks*:
    # An application can free string handles it creates with DdeCreateStringHandle but should not free those that
    # the system passed to the application's Dynamic Data Exchange (DDE) callback function or those returned in the
    # CONVINFO structure by the DdeQueryConvInfo function.
    #
    # :call-seq:
    #  success = dde_free_string_handle( instance_id, string_handle )
    #
    function :DdeFreeStringHandle, [:uint32, :ulong], :int, boolean: true

    ##
    # The DdeQueryString function copies text associated with a string handle into a buffer.
    #
    # [*Syntax*] DWORD DdeQueryString( DWORD idInst, HSZ hsz, LPTSTR psz, DWORD cchMax, int iCodePage);
    #
    # idInst:: <in> Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # hsz:: <in> Handle to the string to copy. This handle must have been created by a previous call to the
    #       DdeCreateStringHandle function.
    # psz:: <in, out> Pointer to a buffer that receives the string. To obtain the length of the string, this parameter
    #       should be set to NULL.
    # cchMax::  <in> Specifies the length, in TCHARs, of the buffer pointed to by the psz parameter. For the ANSI
    #           version of the function, this is the number of bytes; for the Unicode version, this is the number of
    #           characters. If the string is longer than ( cchMax– 1), it will be truncated. If the psz parameter is
    #           set to NULL, this parameter is ignored.
    # iCodePage:: <in> Code page used to render the string. This value should be either CP_WINANSI or CP_WINUNICODE.
    #
    # *Returns*:: If the psz parameter specified a valid pointer, the return value is the length, in TCHARs, of the
    #             returned text (not including the terminating null character). If the psz parameter specified a NULL
    #             pointer, the return value is the length of the text associated with the hsz parameter (not including
    #             the terminating null character). If an error occurs, the return value is 0L.
    # ---
    # <b> Enhanced (snake_case) API makes all args optional except for first (dde instance id), and returns nil if
    # the function was unsuccessful.</b>
    # ---
    # *Remarks*
    # - The string returned in the buffer is always null-terminated. If the string is longer than ( cchMax– 1),
    #   only the first ( cchMax– 1) characters of the string are copied.
    # - If the psz parameter is NULL, the DdeQueryString function obtains the length, in bytes, of the string
    #   associated with the string handle. The length does not include the terminating null character.
    #
    # :call-seq:
    #  string = dde_query_string( instance_id, handle, [code_page = CP_WINANSI ] )
    #
    function :DdeQueryString, [:uint32, :ulong, :pointer, :uint32, :int], :uint32,
             &->(api, instance_id, handle, code_page = CP_WINANSI){
             buffer = FFI::MemoryPointer.new :char, 1024
             num_chars = api.call(instance_id, handle, buffer, buffer.size, code_page)
             num_chars == 0 ? nil : buffer.get_bytes(0, num_chars) }

    ##
    # The DdeNameService function registers or unregisters the service names a Dynamic Data Exchange (DDE) server
    # supports. This function causes the system to send XTYP_REGISTER or XTYP_UNREGISTER transactions to other running
    # Dynamic Data Exchange Management Library (DDEML) client applications.
    #
    # [*Syntax*] HDDEDATA DdeNameService( DWORD idInst, UINT hsz1, UINT hsz2, UINT afCmd );
    #
    # idInst:: <in> Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # hsz1:: <in> Handle to the string that specifies the service name the server is registering or unregistering.
    #        An application that is unregistering all of its service names should set this parameter to 0L.
    # hsz2:: Reserved; should be set to 0L.
    # afCmd:: <in> Specifies the service name options. This parameter can be one of the following values.
    #         DNS_REGISTER::  Registers the service name.
    #         DNS_UNREGISTER:: Unregisters the service name. If the hsz1 parameter is 0L,
    #                          all service names registered by the server will be unregistered.
    #         DNS_FILTERON:: Turns on service name initiation filtering. The filter prevents a server from receiving
    #                        XTYP_CONNECT transactions for service names it has not registered. This is the default
    #                        setting for this filter. If a server application does not register any service names,
    #                        the application cannot receive XTYP_WILDCONNECT transactions.
    #         DNS_FILTEROFF:: Turns off service name initiation filtering. If this flag is specified, the server
    #                         receives an XTYP_CONNECT transaction whenever another DDE application calls the
    #                         DdeConnect function, regardless of the service name.
    # *Returns*:: If the function succeeds, it returns nonzero (*true* in snake_case method). For CamelCase, that
    #             value is not really HDDEDATA value, but merely a Boolean indicator of success. The function is
    #             typed HDDEDATA to allow for future expansion of the function and more sophisticated returns.
    #             If the function fails, the return value is 0L (*false* in snake_case method). The DdeGetLastError
    #             function can be used to get the error code, which can be one of the following:
    #             - DMLERR_DLL_NOT_INITIALIZED
    #             - DMLERR_DLL_USAGE
    #             - DMLERR_INVALIDPARAMETER
    #             - DMLERR_NO_ERROR
    # ---
    # <b> Enhanced API accepts only 3 parameters (get rid of reserved hsz2) and returns boolean true/false. </b>
    # ---
    # *Remarks*:
    # The service name identified by the hsz1 parameter should be a base name (that is, the name should contain no
    # instance-specific information). The system generates an instance-specific name and sends it along with the
    # base name during the XTYP_REGISTER and XTYP_UNREGISTER transactions. The receiving applications can then
    # connect to the specific application instance.
    #
    # :call-seq:
    #  success = dde_name_service( instance_id, string_handle, cmd )
    #
    function :DdeNameService, [:uint32, :ulong, :ulong, :uint], :ulong,
             &->(api, id, string_handle, cmd){ api.call(id, string_handle, 0, cmd) != 0 }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

    ##
    # DdeConnect function establishes a conversation with a server application that supports the specified service
    # name and topic name pair. If more than one such server exists, the system selects only one.
    #
    # [*Syntax*] HCONV DdeConnect( DWORD idInst, HSZ hszService, HSZ hszTopic, PCONVCONTEXT pCC );
    #
    # idInst::  <in> Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # hszService:: <in> Handle to the string that specifies the service name of the server application with which
    #              a conversation is to be established. This handle must have been created by a previous call to
    #              the DdeCreateStringHandle function. If this parameter is 0L, a conversation is established with
    #              any available server.
    # hszTopic:: <in> Handle to the string that specifies the name of the topic on which a conversation is to be
    #            established. This handle must have been created by a previous call to DdeCreateStringHandle.
    #            If this parameter is 0L, a conversation on any topic supported by the selected server is established.
    # pCC:: <in> Pointer to the CONVCONTEXT structure that contains conversation context information. If this
    #            parameter is NULL, the server receives the default CONVCONTEXT structure during the XTYP_CONNECT
    #            or XTYP_WILDCONNECT transaction.
    # *Returns*:: If the function succeeds, the return value is the handle to the established conversation.
    #             If the function fails, the return value is 0L. The DdeGetLastError function can be used to get
    #             the error code, which can be one of the following values:
    #             - DMLERR_DLL_NOT_INITIALIZED
    #             - DMLERR_INVALIDPARAMETER
    #             - DMLERR_NO_CONV_ESTABLISHED
    #             - DMLERR_NO_ERROR
    # ---
    # *Remarks*
    # - The client application cannot make assumptions regarding the server selected. If an instance-specific name
    #   is specified in the hszService parameter, a conversation is established with only the specified instance.
    #   Instance-specific service names are passed to an application's Dynamic Data Exchange (DDE) callback function
    #   during the XTYP_REGISTER and XTYP_UNREGISTER transactions.
    # - All members of the default CONVCONTEXT structure are set to zero except cb, which specifies the size of the
    #   structure, and iCodePage, which specifies CP_WINANSI (the default code page) or CP_WINUNICODE, depending on
    #   whether the ANSI or Unicode version of the DdeInitialize function was called by the client application.
    # ---
    # <b>Enhanced (snake_case) API makes all args optional except for first (dde instance id), and returns nil if
    # the function was unsuccessful.</b>
    #
    # :call-seq:
    #  conversation_handle = dde_connect( instance_id, [service = 0, topic = 0, context = nil] )
    #
    function :DdeConnect, [:uint32, :ulong, :ulong, :pointer], :ulong, zeronil: true,
             &->(api, instance_id, service = 0, topic = 0, context = nil){
             api.call(instance_id, service, topic, context) }

    ##
    # The DdeDisconnect function terminates a conversation started by either the DdeConnect or DdeConnectList function
    # and invalidates the specified conversation handle.
    #
    # [*Syntax*] BOOL DdeDisconnect( HCONV hConv );
    #
    # hConv:: <in, out> Handle to the active conversation to be terminated.
    #
    # *Returns*:: If the function succeeds, the return value is nonzero, otherwise zero. The DdeGetLastError function
    #             can be used to get the error code, which can be one of the following values:
    #             - DMLERR_DLL_NOT_INITIALIZED
    #             - DMLERR_NO_CONV_ESTABLISHED
    #             - DMLERR_NO_ERROR
    # ---
    # *Remarks*:
    # Any incomplete transactions started before calling DdeDisconnect are immediately abandoned. The XTYP_DISCONNECT
    # transaction is sent to the Dynamic Data Exchange (DDE) callback function of the partner in the conversation.
    # Generally, only client applications must terminate conversations.
    # ---
    # <b>Enhanced (snake_case) API returns *true/false* instead of nonzero/zero.</b>
    #
    # :call-seq:
    #  success = dde_disconnect(conversation_handle)
    #
    function :DdeDisconnect, [:ulong], :int, boolean: true


    ##
    # The DdeGetLastError function retrieves the most recent error code set by the failure of a Dynamic Data Exchange
    # Management Library (DDEML) function and resets the error code to DMLERR_NO_ERROR.
    #
    # [*Syntax*] UINT DdeGetLastError( DWORD idInst );
    #
    # idInst:: <in> Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    #
    # *Returns*:: If the function succeeds, the return value is the last error code, which can be one of the following:
    # DMLERR_ADVACKTIMEOUT, DMLERR_EXECACKTIMEOUT, DMLERR_INVALIDPARAMETER, DMLERR_LOW_MEMORY, DMLERR_MEMORY_ERROR,
    # DMLERR_NO_CONV_ESTABLISHED, DMLERR_NOTPROCESSED, DMLERR_POKEACKTIMEOUT, DMLERR_POSTMSG_FAILED, DMLERR_REENTRANCY,
    # DMLERR_SERVER_DIED, DMLERR_SYS_ERROR, DMLERR_UNADVACKTIMEOUT, DMLERR_UNFOUND_QUEUE_ID
    # ---
    # <b>Enhanced (snake_case) API returns *nil* if the function was unsuccessful (that is, no DDE errors raised).</b>
    # ---
    #
    # :call-seq:
    #  string = dde_get_last_error( instance_id )
    #
    function :DdeGetLastError, [:uint32], :int, zeronil: true

    ##
    # The DdeClientTransaction function begins a data transaction between a client and a server. Only a
    # Dynamic Data Exchange (DDE) client application can call this function, and the application can use it
    # only after establishing a conversation with the server.
    #
    # [*Syntax*]  HDDEDATA DdeClientTransaction( LPBYTE pData, DWORD cbData, HCONV hConv, HSZ hszItem, UINT
    #            wFmt, UINT wType, DWORD dwTimeout, LPDWORD pdwResult );
    #
    # pData:: <in> Pointer to the beginning of the data the client must pass to the server.
    #         Optionally, an application can specify the data handle (HDDEDATA) to pass to the server and in that
    #         case the cbData parameter should be set to -1. This parameter is required only if the wType parameter
    #         is XTYP_EXECUTE or XTYP_POKE. Otherwise, this parameter should be NULL.
    #         For the optional usage of this parameter, XTYP_POKE transactions where pData is a data handle, the
    #         handle must have been created by a previous call to the DdeCreateDataHandle function, employing the
    #         same data format specified in the wFmt parameter.
    # cbData:: <in> Specifies the length, in bytes, of the data pointed to by the pData parameter, including
    #          the terminating NULL, if the data is a string. A value of -1 indicates that pData is a data
    #          handle that identifies the data being sent.
    # hConv:: <in> Handle to the conversation in which the transaction is to take place.
    # hszItem:: <in> Handle to the data item for which data is being exchanged during the transaction. This
    #           handle must have been created by a previous call to the DdeCreateStringHandle function. This
    #           parameter is ignored (and should be set to 0L) if the wType parameter is XTYP_EXECUTE.
    # wFmt:: <in> Specifies the standard clipboard format in which the data item is being submitted or
    #        requested. If the transaction specified by the wType parameter does not pass data or is XTYP_EXECUTE,
    #        this parameter should be zero.
    #        If the transaction specified by the wType parameter references non-execute DDE data ( XTYP_POKE,
    #        XTYP_ADVSTART, XTYP_ADVSTOP, XTYP_REQUEST), the wFmt value must be either a valid predefined (CF_) DDE
    #        format or a valid registered clipboard format.
    # wType:: <in> Specifies the transaction type. This parameter can be one of the following values.
    #         - XTYP_ADVSTART: Begins an advise loop. Any number of distinct advise loops can exist within a
    #           conversation. An application can alter the advise loop type by combining the XTYP_ADVSTART
    #           transaction type with one or more of the following flags: Flag Meaning
    #           - XTYPF_NODATA Instructs the server to notify the client of any data changes without actually sending
    #             the data. This flag gives the client the option of ignoring the notification or requesting the changed
    #             data from the server.
    #           - XTYPF_ACKREQ Instructs the server to wait until the client acknowledges that it received the previous
    #             data item before sending the next data item. This flag prevents a fast server from sending data faster
    #             than the client can process it.
    #         - XTYP_ADVSTOP: Ends an advise loop.
    #         - XTYP_EXECUTE: Begins an execute transaction.
    #         - XTYP_POKE: Begins a poke transaction.
    #         - XTYP_REQUEST: Begins a request transaction.
    # dwTimeout:: <in> Specifies the maximum amount of time, in milliseconds, that the client will wait for
    #             a response from the server application in a synchronous transaction. This parameter should
    #             be TIMEOUT_ASYNC for asynchronous transactions.
    # pdwResult:: <out> Pointer to a variable that receives the result of the transaction. An application
    #             that does not check the result can use NULL for this value. For synchronous transactions,
    #             the low-order word of this variable contains any applicable DDE_ flags resulting from the
    #             transaction. This provides support for applications dependent on DDE_APPSTATUS bits. It
    #             is, however, recommended that applications no longer use these bits because they may not
    #             be supported in future versions of the Dynamic Data Exchange Management Library (DDEML).
    #             For asynchronous transactions, this variable is filled with a unique transaction
    #             identifier for use with the DdeAbandonTransaction function and the XTYP_XACT_COMPLETE
    #             transaction.
    #
    # *Returns*:: If the function succeeds, the return value is a data handle that identifies the data for
    #             successful synchronous transactions in which the client expects data from the server. The
    #             return value is nonzero for successful asynchronous transactions and for synchronous
    #             transactions in which the client does not expect data. The return value is zero for all
    #             unsuccessful transactions.
    # The DdeGetLastError function can be used to get the error code, which can be one of the following values:
    # - DMLERR_ADVACKTIMEOUT
    # - DMLERR_BUSY
    # - DMLERR_DATAACKTIMEOUT
    # - DMLERR_DLL_NOT_INITIALIZED
    # - DMLERR_EXECACKTIMEOUT
    # - DMLERR_INVALIDPARAMETER
    # - DMLERR_MEMORY_ERROR
    # - DMLERR_NO_CONV_ESTABLISHED
    # - DMLERR_NO_ERROR
    # - DMLERR_NOTPROCESSED
    # - DMLERR_POKEACKTIMEOUT
    # - DMLERR_POSTMSG_FAILED
    # - DMLERR_REENTRANCY
    # - DMLERR_SERVER_DIED
    # - DMLERR_UNADVACKTIMEOUT
    # ---
    # *Remarks*:
    # When an application has finished using the data handle returned by DdeClientTransaction, the application should
    # free the handle by calling the DdeFreeDataHandle function.
    #
    #Transactions can be synchronous or asynchronous. During a synchronous transaction, DdeClientTransaction does not
    # return until the transaction either completes successfully or fails. Synchronous transactions cause a client to
    # enter a modal loop while waiting for various asynchronous events. Because of this, a client application can still
    # respond to user input while waiting on a synchronous transaction, but the application cannot begin a second
    # synchronous transaction because of the activity associated with the first. DdeClientTransaction fails if any
    # instance of the same task has a synchronous transaction already in progress.
    #
    # During an asynchronous transaction, DdeClientTransaction returns after the transaction has begun,
    # passing a transaction identifier for reference. When the server's DDE callback function finishes
    # processing an asynchronous transaction, the system sends an XTYP_XACT_COMPLETE transaction to the
    # client. This transaction provides the client with the results of the asynchronous transaction that it
    # initiated by calling DdeClientTransaction. A client application can choose to abandon an asynchronous
    # transaction by calling the DdeAbandonTransaction function.
    # ---
    # <b>Enhanced (snake_case) API: </b>
    #
    # :call-seq:
    #  data_handle = dde_client_transaction(data_pointer, size, conv, item, format, type, timeout, result)
    #
    function :DdeClientTransaction, [:pointer, :uint32, :ulong, :ulong, :uint, :uint, :uint32, :pointer],
             :HDDEDATA, zeronil: true

    ##
    # The DdeGetData function copies data from the specified Dynamic Data Exchange (DDE) object to the specified
    # local buffer.
    #
    # [*Syntax*] DWORD DdeGetData( HDDEDATA hData, LPBYTE pDst, DWORD cbMax, DWORD cbOff );
    #
    # hData:: <in> Handle to the DDE object that contains the data to copy.
    # pDst:: <out> Pointer to the buffer that receives the data. If this parameter is NULL, the DdeGetData
    #        function returns the amount of data, in bytes, that would be copied to the buffer.
    # cbMax:: <in> Specifies the maximum amount of data, in bytes, to copy to the buffer pointed to by the pDst
    #         parameter. Typically, this parameter specifies the length of the buffer pointed to by pDst.
    # cbOff:: <in> Specifies an offset within the DDE object. Data is copied from the object beginning at this offset.
    #
    # *Returns*:: If the pDst parameter points to a buffer, return value is the size, in bytes, of the memory object
    #             associated with the data handle or the size specified in the cbMax parameter, whichever is lower.
    #             If the pDst parameter is NULL, the return value is the size, in bytes, of the memory object
    #             associated with the data handle.
    #             The DdeGetLastError function can be used to get the error code, which can be one of the following:
    #             - DMLERR_DLL_NOT_INITIALIZED
    #             - DMLERR_INVALIDPARAMETER
    #             - DMLERR_NO_ERROR
    # ---
    # <b> Enhanced (snake_case) API accepts data handle, and optionally max and offset (no need to pre-allocate
    # buffer). It returns pointer to copied DDE data (FFI::MemoryPointer) and size of copied data in bytes.
    # In case of failure, it returns [nil, 0]. This API is the same as for enhanced dde_access_data.
    # No need to call function twice (first time with nil buffer just to determine length).</b>
    # ---
    #
    # :call-seq:
    #  buffer, size = dde_get_data( data_handle, [max = infinite, offset = 0] )
    #
    function :DdeGetData, [:ulong, :pointer, :uint32, :uint32], :uint,
             &->(api, data_handle, max=1073741823, offset=0){     # max is maximum DWORD Fixnum
             size = api.call(data_handle, nil, 0, 0)   # determining data set length
             if size == 0
               [nil, 0]
             else
               copy_size = size < max ? size : max
               buffer = FFI::MemoryPointer.new(:char, offset + copy_size)
               size = api.call(data_handle, buffer, copy_size, offset)
               [buffer, size]
             end }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition


    ##
    # The DdeAccessData function provides access to the data in the specified Dynamic Data Exchange (DDE)
    # object. An application must call the DdeUnaccessData function when it has finished accessing the data
    # in the object.
    #
    # [*Syntax*] LPBYTE DdeAccessData( HDDEDATA hData, LPDWORD pcbDataSize );
    #
    # hData:: <in> Handle to the DDE object to access.
    # pcbDataSize:: <out> Pointer to a variable that receives the size, in bytes, of the DDE object
    #               identified by the hData parameter. If this parameter is NULL, no size information is
    #               returned.
    #
    # *Returns*:: If the function succeeds, the return value is a pointer to the first byte of data in the
    #             DDE object.
    # If the function fails, the return value is NULL.
    # The DdeGetLastError function can be used to get the error code, which can be one of the following
    # values:
    # DMLERR_DLL_NOT_INITIALIZED
    # DMLERR_INVALIDPARAMETER
    # DMLERR_NO_ERROR
    # ---
    # *Remarks*:
    # If the hData parameter has not been passed to a Dynamic Data Exchange Management Library (DDEML)
    # function, an application can use the pointer returned by DdeAccessData for read-write access to the
    # DDE object. If hData has already been passed to a DDEML function, the pointer should be used only for
    # read access to the memory object.
    #
    # ---
    # <b>Enhanced (snake_case) API accepts DDE data handle and returns FFI::MemoryPointer to raw data and
    # size of data set in bytes (same API as enhanced dde_get_data). Returns [nil, 0] in case of failure. </b>
    #
    # :call-seq:
    #  data_pointer, size = dde_access_data( data_handle )
    #
    function :DdeAccessData, [:HDDEDATA, :pointer], :pointer,
             &->(api, data_handle){
             size_buffer = FFI::MemoryPointer.new(:uint32)
             buffer = api.call(data_handle, size_buffer)
             size = size_buffer.get_uint32(0)
             size == 0 ? [nil, 0] : [buffer, size] }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

      ##
      # The DdeUnaccessData function unaccesses a Dynamic Data Exchange (DDE) object. An application must call
      # this function after it has finished accessing the object.
      #
      # [*Syntax*] BOOL DdeUnaccessData( HDDEDATA hData );
      #
      # hData:: <in> Handle to the DDE object.
      #
      # *Returns*:: If the function succeeds, the return value is nonzero.
      # If the function fails, the return value is zero.
      # The DdeGetLastError function can be used to get the error code, which can be one of the following
      # values:
      # DMLERR_DLL_NOT_INITIALIZED
      # DMLERR_INVALIDPARAMETER
      # DMLERR_NO_ERROR
      #
      # ---
      # <b>Enhanced (snake_case) API returns true/false instead of nonzero/zero: </b>
      #
      # :call-seq:
      #  success = dde_unaccess_data(data_handle)
      #
      function :DdeUnaccessData, [:HDDEDATA], :int8, boolean: true

  end
end
