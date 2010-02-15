require 'win/library'

module Win

  # Includes functions related to DDE exchange protocol in Windows
  #
  module DDE
    include Win::Library

    # Windows ANSI codepage:
    CP_WINANSI = 1004

    #
    DNS_REGISTER = 1
    DNS_UNREGISTER = 2

    XTYP_CONNECT = 0x60
    XTYP_DISCONNECT = 0xC0
    XTYP_POKE = 0x90
    XTYP_ERROR = 0x00

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
    # Returned if DDE Init successful
    DMLERR_NO_ERROR           = 0x00
    # Returned if DDE Init failed due to wrong DLL usage
    DMLERR_DLL_USAGE          = 0x4004
    # Returned if DDE Init failed due to invalid params
    DMLERR_INVALIDPARAMETER   = 0x4006
    # Returned if DDE Init failed due to system error
    DMLERR_SYS_ERROR          = 0x400f

    ##
    # The RegisterClipboardFormat function registers a new clipboard format.
    # This format can then be used as a valid clipboard format.
    #
    # Syntax: UINT RegisterClipboardFormat( LPCTSTR lpszFormat )
    #
    # Params:
    #   format_name (P) - [in] Pointer to a null-terminated string that names the new format.
    #
    # Returns: (I) or nil
    #   If the function succeeds, the return value identifies the registered clipboard format.
    #   If the function fails, the return value is nil(not zero). For error information, call GetLastError.
    #
    # Remarks:
    #   If a registered format with the specified name already exists, a new format is not registered and the
    #   return value identifies the existing format. This enables more than one application to copy and paste
    #   data using the same registered clipboard format. Note that the comparison is case-insensitive.
    #   Registered clipboard formats are identified by values in the range 0xC000 through 0xFFFF.
    #   When registered clipboard formats are placed on or retrieved from the clipboard, they must be in the
    #   form of an HGLOBAL value.
    #
    # :call-seq:
    # register_clipboard_format( format_name )
    #
    function 'RegisterClipboardFormat', 'P', 'I', zeronil: true

    # DdeCallaback declaration
    # MSDN syntax: HDDEDATA CALLBACK DdeCallback( UINT uType, UINT uFmt, HCONV hconv, HDDEDATA hsz1, HDDEDATA hsz2,
    #                                             HDDEDATA hdata, HDDEDATA dwData1, HDDEDATA dwData2);
    callback :dde_callback, [:uint, :uint, :HCONV, :HDDEDATA, :HDDEDATA, :HDDEDATA, :HDDEDATA, :HDDEDATA], :HDDEDATA

    ##
    # The DdeInitialize function registers an application with the Dynamic Data Exchange Management Library (DDEML).
    # An application must call this function before calling any other DDEML function.
    #
    # Syntax: UINT DdeInitialize( LPDWORD pidInst, PFNCALLBACK pfnCallback, DWORD afCmd, DWORD ulRes );
    #
    # Params:
    #   pidInst (P) - [in, out] Pointer to the application instance identifier.
    #     At initialization, this parameter should point to 0. If the function succeeds, this parameter points to
    #     the instance identifier for the application. This value should be passed as the idInst parameter in all
    #     other DDEML functions that require it. If an application uses multiple instances of the DDEML dynamic-link
    #     library (DLL), the application should provide a different callback function for each instance.
    #     If pidInst points to a nonzero value, reinitialization of the DDEML is implied. In this case, pidInst must
    #     point to a valid application-instance identifier.
    #   pfnCallback (K) - [in] Pointer to the application-defined Dynamic Data Exchange (DDE) callback function.
    #     This function processes DDE transactions sent by the system. For more information, see the DdeCallback.
    #   afCmd (L) - [in] Specifies a set of APPCMD_, CBF_, and MF_ flags. The APPCMD_ flags provide special
    #     instructions to DdeInitialize. The CBF_ flags specify filters that prevent specific types of transactions
    #     from reaching the callback function. The MF_ flags specify the types of DDE activity that a DDE monitoring
    #     application monitors. Using these flags enhances the performance of a DDE application by eliminating
    #     unnecessary calls to the callback function. This parameter can be one or more of the following values:
    # APPCLASS_MONITOR, APPCLASS_STANDARD, APPCMD_CLIENTONLY, APPCMD_FILTERINITS, 
    # CBF_FAIL_ALLSVRXACTIONS, CBF_FAIL_ADVISES, CBF_FAIL_CONNECTIONS, CBF_FAIL_EXECUTES, CBF_FAIL_POKES
    # CBF_FAIL_REQUESTS, CBF_FAIL_SELFCONNECTIONS, CBF_SKIP_ALLNOTIFICATIONS, CBF_SKIP_CONNECT_CONFIRMS
    # CBF_SKIP_DISCONNECTS, CBF_SKIP_REGISTRATIONS, CBF_SKIP_UNREGISTRATIONS
    # MF_CALLBACKS, MF_CONV, MF_ERRORS, MF_HSZ_INFO, MF_LINKS, MF_POSTMSGS, MF_SENDMSGS
    #   ulRes (L) - Reserved; must be set to zero.
    #
    # Return Value:
    #  If the function succeeds, the return value is DMLERR_NO_ERROR.
    #  If the function fails, the return value is one of the following values:
    #     DMLERR_DLL_USAGE
    #     DMLERR_INVALIDPARAMETER
    #     DMLERR_SYS_ERROR
    #
    #  Remarks:
    #    An application that uses multiple instances of the DDEML must not pass DDEML objects between instances.
    #    A DDE monitoring application should not attempt to perform DDE operations (establish conversations,
    #    issue transactions, and so on) within the context of the same application instance. A synchronous
    #    transaction fails with a DMLERR_REENTRANCY error if any instance of the same task has a synchronous
    #    transaction already in progress. The CBF_FAIL_ALLSVRXACTIONS flag causes the DDEML to filter all server
    #    transactions and can be changed by a subsequent call to DdeInitialize. The APPCMD_CLIENTONLY flag prevents
    #    the DDEML from creating key resources for the server and cannot be changed by a subsequent call to
    #    DdeInitialize. There is an ANSI version and a Unicode version of DdeInitialize. The version called
    #    determines the type of the window procedures used to control DDE conversations (ANSI or Unicode),
    #    and the default value for the iCodePage member of the CONVCONTEXT structure (CP_WINANSI or CP_WINUNICODE).
    #
    # :call-seq:
    # id_inst, status = dde_initialize( id_inst = 0, cmd ) {|callback args| callback block}
    #
    function 'DdeInitialize', [:pointer, :dde_callback, :DWORD, :DWORD], :uint,
             &->(api, old_id=0, cmd, &block){
             raise ArgumentError, 'No callback block' unless block
             id = FFI::MemoryPointer.new(:long)
             id.write_long(old_id)
             status = api.call(id, block, cmd, 0)
             id = status == 0 ? id.read_long() : nil
             [id, status] }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

    ##
    # The DdeCreateStringHandle function creates a handle that identifies the specified string.
    # A Dynamic Data Exchange (DDE) client or server application can pass the string handle as a
    # parameter to other Dynamic Data Exchange Management Library (DDEML) functions.
    #
    # Syntax: HSZ DdeCreateStringHandle( DWORD idInst, LPTSTR psz, int iCodePage );
    #
    # Parameters:
    #   idInst (L) - [in] Specifies the application instance identifier obtained by a previous call to the
    #     DdeInitialize function.
    #   psz (P) - [in] Pointer to a buffer that contains the null-terminated string for which a handle
    #     is to be created. This string can be up to 255 characters. The reason for this limit is that
    #     DDEML string management functions are implemented using global atoms.
    #   iCodePage (I) -  [in] Specifies the code page used to render the string. This value should be either
    #     CP_WINANSI (the default code page) or CP_WINUNICODE, depending on whether the ANSI or Unicode
    #     version of DdeInitialize was called by the client application.
    #
    # Return Value (L) or nil: If the function succeeds, the return value is a string handle.
    #   If the function fails, the return value is 0(changed to nil in enhanced version).
    #   The DdeGetLastError function can be used to get the error code, which can be one of the following values:
    # DMLERR_NO_ERROR, DMLERR_INVALIDPARAMETER, DMLERR_SYS_ERROR
    #
    # Remarks: The value of a string handle is not related to the case of the string it identifies.
    #   When an application either creates a string handle or receives one in the callback function
    #   and then uses the DdeKeepStringHandle function to keep it, the application must free that string
    #   handle when it is no longer needed. An instance-specific string handle cannot be mapped from string
    #   handle to string and back to string handle.
    #
    function 'DdeCreateStringHandle', [:DWORD, :pointer, :int], :HSZ, zeronil: true

  end
end