require 'win/library'

module Win

  # Includes functions related to DDE exchange protocol in Windows
  #
  module DDE
    include Win::Library

    # Windows ANSI codepage:
    CP_WINANSI = 1004

    # DDE name service afCmd commands used by DdeNameService function:

    # Registers the service name.

    DNS_REGISTER = 1
    # Unregisters the service name. If the hsz1 parameter is 0L, all service names registered by the server will be unregistered.
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

    XTYP_CONNECT = 0x60
    XTYP_DISCONNECT = 0xC0
    XTYP_POKE = 0x90
    XTYP_ERROR = 0x00

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
    # [*Syntax*] UINT RegisterClipboardFormat( LPCTSTR lpszFormat )
    #
    # lpszFormat:: [in] Pointer to a null-terminated string that names the new format.
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
    # uType:: [in] Specifies the type of the current transaction. This parameter consists of a combination of
    #         transaction class flags and transaction type flags. The following table describes each of the
    #         transaction classes and provides a list of the transaction types in each class. For information
    #         about a specific transaction type, see the individual description of that type.
    #         - XCLASS_BOOL - A DDE callback function should return TRUE or FALSE when it finishes processing a
    #           transaction that belongs to this class. The XCLASS_BOOL class consists of the following types:
    #           - XTYP_ADVSTART
    #           - XTYP_CONNECT
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
    #           - XTYP_POKE
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
    # uFmt:: [in] Specifies the format in which data is sent or received.
    # hconv:: [in] Handle to the conversation associated with the current transaction.
    # hsz1:: [in] Handle to a string. The meaning of this parameter depends on the type of the current transaction.
    #        For the meaning of this parameter, see the description of the transaction type.
    # hsz2:: [in] Handle to a string. The meaning of this parameter depends on the type of the current transaction.
    #        For the meaning of this parameter, see the description of the transaction type.
    # hdata:: [in] Handle to DDE data. The meaning of this parameter depends on the type of the current transaction.
    #         For the meaning of this parameter, see the description of the transaction type.
    # dwData1:: [in] Specifies transaction-specific data. For the meaning, see the description of the transaction type.
    # dwData2:: [in] Specifies transaction-specific data. For the meaning, see the description of the transaction type.
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
    # pidInst:: [in, out] Pointer to the application instance identifier.
    #           At initialization, this parameter should point to 0. If the function succeeds, this parameter points
    #           to the instance identifier for the application. This value should be passed as the idInst parameter
    #           in all other DDEML functions that require it. If an application uses multiple instances of the DDEML
    #           dynamic-link library (DLL), the application should provide a different callback function for each
    #           instance. If pidInst points to a nonzero value, reinitialization of the DDEML is implied. In this
    #           case, pidInst must point to a valid application-instance identifier.
    # pfnCallback:: Pointer to the application-defined Dynamic Data Exchange DdeCallback function. This function
    #               processes DDE transactions sent by the system. For more information, see the DdeCallback.
    # afCmd:: [in] Specifies a set of APPCMD_, CBF_, and MF_ flags. The APPCMD_ flags provide special
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
    #  instance_id, status = dde_initialize( instance_id = 0, cmd )
    #  {|type, format, hconv, hsz1, hsz2, hdata, data1, data2| your dde_callback block}
    #
    function :DdeInitialize, [:pointer, :DdeCallback, :uint32, :uint32], :uint,
             &->(api, old_id=0, cmd, &block){
             raise ArgumentError, 'No callback block' unless block
             id = FFI::MemoryPointer.new(:long)
             id.write_long(old_id)
             status = api.call(id, block, cmd, 0)
             id = status == 0 ? id.read_long() : nil
             [id, status] }
    # weird lambda literal instead of block is needed because RDoc goes crazy if block is attached to meta-definition

    ##
    # The DdeUninitialize function frees all Dynamic Data Exchange Management Library (DDEML) resources associated
    # with the calling application.
    #
    # [*Syntax*] BOOL DdeUninitialize( DWORD idInst);
    #
    # idInst:: [in] Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
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
    # idInst:: [in] Specifies the application instance identifier obtained by a previous call to the
    #          DdeInitialize function.
    # psz:: [in] Pointer to a buffer that contains the null-terminated string for which a handle
    #       is to be created. This string can be up to 255 characters. The reason for this limit is that
    #       DDEML string management functions are implemented using global atoms.
    # iCodePage:: [in] Specifies the code page used to render the string. This value should be either
    #             CP_WINANSI (the default code page) or CP_WINUNICODE, depending on whether the ANSI or Unicode
    #             version of DdeInitialize was called by the client application.
    #
    # *Returns*:: (L) or nil: If the function succeeds, the return value is a string handle.
    #             If the function fails, the return value is 0(changed to nil in enhanced version).
    #             The DdeGetLastError function can be used to get the error code, which can be one of the
    #             following values: DMLERR_NO_ERROR, DMLERR_INVALIDPARAMETER, DMLERR_SYS_ERROR
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
    function :DdeCreateStringHandle, [:uint32, :pointer, :int], :ulong, zeronil: true

    ##
    # The DdeFreeStringHandle function frees a string handle in the calling application.
    #
    # [*Syntax*] BOOL DdeFreeStringHandle( DWORD idInst, HSZ hsz );
    #
    # idInst:: [in] Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # hsz:: [in, out] Handle to the string handle to be freed. This handle must have been created by a previous call
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
    # The DdeNameService function registers or unregisters the service names a Dynamic Data Exchange (DDE) server
    # supports. This function causes the system to send XTYP_REGISTER or XTYP_UNREGISTER transactions to other running
    # Dynamic Data Exchange Management Library (DDEML) client applications.
    #
    # [*Syntax*] HDDEDATA DdeNameService( DWORD idInst, UINT hsz1, UINT hsz2, UINT afCmd );
    #
    # idInst:: [in] Specifies the application instance identifier obtained by a previous call to the DdeInitialize.
    # hsz1:: [in] Handle to the string that specifies the service name the server is registering or unregistering.
    #        An application that is unregistering all of its service names should set this parameter to 0L.
    # hsz2:: Reserved; should be set to 0L.
    # afCmd:: [in] Specifies the service name options. This parameter can be one of the following values.
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


  end
end
