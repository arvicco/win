require 'win/library'

module Win

  # Defines functions and constants related to error processing.
  # Includes (some) error codes from error.h, msterr.h and winerror.h (up to 3000);
  # other modules may contain additional error codes specific to their domain.
  #
  module Error
    include Win::Library

    #Error codes:

    # :stopdoc:
    S_OK                      = 0
    NO_ERROR                  = 0
    ERROR_SUCCESS             = 0
    ERROR_INVALID_FUNCTION    = 1
    ERROR_FILE_NOT_FOUND      = 2
    ERROR_PATH_NOT_FOUND      = 3
    ERROR_TOO_MANY_OPEN_FILES = 4
    ERROR_ACCESS_DENIED       = 5
    ERROR_INVALID_HANDLE      = 6
    ERROR_ARENA_TRASHED       = 7
    ERROR_NOT_ENOUGH_MEMORY   = 8
    ERROR_INVALID_BLOCK       = 9
    ERROR_BAD_ENVIRONMENT     = 10
    ERROR_BAD_FORMAT          = 11
    ERROR_INVALID_ACCESS      = 12
    ERROR_INVALID_DATA        = 13
    ERROR_INVALID_DRIVE       = 15
    ERROR_CURRENT_DIRECTORY   = 16
    ERROR_NOT_SAME_DEVICE     = 17
    ERROR_NO_MORE_FILES       = 18
    ERROR_WRITE_PROTECT       = 19
    ERROR_BAD_UNIT            = 20
    ERROR_NOT_READY           = 21
    ERROR_BAD_COMMAND         = 22
    ERROR_CRC                 = 23
    ERROR_BAD_LENGTH          = 24
    ERROR_SEEK                = 25
    ERROR_NOT_DOS_DISK        = 26
    ERROR_SECTOR_NOT_FOUND    = 27
    ERROR_OUT_OF_PAPER        = 28
    ERROR_WRITE_FAULT         = 29
    ERROR_READ_FAULT          = 30
    ERROR_GEN_FAILURE         = 31
    ERROR_SHARING_VIOLATION   = 32
    ERROR_LOCK_VIOLATION      = 33
    ERROR_WRONG_DISK          = 34
    ERROR_FCB_UNAVAILABLE     = 35  # gets returned for some unsuccessful DeviceIoControl calls
    ERROR_SHARING_BUFFER_EXCEEDED = 36
    ERROR_HANDLE_EOF          = 38
    ERROR_HANDLE_DISK_FULL    = 39

    ERROR_NOT_SUPPORTED       = 50
    ERROR_REM_NOT_LIST        = 51
    ERROR_DUP_NAME            = 52
    ERROR_BAD_NETPATH         = 53
    ERROR_NETWORK_BUSY        = 54
    ERROR_DEV_NOT_EXIST       = 55
    ERROR_TOO_MANY_CMDS       = 56
    ERROR_ADAP_HDW_ERR        = 57
    ERROR_BAD_NET_RESP        = 58
    ERROR_UNEXP_NET_ERR       = 59
    ERROR_BAD_REM_ADAP        = 60
    ERROR_PRINTQ_FULL         = 61
    ERROR_NO_SPOOL_SPACE      = 62
    ERROR_PRINT_CANCELLED     = 63
    ERROR_NETNAME_DELETED     = 64
    ERROR_NETWORK_ACCESS_DENIED = 65
    ERROR_BAD_DEV_TYPE        = 66
    ERROR_BAD_NET_NAME        = 67
    ERROR_TOO_MANY_NAMES      = 68
    ERROR_TOO_MANY_SESS       = 69
    ERROR_SHARING_PAUSED      = 70
    ERROR_REQ_NOT_ACCEP       = 71
    ERROR_REDIR_PAUSED        = 72

    ERROR_FILE_EXISTS         = 80
    ERROR_DUP_FCB             = 81
    ERROR_CANNOT_MAKE         = 82
    ERROR_FAIL_I24            = 83
    ERROR_OUT_OF_STRUCTURES   = 84
    ERROR_ALREADY_ASSIGNED    = 85
    ERROR_INVALID_PASSWORD    = 86
    ERROR_INVALID_PARAMETER   = 87
    ERROR_NET_WRITE_FAULT     = 88
    ERROR_NO_PROC_SLOTS       = 89  # no process slots available
    ERROR_NOT_FROZEN          = 90
    ERR_TSTOVFL               = 91  # timer service table overflow
    ERR_TSTDUP                = 92  # timer service table duplicate
    ERROR_NO_ITEMS            = 93  # There were no items to operate upon
    ERROR_INTERRUPT           = 95  # interrupted system call

    ERROR_TOO_MANY_SEMAPHORES       = 100
    ERROR_EXCL_SEM_ALREADY_OWNED    = 101
    ERROR_SEM_IS_SET                = 102
    ERROR_TOO_MANY_SEM_REQUESTS     = 103
    ERROR_INVALID_AT_INTERRUPT_TIME = 104
    ERROR_SEM_OWNER_DIED            = 105 # waitsem found owner died
    ERROR_SEM_USER_LIMIT            = 106 # too many procs have this sem
    ERROR_DISK_CHANGE               = 107 # insert disk b into drive a
    ERROR_DRIVE_LOCKED              = 108 # drive locked by another process
    ERROR_BROKEN_PIPE               = 109 # write on pipe with no reader
    ERROR_OPEN_FAILED               = 110 # open/created failed
    ERROR_DISK_FULL                 = 112 # not enough space
    ERROR_NO_MORE_SEARCH_HANDLES    = 113 # can't allocate
    ERROR_INVALID_TARGET_HANDLE     = 114 # handle in DOSDUPHANDLE is invalid
    ERROR_PROTECTION_VIOLATION      = 115 # bad user virtual address
    ERROR_VIOKBD_REQUEST            = 116
    ERROR_INVALID_CATEGORY          = 117 # category for DEVIOCTL not defined
    ERROR_INVALID_VERIFY_SWITCH     = 118 # invalid value
    ERROR_BAD_DRIVER_LEVEL          = 119 # DosDevIOCTL not level four
    ERROR_CALL_NOT_IMPLEMENTED      = 120
    ERROR_SEM_TIMEOUT               = 121 # timeout from semaphore function
    ERROR_INSUFFICIENT_BUFFER       = 122
    ERROR_INVALID_NAME              = 123 # illegal char or malformed file system name
    ERROR_INVALID_LEVEL             = 124 # unimplemented level for info retrieval
    ERROR_NO_VOLUME_LABEL           = 125 # no volume label found
    ERROR_MOD_NOT_FOUND             = 126 # w_getprocaddr, w_getmodhandle
    ERROR_PROC_NOT_FOUND            = 127 # w_getprocaddr
    ERROR_WAIT_NO_CHILDREN          = 128 # CWait finds to children
    ERROR_CHILD_NOT_COMPLETE        = 129 # CWait children not dead yet
    ERROR_DIRECT_ACCESS_HANDLE      = 130 # invalid for direct disk access
    ERROR_NEGATIVE_SEEK             = 131 # tried to seek negative offset
    ERROR_SEEK_ON_DEVICE            = 132 # tried to seek on device or pipe
    ERROR_IS_JOIN_TARGET            = 133
    ERROR_IS_JOINED                 = 134
    ERROR_IS_SUBSTED                = 135
    ERROR_NOT_JOINED                = 136
    ERROR_NOT_SUBSTED               = 137
    ERROR_JOIN_TO_JOIN              = 138
    ERROR_SUBST_TO_SUBST            = 139
    ERROR_JOIN_TO_SUBST             = 140
    ERROR_SUBST_TO_JOIN             = 141
    ERROR_BUSY_DRIVE                = 142
    ERROR_SAME_DRIVE                = 143
    ERROR_DIR_NOT_ROOT              = 144
    ERROR_DIR_NOT_EMPTY             = 145
    ERROR_IS_SUBST_PATH             = 146
    ERROR_IS_JOIN_PATH              = 147
    ERROR_PATH_BUSY                 = 148
    ERROR_IS_SUBST_TARGET           = 149
    ERROR_SYSTEM_TRACE              = 150 # system trace error
    ERROR_INVALID_EVENT_COUNT       = 151 # DosMuxSemWait errors
    ERROR_TOO_MANY_MUXWAITERS       = 152
    ERROR_INVALID_LIST_FORMAT       = 153
    ERROR_LABEL_TOO_LONG            = 154
    ERROR_TOO_MANY_TCBS             = 155
    ERROR_SIGNAL_REFUSED            = 156
    ERROR_DISCARDED                 = 157
    ERROR_NOT_LOCKED                = 158
    ERROR_BAD_THREADID_ADDR         = 159
    ERROR_BAD_ARGUMENTS             = 160
    ERROR_BAD_PATHNAME              = 161
    ERROR_SIGNAL_PENDING            = 162
    ERROR_UNCERTAIN_MEDIA           = 163
    ERROR_MAX_THRDS_REACHED         = 164
    ERROR_MONITORS_NOT_SUPPORTED    = 165

    ERROR_LOCK_FAILED               = 167
    ERROR_BUSY                      = 170
    ERROR_CANCEL_VIOLATION          = 173
    ERROR_ATOMIC_LOCKS_NOT_SUPPORTED= 174

    ERROR_INVALID_SEGMENT_NUMBER    = 180
    ERROR_INVALID_CALLGATE          = 181
    ERROR_INVALID_ORDINAL           = 182
    ERROR_ALREADY_EXISTS            = 183
    ERROR_NO_CHILD_PROCESS          = 184
    ERROR_CHILD_ALIVE_NOWAIT        = 185
    ERROR_INVALID_FLAG_NUMBER       = 186
    ERROR_SEM_NOT_FOUND             = 187
    ERROR_INVALID_STARTING_CODESEG  = 188
    ERROR_INVALID_STACKSEG          = 189
    ERROR_INVALID_MODULETYPE        = 190
    ERROR_INVALID_EXE_SIGNATURE     = 191
    ERROR_EXE_MARKED_INVALID        = 192
    ERROR_BAD_EXE_FORMAT            = 193
    ERROR_ITERATED_DATA_EXCEEDS_64k = 194
    ERROR_INVALID_MINALLOCSIZE      = 195
    ERROR_DYNLINK_FROM_INVALID_RING = 196
    ERROR_IOPL_NOT_ENABLED          = 197
    ERROR_INVALID_SEGDPL            = 198
    ERROR_AUTODATASEG_EXCEEDS_64k   = 199
    ERROR_RING2SEG_MUST_BE_MOVABLE  = 200
    ERROR_RELOC_CHAIN_XEEDS_SEGLIM  = 201
    ERROR_INFLOOP_IN_RELOC_CHAIN    = 202
    ERROR_ENVVAR_NOT_FOUND          = 203
    ERROR_NOT_CURRENT_CTRY          = 204
    ERROR_NO_SIGNAL_SENT            = 205
    ERROR_FILENAME_EXCED_RANGE      = 206 # if filename > 8.3
    ERROR_RING2_STACK_IN_USE        = 207 # for FAPI
    ERROR_META_EXPANSION_TOO_LONG   = 208 # if "*a" > 8.3
    ERROR_INVALID_SIGNAL_NUMBER     = 209
    ERROR_THREAD_1_INACTIVE         = 210
    ERROR_INFO_NOT_AVAIL            = 211 #@@ PTM 5550
    ERROR_LOCKED                    = 212
    ERROR_BAD_DYNALINK              = 213 #@@ PTM 5760
    ERROR_TOO_MANY_MODULES          = 214
    ERROR_NESTING_NOT_ALLOWED       = 215
    ERROR_EXE_MACHINE_TYPE_MISMATCH = 216

    ERROR_BAD_PIPE                  = 230
    ERROR_PIPE_BUSY                 = 231
    ERROR_NO_DATA                   = 232
    ERROR_PIPE_NOT_CONNECTED        = 233
    ERROR_MORE_DATA                 = 234

    ERROR_VC_DISCONNECTED           = 240
    ERROR_INVALID_EA_NAME           = 254
    ERROR_EA_LIST_INCONSISTENT      = 255
    ERROR_NO_MORE_ITEMS             = 259
    ERROR_CANNOT_COPY               = 266
    ERROR_DIRECTORY                 = 267
    ERROR_EAS_DIDNT_FIT             = 275
    ERROR_EA_FILE_CORRUPT           = 276
    ERROR_EA_TABLE_FULL             = 277
    ERROR_INVALID_EA_HANDLE         = 278
    ERROR_EAS_NOT_SUPPORTED         = 282
    ERROR_NOT_OWNER                 = 288
    ERROR_TOO_MANY_POSTS            = 298
    ERROR_PARTIAL_COPY              = 299
    ERROR_OPLOCK_NOT_GRANTED        = 300
    ERROR_INVALID_OPLOCK_PROTOCOL   = 301
    ERROR_DISK_TOO_FRAGMENTED       = 302
    ERROR_MR_MID_NOT_FOUND          = 317
    ERROR_SCOPE_NOT_FOUND           = 318
    ERROR_FAIL_NOACTION_REBOOT      = 350
    ERROR_FAIL_SHUTDOWN             = 351
    ERROR_FAIL_RESTART              = 352
    ERROR_MAX_SESSIONS_REACHED      = 353
    ERROR_INVALID_ADDRESS           = 487
    ERROR_USER_PROFILE_LOAD         = 500
    ERROR_ARITHMETIC_OVERFLOW       = 534
    ERROR_PIPE_CONNECTED            = 535
    ERROR_PIPE_LISTENING            = 536

    ERROR_EA_ACCESS_DENIED          = 994
    ERROR_OPERATION_ABORTED         = 995
    ERROR_IO_INCOMPLETE             = 996
    ERROR_IO_PENDING                = 997
    ERROR_NOACCESS                  = 998
    ERROR_SWAPERROR                 = 999

    ERROR_STACK_OVERFLOW                  = 1001
    ERROR_INVALID_MESSAGE                 = 1002
    ERROR_CAN_NOT_COMPLETE                = 1003
    ERROR_INVALID_FLAGS                   = 1004
    ERROR_UNRECOGNIZED_VOLUME             = 1005
    ERROR_FILE_INVALID                    = 1006
    ERROR_FULLSCREEN_MODE                 = 1007
    ERROR_NO_TOKEN                        = 1008
    ERROR_BADDB                           = 1009
    ERROR_BADKEY                          = 1010
    ERROR_CANTOPEN                        = 1011
    ERROR_CANTREAD                        = 1012
    ERROR_CANTWRITE                       = 1013
    ERROR_REGISTRY_RECOVERED              = 1014
    ERROR_REGISTRY_CORRUPT                = 1015
    ERROR_REGISTRY_IO_FAILED              = 1016
    ERROR_NOT_REGISTRY_FILE               = 1017
    ERROR_KEY_DELETED                     = 1018
    ERROR_NO_LOG_SPACE                    = 1019
    ERROR_KEY_HAS_CHILDREN                = 1020
    ERROR_CHILD_MUST_BE_VOLATILE          = 1021
    ERROR_NOTIFY_ENUM_DIR                 = 1022
    ERROR_DEPENDENT_SERVICES_RUNNING      = 1051
    ERROR_INVALID_SERVICE_CONTROL         = 1052
    ERROR_SERVICE_REQUEST_TIMEOUT         = 1053
    ERROR_SERVICE_NO_THREAD               = 1054
    ERROR_SERVICE_DATABASE_LOCKED         = 1055
    ERROR_SERVICE_ALREADY_RUNNING         = 1056
    ERROR_INVALID_SERVICE_ACCOUNT         = 1057
    ERROR_SERVICE_DISABLED                = 1058
    ERROR_CIRCULAR_DEPENDENCY             = 1059
    ERROR_SERVICE_DOES_NOT_EXIST          = 1060
    ERROR_SERVICE_CANNOT_ACCEPT_CTRL      = 1061
    ERROR_SERVICE_NOT_ACTIVE              = 1062
    ERROR_FAILED_SERVICE_CONTROLLER_CONNECT = 1063
    ERROR_EXCEPTION_IN_SERVICE            = 1064
    ERROR_DATABASE_DOES_NOT_EXIST         = 1065
    ERROR_SERVICE_SPECIFIC_ERROR          = 1066
    ERROR_PROCESS_ABORTED                 = 1067
    ERROR_SERVICE_DEPENDENCY_FAIL         = 1068
    ERROR_SERVICE_LOGON_FAILED            = 1069
    ERROR_SERVICE_START_HANG              = 1070
    ERROR_INVALID_SERVICE_LOCK            = 1071
    ERROR_SERVICE_MARKED_FOR_DELETE       = 1072
    ERROR_SERVICE_EXISTS                  = 1073
    ERROR_ALREADY_RUNNING_LKG             = 1074
    ERROR_SERVICE_DEPENDENCY_DELETED      = 1075
    ERROR_BOOT_ALREADY_ACCEPTED           = 1076
    ERROR_SERVICE_NEVER_STARTED           = 1077
    ERROR_DUPLICATE_SERVICE_NAME          = 1078
    ERROR_DIFFERENT_SERVICE_ACCOUNT       = 1079
    ERROR_CANNOT_DETECT_DRIVER_FAILURE    = 1080
    ERROR_CANNOT_DETECT_PROCESS_ABORT     = 1081
    ERROR_NO_RECOVERY_PROGRAM             = 1082
    ERROR_SERVICE_NOT_IN_EXE              = 1083
    ERROR_END_OF_MEDIA                    = 1100
    ERROR_FILEMARK_DETECTED               = 1101
    ERROR_BEGINNING_OF_MEDIA              = 1102
    ERROR_SETMARK_DETECTED                = 1103
    ERROR_NO_DATA_DETECTED                = 1104
    ERROR_PARTITION_FAILURE               = 1105
    ERROR_INVALID_BLOCK_LENGTH            = 1106
    ERROR_DEVICE_NOT_PARTITIONED          = 1107
    ERROR_UNABLE_TO_LOCK_MEDIA            = 1108
    ERROR_UNABLE_TO_UNLOAD_MEDIA          = 1109
    ERROR_MEDIA_CHANGED                   = 1110
    ERROR_BUS_RESET                       = 1111
    ERROR_NO_MEDIA_IN_DRIVE               = 1112
    ERROR_NO_UNICODE_TRANSLATION          = 1113
    ERROR_DLL_INIT_FAILED                 = 1114
    ERROR_SHUTDOWN_IN_PROGRESS            = 1115
    ERROR_NO_SHUTDOWN_IN_PROGRESS         = 1116
    ERROR_IO_DEVICE                       = 1117
    ERROR_SERIAL_NO_DEVICE                = 1118
    ERROR_IRQ_BUSY                        = 1119
    ERROR_MORE_WRITES                     = 1120
    ERROR_COUNTER_TIMEOUT                 = 1121
    ERROR_FLOPPY_ID_MARK_NOT_FOUND        = 1122
    ERROR_FLOPPY_WRONG_CYLINDER           = 1123
    ERROR_FLOPPY_UNKNOWN_ERROR            = 1124
    ERROR_FLOPPY_BAD_REGISTERS            = 1125
    ERROR_DISK_RECALIBRATE_FAILED         = 1126
    ERROR_DISK_OPERATION_FAILED           = 1127
    ERROR_DISK_RESET_FAILED               = 1128
    ERROR_EOM_OVERFLOW                    = 1129
    ERROR_NOT_ENOUGH_SERVER_MEMORY        = 1130
    ERROR_POSSIBLE_DEADLOCK               = 1131
    ERROR_MAPPED_ALIGNMENT                = 1132
    ERROR_SET_POWER_STATE_VETOED          = 1140
    ERROR_SET_POWER_STATE_FAILED          = 1141
    ERROR_TOO_MANY_LINKS                  = 1142
    ERROR_OLD_WIN_VERSION                 = 1150
    ERROR_APP_WRONG_OS                    = 1151
    ERROR_SINGLE_INSTANCE_APP             = 1152
    ERROR_RMODE_APP                       = 1153
    ERROR_INVALID_DLL                     = 1154
    ERROR_NO_ASSOCIATION                  = 1155
    ERROR_DDE_FAIL                        = 1156
    ERROR_DLL_NOT_FOUND                   = 1157
    ERROR_NO_MORE_USER_HANDLES            = 1158
    ERROR_MESSAGE_SYNC_ONLY               = 1159
    ERROR_SOURCE_ELEMENT_EMPTY            = 1160
    ERROR_DESTINATION_ELEMENT_FULL        = 1161
    ERROR_ILLEGAL_ELEMENT_ADDRESS         = 1162
    ERROR_MAGAZINE_NOT_PRESENT            = 1163
    ERROR_DEVICE_REINITIALIZATION_NEEDED  = 1164
    ERROR_DEVICE_REQUIRES_CLEANING        = 1165
    ERROR_DEVICE_DOOR_OPEN                = 1166
    ERROR_DEVICE_NOT_CONNECTED            = 1167
    ERROR_NOT_FOUND                       = 1168
    ERROR_NO_MATCH                        = 1169
    ERROR_SET_NOT_FOUND                   = 1170
    ERROR_POINT_NOT_FOUND                 = 1171
    ERROR_NO_TRACKING_SERVICE             = 1172
    ERROR_NO_VOLUME_ID                    = 1173
    ERROR_UNABLE_TO_REMOVE_REPLACED       = 1175
    ERROR_UNABLE_TO_MOVE_REPLACEMENT      = 1176
    ERROR_UNABLE_TO_MOVE_REPLACEMENT_2    = 1177
    ERROR_JOURNAL_DELETE_IN_PROGRESS      = 1178
    ERROR_JOURNAL_NOT_ACTIVE              = 1179
    ERROR_POTENTIAL_FILE_FOUND            = 1180
    ERROR_JOURNAL_ENTRY_DELETED           = 1181
    ERROR_BAD_DEVICE                      = 1200
    ERROR_CONNECTION_UNAVAIL              = 1201
    ERROR_DEVICE_ALREADY_REMEMBERED       = 1202
    ERROR_NO_NET_OR_BAD_PATH              = 1203
    ERROR_BAD_PROVIDER                    = 1204
    ERROR_CANNOT_OPEN_PROFILE             = 1205
    ERROR_BAD_PROFILE                     = 1206
    ERROR_NOT_CONTAINER                   = 1207
    ERROR_EXTENDED_ERROR                  = 1208
    ERROR_INVALID_GROUPNAME               = 1209
    ERROR_INVALID_COMPUTERNAME            = 1210
    ERROR_INVALID_EVENTNAME               = 1211
    ERROR_INVALID_DOMAINNAME              = 1212
    ERROR_INVALID_SERVICENAME             = 1213
    ERROR_INVALID_NETNAME                 = 1214
    ERROR_INVALID_SHARENAME               = 1215
    ERROR_INVALID_PASSWORDNAME            = 1216
    ERROR_INVALID_MESSAGENAME             = 1217
    ERROR_INVALID_MESSAGEDEST             = 1218
    ERROR_SESSION_CREDENTIAL_CONFLICT     = 1219
    ERROR_REMOTE_SESSION_LIMIT_EXCEEDED   = 1220
    ERROR_DUP_DOMAINNAME                  = 1221
    ERROR_NO_NETWORK                      = 1222
    ERROR_CANCELLED                       = 1223
    ERROR_USER_MAPPED_FILE                = 1224
    ERROR_CONNECTION_REFUSED              = 1225
    ERROR_GRACEFUL_DISCONNECT             = 1226
    ERROR_ADDRESS_ALREADY_ASSOCIATED      = 1227
    ERROR_ADDRESS_NOT_ASSOCIATED          = 1228
    ERROR_CONNECTION_INVALID              = 1229
    ERROR_CONNECTION_ACTIVE               = 1230
    ERROR_NETWORK_UNREACHABLE             = 1231
    ERROR_HOST_UNREACHABLE                = 1232
    ERROR_PROTOCOL_UNREACHABLE            = 1233
    ERROR_PORT_UNREACHABLE                = 1234
    ERROR_REQUEST_ABORTED                 = 1235
    ERROR_CONNECTION_ABORTED              = 1236
    ERROR_RETRY                           = 1237
    ERROR_CONNECTION_COUNT_LIMIT          = 1238
    ERROR_LOGIN_TIME_RESTRICTION          = 1239
    ERROR_LOGIN_WKSTA_RESTRICTION         = 1240
    ERROR_INCORRECT_ADDRESS               = 1241
    ERROR_ALREADY_REGISTERED              = 1242
    ERROR_SERVICE_NOT_FOUND               = 1243
    ERROR_NOT_AUTHENTICATED               = 1244
    ERROR_NOT_LOGGED_ON                   = 1245
    ERROR_CONTINUE                        = 1246
    ERROR_ALREADY_INITIALIZED             = 1247
    ERROR_NO_MORE_DEVICES                 = 1248
    ERROR_NO_SUCH_SITE                    = 1249
    ERROR_DOMAIN_CONTROLLER_EXISTS        = 1250
    ERROR_ONLY_IF_CONNECTED               = 1251
    ERROR_OVERRIDE_NOCHANGES              = 1252
    ERROR_BAD_USER_PROFILE                = 1253
    ERROR_NOT_SUPPORTED_ON_SBS            = 1254
    ERROR_SERVER_SHUTDOWN_IN_PROGRESS     = 1255
    ERROR_HOST_DOWN                       = 1256
    ERROR_ACCESS_DISABLED_BY_POLICY       = 1260
    ERROR_REG_NAT_CONSUMPTION             = 1261
    ERROR_PKINIT_FAILURE                  = 1263
    ERROR_SMARTCARD_SUBSYSTEM_FAILURE     = 1264
    ERROR_DOWNGRADE_DETECTED              = 1265
    ERROR_MACHINE_LOCKED                  = 1271
    ERROR_CALLBACK_SUPPLIED_INVALID_DATA  = 1273
    ERROR_SYNC_FOREGROUND_REFRESH_REQUIRED= 1274
    ERROR_DRIVER_BLOCKED                  = 1275
    ERROR_INVALID_IMPORT_OF_NON_DLL       = 1276
    ERROR_NOT_ALL_ASSIGNED                = 1300
    ERROR_SOME_NOT_MAPPED                 = 1301
    ERROR_NO_QUOTAS_FOR_ACCOUNT           = 1302
    ERROR_LOCAL_USER_SESSION_KEY          = 1303
    ERROR_NULL_LM_PASSWORD                = 1304
    ERROR_UNKNOWN_REVISION                = 1305
    ERROR_REVISION_MISMATCH               = 1306
    ERROR_INVALID_OWNER                   = 1307
    ERROR_INVALID_PRIMARY_GROUP           = 1308
    ERROR_NO_IMPERSONATION_TOKEN          = 1309
    ERROR_CANT_DISABLE_MANDATORY          = 1310
    ERROR_NO_LOGON_SERVERS                = 1311
    ERROR_NO_SUCH_LOGON_SESSION           = 1312
    ERROR_NO_SUCH_PRIVILEGE               = 1313
    ERROR_PRIVILEGE_NOT_HELD              = 1314
    ERROR_INVALID_ACCOUNT_NAME            = 1315
    ERROR_USER_EXISTS                     = 1316
    ERROR_NO_SUCH_USER                    = 1317
    ERROR_GROUP_EXISTS                    = 1318
    ERROR_NO_SUCH_GROUP                   = 1319
    ERROR_MEMBER_IN_GROUP                 = 1320
    ERROR_MEMBER_NOT_IN_GROUP             = 1321
    ERROR_LAST_ADMIN                      = 1322
    ERROR_WRONG_PASSWORD                  = 1323
    ERROR_ILL_FORMED_PASSWORD             = 1324
    ERROR_PASSWORD_RESTRICTION            = 1325
    ERROR_LOGON_FAILURE                   = 1326
    ERROR_ACCOUNT_RESTRICTION             = 1327
    ERROR_INVALID_LOGON_HOURS             = 1328
    ERROR_INVALID_WORKSTATION             = 1329
    ERROR_PASSWORD_EXPIRED                = 1330
    ERROR_ACCOUNT_DISABLED                = 1331
    ERROR_NONE_MAPPED                     = 1332
    ERROR_TOO_MANY_LUIDS_REQUESTED        = 1333
    ERROR_LUIDS_EXHAUSTED                 = 1334
    ERROR_INVALID_SUB_AUTHORITY           = 1335
    ERROR_INVALID_ACL                     = 1336
    ERROR_INVALID_SID                     = 1337
    ERROR_INVALID_SECURITY_DESCR          = 1338
    ERROR_BAD_INHERITANCE_ACL             = 1340
    ERROR_SERVER_DISABLED                 = 1341
    ERROR_SERVER_NOT_DISABLED             = 1342
    ERROR_INVALID_ID_AUTHORITY            = 1343
    ERROR_ALLOTTED_SPACE_EXCEEDED         = 1344
    ERROR_INVALID_GROUP_ATTRIBUTES        = 1345
    ERROR_BAD_IMPERSONATION_LEVEL         = 1346
    ERROR_CANT_OPEN_ANONYMOUS             = 1347
    ERROR_BAD_VALIDATION_CLASS            = 1348
    ERROR_BAD_TOKEN_TYPE                  = 1349
    ERROR_NO_SECURITY_ON_OBJECT           = 1350
    ERROR_CANT_ACCESS_DOMAIN_INFO         = 1351
    ERROR_INVALID_SERVER_STATE            = 1352
    ERROR_INVALID_DOMAIN_STATE            = 1353
    ERROR_INVALID_DOMAIN_ROLE             = 1354
    ERROR_NO_SUCH_DOMAIN                  = 1355
    ERROR_DOMAIN_EXISTS                   = 1356
    ERROR_DOMAIN_LIMIT_EXCEEDED           = 1357
    ERROR_INTERNAL_DB_CORRUPTION          = 1358
    ERROR_INTERNAL_ERROR                  = 1359
    ERROR_GENERIC_NOT_MAPPED              = 1360
    ERROR_BAD_DESCRIPTOR_FORMAT           = 1361
    ERROR_NOT_LOGON_PROCESS               = 1362
    ERROR_LOGON_SESSION_EXISTS            = 1363
    ERROR_NO_SUCH_PACKAGE                 = 1364
    ERROR_BAD_LOGON_SESSION_STATE         = 1365
    ERROR_LOGON_SESSION_COLLISION         = 1366
    ERROR_INVALID_LOGON_TYPE              = 1367
    ERROR_CANNOT_IMPERSONATE              = 1368
    ERROR_RXACT_INVALID_STATE             = 1369
    ERROR_RXACT_COMMIT_FAILURE            = 1370
    ERROR_SPECIAL_ACCOUNT                 = 1371
    ERROR_SPECIAL_GROUP                   = 1372
    ERROR_SPECIAL_USER                    = 1373
    ERROR_MEMBERS_PRIMARY_GROUP           = 1374
    ERROR_TOKEN_ALREADY_IN_USE            = 1375
    ERROR_NO_SUCH_ALIAS                   = 1376
    ERROR_MEMBER_NOT_IN_ALIAS             = 1377
    ERROR_MEMBER_IN_ALIAS                 = 1378
    ERROR_ALIAS_EXISTS                    = 1379
    ERROR_LOGON_NOT_GRANTED               = 1380
    ERROR_TOO_MANY_SECRETS                = 1381
    ERROR_SECRET_TOO_LONG                 = 1382
    ERROR_INTERNAL_DB_ERROR               = 1383
    ERROR_TOO_MANY_CONTEXT_IDS            = 1384
    ERROR_LOGON_TYPE_NOT_GRANTED          = 1385
    ERROR_NT_CROSS_ENCRYPTION_REQUIRED    = 1386
    ERROR_NO_SUCH_MEMBER                  = 1387
    ERROR_INVALID_MEMBER                  = 1388
    ERROR_TOO_MANY_SIDS                   = 1389
    ERROR_LM_CROSS_ENCRYPTION_REQUIRED    = 1390
    ERROR_NO_INHERITANCE                  = 1391
    ERROR_FILE_CORRUPT                    = 1392
    ERROR_DISK_CORRUPT                    = 1393
    ERROR_NO_USER_SESSION_KEY             = 1394
    ERROR_LICENSE_QUOTA_EXCEEDED          = 1395
    ERROR_WRONG_TARGET_NAME               = 1396
    ERROR_MUTUAL_AUTH_FAILED              = 1397
    ERROR_TIME_SKEW                       = 1398
    ERROR_CURRENT_DOMAIN_NOT_ALLOWED      = 1399
    ERROR_INVALID_WINDOW_HANDLE           = 1400
    ERROR_INVALID_MENU_HANDLE             = 1401
    ERROR_INVALID_CURSOR_HANDLE           = 1402
    ERROR_INVALID_ACCEL_HANDLE            = 1403
    ERROR_INVALID_HOOK_HANDLE             = 1404
    ERROR_INVALID_DWP_HANDLE              = 1405
    ERROR_TLW_WITH_WSCHILD                = 1406
    ERROR_CANNOT_FIND_WND_CLASS           = 1407
    ERROR_WINDOW_OF_OTHER_THREAD          = 1408
    ERROR_HOTKEY_ALREADY_REGISTERED       = 1409
    ERROR_CLASS_ALREADY_EXISTS            = 1410
    ERROR_CLASS_DOES_NOT_EXIST            = 1411
    ERROR_CLASS_HAS_WINDOWS               = 1412
    ERROR_INVALID_INDEX                   = 1413
    ERROR_INVALID_ICON_HANDLE             = 1414
    ERROR_PRIVATE_DIALOG_INDEX            = 1415
    ERROR_LISTBOX_ID_NOT_FOUND            = 1416
    ERROR_NO_WILDCARD_CHARACTERS          = 1417
    ERROR_CLIPBOARD_NOT_OPEN              = 1418
    ERROR_HOTKEY_NOT_REGISTERED           = 1419
    ERROR_WINDOW_NOT_DIALOG               = 1420
    ERROR_CONTROL_ID_NOT_FOUND            = 1421
    ERROR_INVALID_COMBOBOX_MESSAGE        = 1422
    ERROR_WINDOW_NOT_COMBOBOX             = 1423
    ERROR_INVALID_EDIT_HEIGHT             = 1424
    ERROR_DC_NOT_FOUND                    = 1425
    ERROR_INVALID_HOOK_FILTER             = 1426
    ERROR_INVALID_FILTER_PROC             = 1427
    ERROR_HOOK_NEEDS_HMOD                 = 1428
    ERROR_GLOBAL_ONLY_HOOK                = 1429
    ERROR_JOURNAL_HOOK_SET                = 1430
    ERROR_HOOK_NOT_INSTALLED              = 1431
    ERROR_INVALID_LB_MESSAGE              = 1432
    ERROR_SETCOUNT_ON_BAD_LB              = 1433
    ERROR_LB_WITHOUT_TABSTOPS             = 1434
    ERROR_DESTROY_OBJECT_OF_OTHER_THREAD  = 1435
    ERROR_CHILD_WINDOW_MENU               = 1436
    ERROR_NO_SYSTEM_MENU                  = 1437
    ERROR_INVALID_MSGBOX_STYLE            = 1438
    ERROR_INVALID_SPI_VALUE               = 1439
    ERROR_SCREEN_ALREADY_LOCKED           = 1440
    ERROR_HWNDS_HAVE_DIFF_PARENT          = 1441
    ERROR_NOT_CHILD_WINDOW                = 1442
    ERROR_INVALID_GW_COMMAND              = 1443
    ERROR_INVALID_THREAD_ID               = 1444
    ERROR_NON_MDICHILD_WINDOW             = 1445
    ERROR_POPUP_ALREADY_ACTIVE            = 1446
    ERROR_NO_SCROLLBARS                   = 1447
    ERROR_INVALID_SCROLLBAR_RANGE         = 1448
    ERROR_INVALID_SHOWWIN_COMMAND         = 1449
    ERROR_NO_SYSTEM_RESOURCES             = 1450
    ERROR_NONPAGED_SYSTEM_RESOURCES       = 1451
    ERROR_PAGED_SYSTEM_RESOURCES          = 1452
    ERROR_WORKING_SET_QUOTA               = 1453
    ERROR_PAGEFILE_QUOTA                  = 1454
    ERROR_COMMITMENT_LIMIT                = 1455
    ERROR_MENU_ITEM_NOT_FOUND             = 1456
    ERROR_INVALID_KEYBOARD_HANDLE         = 1457
    ERROR_HOOK_TYPE_NOT_ALLOWED           = 1458
    ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION = 1459
    ERROR_TIMEOUT                         = 1460
    ERROR_INVALID_MONITOR_HANDLE          = 1461
    ERROR_EVENTLOG_FILE_CORRUPT           = 1500
    ERROR_EVENTLOG_CANT_START             = 1501
    ERROR_LOG_FILE_FULL                   = 1502
    ERROR_EVENTLOG_FILE_CHANGED           = 1503
    ERROR_INVALID_TASK_NAME               = 1550
    ERROR_INVALID_TASK_INDEX              = 1551
    ERROR_THREAD_ALREADY_IN_TASK          = 1552
    ERROR_INSTALL_SERVICE_FAILURE         = 1601
    ERROR_INSTALL_USEREXIT                = 1602
    ERROR_INSTALL_FAILURE                 = 1603
    ERROR_INSTALL_SUSPEND                 = 1604
    ERROR_UNKNOWN_PRODUCT                 = 1605
    ERROR_UNKNOWN_FEATURE                 = 1606
    ERROR_UNKNOWN_COMPONENT               = 1607
    ERROR_UNKNOWN_PROPERTY                = 1608
    ERROR_INVALID_HANDLE_STATE            = 1609
    ERROR_BAD_CONFIGURATION               = 1610
    ERROR_INDEX_ABSENT                    = 1611
    ERROR_INSTALL_SOURCE_ABSENT           = 1612
    ERROR_INSTALL_PACKAGE_VERSION         = 1613
    ERROR_PRODUCT_UNINSTALLED             = 1614
    ERROR_BAD_QUERY_SYNTAX                = 1615
    ERROR_INVALID_FIELD                   = 1616
    ERROR_DEVICE_REMOVED                  = 1617
    ERROR_INSTALL_ALREADY_RUNNING         = 1618
    ERROR_INSTALL_PACKAGE_OPEN_FAILED     = 1619
    ERROR_INSTALL_PACKAGE_INVALID         = 1620
    ERROR_INSTALL_UI_FAILURE              = 1621
    ERROR_INSTALL_LOG_FAILURE             = 1622
    ERROR_INSTALL_LANGUAGE_UNSUPPORTED    = 1623
    ERROR_INSTALL_TRANSFORM_FAILURE       = 1624
    ERROR_INSTALL_PACKAGE_REJECTED        = 1625
    ERROR_FUNCTION_NOT_CALLED             = 1626
    ERROR_FUNCTION_FAILED                 = 1627
    ERROR_INVALID_TABLE                   = 1628
    ERROR_DATATYPE_MISMATCH               = 1629
    ERROR_UNSUPPORTED_TYPE                = 1630
    ERROR_CREATE_FAILED                   = 1631
    ERROR_INSTALL_TEMP_UNWRITABLE         = 1632
    ERROR_INSTALL_PLATFORM_UNSUPPORTED    = 1633
    ERROR_INSTALL_NOTUSED                 = 1634
    ERROR_PATCH_PACKAGE_OPEN_FAILED       = 1635
    ERROR_PATCH_PACKAGE_INVALID           = 1636
    ERROR_PATCH_PACKAGE_UNSUPPORTED       = 1637
    ERROR_PRODUCT_VERSION                 = 1638
    ERROR_INVALID_COMMAND_LINE            = 1639
    ERROR_INSTALL_REMOTE_DISALLOWED       = 1640
    ERROR_SUCCESS_REBOOT_INITIATED        = 1641
    ERROR_UNKNOWN_PATCH                   = 1647
    RPC_S_INVALID_STRING_BINDING          = 1700
    RPC_S_WRONG_KIND_OF_BINDING           = 1701
    RPC_S_INVALID_BINDING                 = 1702
    RPC_S_PROTSEQ_NOT_SUPPORTED           = 1703
    RPC_S_INVALID_RPC_PROTSEQ             = 1704
    RPC_S_INVALID_STRING_UUID             = 1705
    RPC_S_INVALID_ENDPOINT_FORMAT         = 1706
    RPC_S_INVALID_NET_ADDR                = 1707
    RPC_S_NO_ENDPOINT_FOUND               = 1708
    RPC_S_INVALID_TIMEOUT                 = 1709
    RPC_S_OBJECT_NOT_FOUND                = 1710
    RPC_S_ALREADY_REGISTERED              = 1711
    RPC_S_TYPE_ALREADY_REGISTERED         = 1712
    RPC_S_ALREADY_LISTENING               = 1713
    RPC_S_NO_PROTSEQS_REGISTERED          = 1714
    RPC_S_NOT_LISTENING                   = 1715
    RPC_S_UNKNOWN_MGR_TYPE                = 1716
    RPC_S_UNKNOWN_IF                      = 1717
    RPC_S_NO_BINDINGS                     = 1718
    RPC_S_NO_PROTSEQS                     = 1719
    RPC_S_CANT_CREATE_ENDPOINT            = 1720
    RPC_S_OUT_OF_RESOURCES                = 1721
    RPC_S_SERVER_UNAVAILABLE              = 1722
    RPC_S_SERVER_TOO_BUSY                 = 1723
    RPC_S_INVALID_NETWORK_OPTIONS         = 1724
    RPC_S_NO_CALL_ACTIVE                  = 1725
    RPC_S_CALL_FAILED                     = 1726
    RPC_S_CALL_FAILED_DNE                 = 1727
    RPC_S_PROTOCOL_ERROR                  = 1728
    RPC_S_UNSUPPORTED_TRANS_SYN           = 1730
    RPC_S_UNSUPPORTED_TYPE                = 1732
    RPC_S_INVALID_TAG                     = 1733
    RPC_S_INVALID_BOUND                   = 1734
    RPC_S_NO_ENTRY_NAME                   = 1735
    RPC_S_INVALID_NAME_SYNTAX             = 1736
    RPC_S_UNSUPPORTED_NAME_SYNTAX         = 1737
    RPC_S_UUID_NO_ADDRESS                 = 1739
    RPC_S_DUPLICATE_ENDPOINT              = 1740
    RPC_S_UNKNOWN_AUTHN_TYPE              = 1741
    RPC_S_MAX_CALLS_TOO_SMALL             = 1742
    RPC_S_STRING_TOO_LONG                 = 1743
    RPC_S_PROTSEQ_NOT_FOUND               = 1744
    RPC_S_PROCNUM_OUT_OF_RANGE            = 1745
    RPC_S_BINDING_HAS_NO_AUTH             = 1746
    RPC_S_UNKNOWN_AUTHN_SERVICE           = 1747
    RPC_S_UNKNOWN_AUTHN_LEVEL             = 1748
    RPC_S_INVALID_AUTH_IDENTITY           = 1749
    RPC_S_UNKNOWN_AUTHZ_SERVICE           = 1750
    EPT_S_INVALID_ENTRY                   = 1751
    EPT_S_CANT_PERFORM_OP                 = 1752
    EPT_S_NOT_REGISTERED                  = 1753
    RPC_S_NOTHING_TO_EXPORT               = 1754
    RPC_S_INCOMPLETE_NAME                 = 1755
    RPC_S_INVALID_VERS_OPTION             = 1756
    RPC_S_NO_MORE_MEMBERS                 = 1757
    RPC_S_NOT_ALL_OBJS_UNEXPORTED         = 1758
    RPC_S_INTERFACE_NOT_FOUND             = 1759
    RPC_S_ENTRY_ALREADY_EXISTS            = 1760
    RPC_S_ENTRY_NOT_FOUND                 = 1761
    RPC_S_NAME_SERVICE_UNAVAILABLE        = 1762
    RPC_S_INVALID_NAF_ID                  = 1763
    RPC_S_CANNOT_SUPPORT                  = 1764
    RPC_S_NO_CONTEXT_AVAILABLE            = 1765
    RPC_S_INTERNAL_ERROR                  = 1766
    RPC_S_ZERO_DIVIDE                     = 1767
    RPC_S_ADDRESS_ERROR                   = 1768
    RPC_S_FP_DIV_ZERO                     = 1769
    RPC_S_FP_UNDERFLOW                    = 1770
    RPC_S_FP_OVERFLOW                     = 1771
    RPC_X_NO_MORE_ENTRIES                 = 1772
    RPC_X_SS_CHAR_TRANS_OPEN_FAIL         = 1773
    RPC_X_SS_CHAR_TRANS_SHORT_FILE        = 1774
    RPC_X_SS_IN_NULL_CONTEXT              = 1775
    RPC_X_SS_CONTEXT_DAMAGED              = 1777
    RPC_X_SS_HANDLES_MISMATCH             = 1778
    RPC_X_SS_CANNOT_GET_CALL_HANDLE       = 1779
    RPC_X_NULL_REF_POINTER                = 1780
    RPC_X_ENUM_VALUE_OUT_OF_RANGE         = 1781
    RPC_X_BYTE_COUNT_TOO_SMALL            = 1782
    RPC_X_BAD_STUB_DATA                   = 1783
    ERROR_INVALID_USER_BUFFER             = 1784
    ERROR_UNRECOGNIZED_MEDIA              = 1785
    ERROR_NO_TRUST_LSA_SECRET             = 1786
    ERROR_NO_TRUST_SAM_ACCOUNT            = 1787
    ERROR_TRUSTED_DOMAIN_FAILURE          = 1788
    ERROR_TRUSTED_RELATIONSHIP_FAILURE    = 1789
    ERROR_TRUST_FAILURE                   = 1790
    RPC_S_CALL_IN_PROGRESS                = 1791
    ERROR_NETLOGON_NOT_STARTED            = 1792
    ERROR_ACCOUNT_EXPIRED                 = 1793
    ERROR_REDIRECTOR_HAS_OPEN_HANDLES     = 1794
    ERROR_PRINTER_DRIVER_ALREADY_INSTALLED= 1795
    ERROR_UNKNOWN_PORT                    = 1796
    ERROR_UNKNOWN_PRINTER_DRIVER          = 1797
    ERROR_UNKNOWN_PRINTPROCESSOR          = 1798
    ERROR_INVALID_SEPARATOR_FILE          = 1799
    ERROR_INVALID_PRIORITY                = 1800
    ERROR_INVALID_PRINTER_NAME            = 1801
    ERROR_PRINTER_ALREADY_EXISTS          = 1802
    ERROR_INVALID_PRINTER_COMMAND         = 1803
    ERROR_INVALID_DATATYPE                = 1804
    ERROR_INVALID_ENVIRONMENT             = 1805
    RPC_S_NO_MORE_BINDINGS                = 1806
    ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT = 1807
    ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT = 1808
    ERROR_NOLOGON_SERVER_TRUST_ACCOUNT    = 1809
    ERROR_DOMAIN_TRUST_INCONSISTENT       = 1810
    ERROR_SERVER_HAS_OPEN_HANDLES         = 1811
    ERROR_RESOURCE_DATA_NOT_FOUND         = 1812
    ERROR_RESOURCE_TYPE_NOT_FOUND         = 1813
    ERROR_RESOURCE_NAME_NOT_FOUND         = 1814
    ERROR_RESOURCE_LANG_NOT_FOUND         = 1815
    ERROR_NOT_ENOUGH_QUOTA                = 1816
    RPC_S_NO_INTERFACES                   = 1817
    RPC_S_CALL_CANCELLED                  = 1818
    RPC_S_BINDING_INCOMPLETE              = 1819
    RPC_S_COMM_FAILURE                    = 1820
    RPC_S_UNSUPPORTED_AUTHN_LEVEL         = 1821
    RPC_S_NO_PRINC_NAME                   = 1822
    RPC_S_NOT_RPC_ERROR                   = 1823
    RPC_S_UUID_LOCAL_ONLY                 = 1824
    RPC_S_SEC_PKG_ERROR                   = 1825
    RPC_S_NOT_CANCELLED                   = 1826
    RPC_X_INVALID_ES_ACTION               = 1827
    RPC_X_WRONG_ES_VERSION                = 1828
    RPC_X_WRONG_STUB_VERSION              = 1829
    RPC_X_INVALID_PIPE_OBJECT             = 1830
    RPC_X_WRONG_PIPE_ORDER                = 1831
    RPC_X_WRONG_PIPE_VERSION              = 1832
    RPC_S_GROUP_MEMBER_NOT_FOUND          = 1898
    EPT_S_CANT_CREATE                     = 1899
    RPC_S_INVALID_OBJECT                  = 1900
    ERROR_INVALID_TIME                    = 1901
    ERROR_INVALID_FORM_NAME               = 1902
    ERROR_INVALID_FORM_SIZE               = 1903
    ERROR_ALREADY_WAITING                 = 1904
    ERROR_PRINTER_DELETED                 = 1905
    ERROR_INVALID_PRINTER_STATE           = 1906
    ERROR_PASSWORD_MUST_CHANGE            = 1907
    ERROR_DOMAIN_CONTROLLER_NOT_FOUND     = 1908
    ERROR_ACCOUNT_LOCKED_OUT              = 1909
    OR_INVALID_OXID                       = 1910
    OR_INVALID_OID                        = 1911
    OR_INVALID_SET                        = 1912
    RPC_S_SEND_INCOMPLETE                 = 1913
    RPC_S_INVALID_ASYNC_HANDLE            = 1914
    RPC_S_INVALID_ASYNC_CALL              = 1915
    RPC_X_PIPE_CLOSED                     = 1916
    RPC_X_PIPE_DISCIPLINE_ERROR           = 1917
    RPC_X_PIPE_EMPTY                      = 1918
    ERROR_NO_SITENAME                     = 1919
    ERROR_CANT_ACCESS_FILE                = 1920
    ERROR_CANT_RESOLVE_FILENAME           = 1921
    RPC_S_ENTRY_TYPE_MISMATCH             = 1922
    RPC_S_NOT_ALL_OBJS_EXPORTED           = 1923
    RPC_S_INTERFACE_NOT_EXPORTED          = 1924
    RPC_S_PROFILE_NOT_ADDED               = 1925
    RPC_S_PRF_ELT_NOT_ADDED               = 1926
    RPC_S_PRF_ELT_NOT_REMOVED             = 1927
    RPC_S_GRP_ELT_NOT_ADDED               = 1928
    RPC_S_GRP_ELT_NOT_REMOVED             = 1929
    ERROR_KM_DRIVER_BLOCKED               = 1930
    ERROR_CONTEXT_EXPIRED                 = 1931
    ERROR_PER_USER_TRUST_QUOTA_EXCEEDED   = 1932
    ERROR_ALL_USER_TRUST_QUOTA_EXCEEDED   = 1933
    ERROR_USER_DELETE_TRUST_QUOTA_EXCEEDED= 1934
    ERROR_AUTHENTICATION_FIREWALL_FAILED  = 1935
    ERROR_REMOTE_PRINT_CONNECTIONS_BLOCKED= 1936
    ERROR_INVALID_PIXEL_FORMAT            = 2000
    ERROR_BAD_DRIVER                      = 2001
    ERROR_INVALID_WINDOW_STYLE            = 2002
    ERROR_METAFILE_NOT_SUPPORTED          = 2003
    ERROR_TRANSFORM_NOT_SUPPORTED         = 2004
    ERROR_CLIPPING_NOT_SUPPORTED          = 2005
    ERROR_INVALID_CMM                     = 2010
    ERROR_INVALID_PROFILE                 = 2011
    ERROR_TAG_NOT_FOUND                   = 2012
    ERROR_TAG_NOT_PRESENT                 = 2013
    ERROR_DUPLICATE_TAG                   = 2014
    ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE = 2015
    ERROR_PROFILE_NOT_FOUND               = 2016
    ERROR_INVALID_COLORSPACE              = 2017
    ERROR_ICM_NOT_ENABLED                 = 2018
    ERROR_DELETING_ICM_XFORM              = 2019
    ERROR_INVALID_TRANSFORM               = 2020
    ERROR_COLORSPACE_MISMATCH             = 2021
    ERROR_INVALID_COLORINDEX              = 2022
    ERROR_CONNECTED_OTHER_PASSWORD        = 2108
    ERROR_BAD_USERNAME                    = 2202
    ERROR_NOT_CONNECTED                   = 2250
    ERROR_OPEN_FILES                      = 2401
    ERROR_ACTIVE_CONNECTIONS              = 2402
    ERROR_DEVICE_IN_USE                   = 2404
    ERROR_UNKNOWN_PRINT_MONITOR           = 3000
    # :startdoc:

    ERROR_USER_DEFINED_BASE = 0xF000

    # Flags for FormatMessage function:

    FORMAT_MESSAGE_ALLOCATE_BUFFER   = 0x00000100
    FORMAT_MESSAGE_IGNORE_INSERTS    = 0x00000200
    FORMAT_MESSAGE_FROM_STRING       = 0x00000400
    FORMAT_MESSAGE_FROM_HMODULE      = 0x00000800
    FORMAT_MESSAGE_FROM_SYSTEM       = 0x00001000
    FORMAT_MESSAGE_ARGUMENT_ARRAY    = 0x00002000
    FORMAT_MESSAGE_MAX_WIDTH_MASK    = 0x000000FF

    # Set/GetErrorMode values:

    SEM_FAILCRITICALERRORS     = 0x0001
    SEM_NOALIGNMENTFAULTEXCEPT = 0x0004
    SEM_NOGPFAULTERRORBOX      = 0x0002
    SEM_NOOPENFILEERRORBOX     = 0x8000

    ##
    # FormatMessage Function
    # Formats a message string. The function requires a message definition as input. The message definition
    # can come from a buffer passed into the function. It can come from a message table resource in an
    # already-loaded module. Or the caller can ask the function to search the system's message table
    # resource(s) for the message definition. The function finds the message definition in a message table
    # resource based on a message identifier and a language identifier. The function copies the formatted
    # message text to an output buffer, processing any embedded insert sequences if requested.
    #
    # [*Syntax*] DWORD WINAPI FormatMessage( DWORD dwFlags, LPCVOID lpSource, DWORD dwMessageId, DWORD
    #            dwLanguageId, LPTSTR lpBuffer, DWORD nSize, va_list* Arguments );
    #
    # dwFlags:: [in] The formatting options, and how to interpret the lpSource parameter. The low-order byte of dwFlags
    #           specifies how the function handles line breaks in the output buffer. The low-order byte can also
    #           specify the maximum width of a formatted output line. Possible values:
    #           - FORMAT_MESSAGE_ALLOCATE_BUFFER - The lpBuffer parameter is a pointer to a PVOID pointer, and that
    #             the nSize parameter specifies the minimum number of TCHARs to allocate for an output message buffer.
    #             The function allocates a buffer large enough to hold the formatted message, and places a pointer to
    #             the allocated buffer at the address specified by lpBuffer. The caller should use the LocalFree
    #             function to free the buffer when it is no longer needed.
    #           - FORMAT_MESSAGE_ARGUMENT_ARRAY - The Arguments parameter is not a va_list structure, but is a pointer
    #             to an array of values that represent the arguments. This flag cannot be used with 64-bit integer
    #             values. If you are using a 64-bit integer, you must use the va_list structure.
    #           - FORMAT_MESSAGE_FROM_HMODULE - The lpSource parameter is a module handle containing the message-table
    #             resource(s) to search. If this lpSource handle is NULL, the current process's application image file
    #             will be searched. This flag cannot be used with FORMAT_MESSAGE_FROM_STRING. If the module has no
    #             message table resource, the function fails with ERROR_RESOURCE_TYPE_NOT_FOUND.
    #           - FORMAT_MESSAGE_FROM_STRING -  The lpSource parameter is a pointer to a null-terminated string that
    #             contains a message definition. The message definition may contain insert sequences, just as the
    #             message text in a message table resource may. Cannot be used with FORMAT_MESSAGE_FROM_HMODULE or
    #             FORMAT_MESSAGE_FROM_SYSTEM.
    #           - FORMAT_MESSAGE_FROM_SYSTEM - The function should search the system message-table resource(s) for
    #             the requested message. If this flag is specified with FORMAT_MESSAGE_FROM_HMODULE, the function
    #             searches the system message table if the message is not found in the module specified by lpSource.
    #             This flag cannot be used with FORMAT_MESSAGE_FROM_STRING. If this flag is specified, an application
    #             can pass the result of the GetLastError function to retrieve the message text for a system error.
    #           - FORMAT_MESSAGE_IGNORE_INSERTS - Insert sequences in the message definition are to be ignored and
    #             passed through to the output buffer unchanged. This flag is useful for fetching a message for later
    #             formatting. If this flag is set, the Arguments parameter is ignored.
    #           <b>The low-order byte of dwFlags  can specify the maximum width of a formatted output line. The
    #           following are possible values of the low-order byte:</b>
    #           - 0 - There are no output line width restrictions. The function stores line breaks that are in the
    #             message definition text into the output buffer.
    #           - FORMAT_MESSAGE_MAX_WIDTH_MASK - The function ignores regular line breaks in the message definition
    #             text. The function stores hard-coded line breaks in the message definition text into the output
    #             buffer. The function generates no new line breaks.
    #           If the low-order byte is a nonzero value other than FORMAT_MESSAGE_MAX_WIDTH_MASK, it specifies the
    #           maximum number of characters in an output line. The function ignores regular line breaks in the
    #           message definition text. The function never splits a string delimited by white space across a line
    #           break. The function stores hard-coded line breaks in the message definition text into the output
    #           buffer. Hard-coded line breaks are coded with the %n escape sequence.
    # lpSource:: The location of the message definition. The type of this parameter depends upon the settings in the
    #            dwFlags parameter.
    #            - dwFlags FORMAT_MESSAGE_FROM_HMODULE: Handle to the module that contains the message table to search.
    #            - dwFlags FORMAT_MESSAGE_FROM_STRING: Pointer to a string that consists of unformatted message text.
    #              It will be scanned for inserts and formatted accordingly.
    #            - If neither of these flags is set in dwFlags, then lpSource is ignored.
    # dwMessageId:: The message identifier for the requested message. This parameter is ignored if dwFlags includes
    #               FORMAT_MESSAGE_FROM_STRING.
    # dwLanguageId:: The language identifier for the requested message. This parameter is ignored if dwFlags includes
    #                FORMAT_MESSAGE_FROM_STRING. If you pass a specific LANGID in this parameter, FormatMessage will
    #                return a message for that LANGID only. If the function cannot find a message for that LANGID, it
    #                returns ERROR_RESOURCE_LANG_NOT_FOUND. If you pass in zero, FormatMessage looks for a message for
    #                LANGIDs in the following order:
    #                1. Language neutral
    #                2. Thread LANGID, based on the thread's locale value
    #                3. User default LANGID, based on the user's default locale value
    #                4. System default LANGID, based on the system default locale value
    #                5. US English
    #                If FormatMessage does not locate a message for any of the preceding LANGIDs, it returns any
    #                language message string that is present. If that fails, it returns ERROR_RESOURCE_LANG_NOT_FOUND.
    # lpBuffer::  A pointer to a buffer that receives the null-terminated string that specifies the formatted message.
    #             If dwFlags includes FORMAT_MESSAGE_ALLOCATE_BUFFER, the function allocates a buffer using the
    #             LocalAlloc function, and places the pointer to the buffer at the address specified in lpBuffer.
    #             This buffer cannot be larger than 64K bytes.
    # nSize:: If the FORMAT_MESSAGE_ALLOCATE_BUFFER flag is not set, this parameter specifies the size of the output
    #         buffer, in TCHARs. If FORMAT_MESSAGE_ALLOCATE_BUFFER is set, this parameter specifies the minimum
    #         number of TCHARs to allocate for an output buffer. The output buffer cannot be larger than 64K bytes.
    # Arguments:: An array of values that are used as insert values in the formatted message. A %1 in the format string
    #             indicates the first value in the Arguments array; a %2 indicates the second argument; and so on.
    #             The interpretation of each value depends on the formatting information associated with the insert in
    #             the message definition. The default is to treat each value as a pointer to a null-terminated string.
    #             By default, the Arguments parameter is of type va_list*, which is a language- and
    #             implementation-specific data type for describing a variable number of arguments. The state of the
    #             va_list argument is undefined upon return from the function. To use the va_list again, destroy the
    #             variable argument list pointer using va_end and reinitialize it with va_start.
    #             If you do not have a pointer of type va_list*, then specify the FORMAT_MESSAGE_ARGUMENT_ARRAY flag and
    #             pass a pointer to an array of DWORD_PTR values; those values are input to the message formatted as the
    #             insert values. Each insert must have a corresponding element in the array.
    #
    # *Returns*:: If the function succeeds, the return value is the number of TCHARs stored in the output
    #             buffer, excluding the terminating null character. If the function fails, the return value is zero.
    #             To get extended error information, call GetLastError.
    # ---
    # *Remarks*:
    # Within the message text, several escape sequences are supported for dynamically formatting the
    # message. These escape sequences and their meanings are shown in the following tables. All escape
    # sequences start with the percent character (%).
    # %0:: Terminates a message text line without a trailing new line character. This escape sequence can be
    #      used to build up long lines or to terminate the message itself without a trailing new line character.
    #      It is useful for prompt messages.
    # %n!format string!:: Identifies an insert. The value of n can be in the range from 1 through 99. The format string
    #                     (which must be surrounded by exclamation marks) is optional and defaults to !s! if not
    #                     specified. For more information, see Format Specification Fields. The format string can
    #                     include a width and precision specifier for strings and a width specifier for integers.
    #                     Use an asterisk (*) to specify the width and precision. For example, %1!*.*s! or %1!*u!.
    #                     If you do not use the width and precision specifiers, the insert numbers correspond directly
    #                     to the input arguments. For example, if the source string is "%1 %2 %1" and the input
    #                     arguments are "Bill" and "Bob", the formatted output string is "Bill Bob Bill".
    #                     However, if you use a width and precision specifier, the insert numbers do not correspond
    #                     directly to    # the input arguments. For example, the insert numbers for the previous
    #                     example could change to "%1!*.*s! %4 %5!*s!".
    #                     The insert numbers depend on whether you use arguments array (FORMAT_MESSAGE_ARGUMENT_ARRAY)
    #                     or a va_list. For an arguments array, the next insert number is n+2 if the previous format
    #                     string contained one asterisk and is n+3 if two asterisks were specified. For a va_list,
    #                     the next insert number is n+1 if the previous format string contained one asterisk and is n+2
    #                     if two asterisks were specified. If you want to repeat "Bill", as in the previous example,
    #                     the arguments must include "Bill" twice. E.g., if source string is "%1!*.*s! %4 %5!*s!",
    #                     the arguments could be, 4, 2, Bill, Bob, 6, Bill (if using the FORMAT_MESSAGE_ARGUMENT_ARRAY).
    #                     The formatted string would then be "  Bi Bob Bill".
    #                     Repeating insert numbers when the source string contains width and precision specifiers may
    #                     not yield the intended results. If you replaced %5 with %1, the function would try to print
    #                     a string at address 6 (likely resulting in an access violation).
    #                     Floating-point format specifiers—e, E, f, and g—are not supported. The workaround is to use
    #                     the StringCchPrintf function to format the floating-point number into a temporary buffer,
    #                     then use that buffer as the insert string.
    #                     Inserts that use the I64 prefix are treated as two 32-bit arguments. They must be used before
    #                     subsequent arguments are used. Note that it may be easier for you to use StringCchPrintf
    #                     instead of this prefix.
    #
    # Any other nondigit character following a percent character is formatted in the output message without the
    # percent character. Following are some examples.
    # %%:: A single percent sign.
    # %space:: A single space. This format string can be used to ensure the appropriate number of trailing
    #          spaces in a message text line.
    # %.:: A single period. This format string can be used to include a single period at the beginning of a
    #      line without terminating the message text definition.
    # %!:: A single exclamation point. This format string can be used to include an exclamation point
    #      immediately after an insert without its being mistaken for the beginning of a format string.
    # %n:: A hard line break when the format string occurs at the end of a line. This format string is useful
    #      when FormatMessage is supplying regular line breaks so the message fits in a certain width.
    # %r:: A hard carriage return without a trailing newline character.
    # %t:: A single tab.
    # ---
    # *Security* *Remarks*:
    # If this function is called without FORMAT_MESSAGE_IGNORE_INSERTS, the Arguments parameter must contain
    # enough parameters to satisfy all insertion sequences in the message string, and they must be of the
    # correct type. Therefore, do not use untrusted or unknown message strings with inserts enabled because
    # they can contain more insertion sequences than Arguments provides, or those they may be of the wrong
    # type. In particular, it is unsafe to take an arbitrary system error code returned from an API and use
    # FORMAT_MESSAGE_FROM_SYSTEM without FORMAT_MESSAGE_IGNORE_INSERTS.
    # ---
    # <b>Enhanced (snake_case) API: returns message instead of num_chars or *nil* if function fails</b>
    #
    # :call-seq:
    #  message = format_message(dw_flags, lp_source, dw_message_id, dw_language_id, *args)
    #
    function :FormatMessage, [:DWORD, :LPCVOID, :DWORD, :DWORD, :LPTSTR, :DWORD, :varargs], :DWORD,
             &->(api, flags=FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ARGUMENT_ARRAY,
                     source=nil, message_id=0, language_id=0, *args){
             buffer = FFI::MemoryPointer.new :char, 260
             args = [:int, 0] if args.empty?
             num_chars = api.call(flags, source, message_id, language_id, buffer, buffer.size, *args)
             num_chars == 0 ? nil : buffer.get_bytes(0, num_chars).strip }

    ##
    # GetLastError Function
    # Retrieves the calling thread's last-error code value. The last-error code is maintained on a
    # per-thread basis. Multiple threads do not overwrite each other's last-error code.
    # Visual Basic:  Applications should call err.LastDllError instead of GetLastError.
    #
    # [*Syntax*] DWORD WINAPI GetLastError( void );
    #
    # This function has no parameters.
    #
    # *Returns*:: The return value is the calling thread's last-error code.
    # The Return Value section of the documentation for each function that sets the last-error code notes
    # the conditions under which the function sets the last-error code. Most functions that set the thread's
    # last-error code set it when they fail. However, some functions also set the last-error code when they
    # succeed. If the function is not documented to set the last-error code, the value returned by this
    # function is simply the most recent last-error code to have been set; some functions set the last-error
    # code to 0 on success and others do not.
    # ---
    # *Remarks*:
    # Functions executed by the calling thread set this value by calling the SetLastError function. You
    # should call the GetLastError function immediately when a function's return value indicates that such a
    # call will return useful data. That is because some functions call SetLastError with a zero when they
    # succeed, wiping out the error code set by the most recently failed function.
    # To obtain an error string for system error codes, use the FormatMessage function. For a complete list
    # of error codes provided by the operating system, see System Error Codes.
    # The error codes returned by a function are not part of the Windows API specification and can vary by
    # operating system or device driver. For this reason, we cannot provide the complete list of error codes
    # that can be returned by each function. There are also many functions whose documentation does not
    # include even a partial list of error codes that can be returned.
    # Error codes are 32-bit values (bit 31 is the most significant bit). Bit 29 is reserved for
    # application-defined error codes; no system error code has this bit set. If you are defining an error
    # code for your application, set this bit to one. That indicates that the error code has been defined by
    # an application, and ensures that your error code does not conflict with any error codes defined by the
    # system.
    # To convert a system error into an HRESULT value, use the HRESULT_FROM_WIN32 macro.
    # ---
    # <b>Enhanced (snake_case) API: returns error message instead of error code</b>
    #
    # :call-seq:
    #  error_message = get_last_error()
    #
    function :GetLastError, [], :uint32,
             &->(api) { error_code = api.call
             flags = FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ARGUMENT_ARRAY
             format_message(flags, nil, error_code)}

    ##
    # SetLastError Function
    # Sets the last-error code for the calling thread.
    #
    # [*Syntax*] void WINAPI SetLastError( DWORD dwErrCode );
    #
    # dwErrCode:: [in] The last-error code for the thread.
    #
    # *Returns*:: This function does not return a value.
    # ---
    # *Remarks*:
    # - The last-error code is kept in thread local storage so that multiple threads do not overwrite each
    #   other's values.
    # - This function is intended primarily for use by dynamic-link libraries (DLL). A DLL can provide the
    #   applications that are using it with additional diagnostic information by calling this function after
    #   an error occurs. Most functions call SetLastError or SetLastErrorEx only when they fail. However, some
    #   system functions call SetLastError or SetLastErrorEx under conditions of success; those cases are
    #   noted in each function's documentation.
    # - Applications can optionally retrieve the value set by this function by using the GetLastError function
    #   immediately after a function fails.
    # - Error codes are 32-bit values (bit 31 is the most significant bit). Bit 29 is reserved for
    #   application-defined error codes; no system error code has this bit set. If you are defining an error
    #   code for your application, set this bit to indicate that the error code has been defined by your
    #   application and to ensure that your error code does not conflict with any system-defined error codes.
    # ---
    # <b>Enhanced (snake_case) API: </b>
    #
    # :call-seq:
    #  set_last_error(err_code)
    #
    function :SetLastError, [:DWORD], :void

    ##
    # SetLastErrorEx Function sets the last-error code.
    # Currently, this function is identical to the SetLastError function. The second parameter is ignored.
    #
    # [*Syntax*] void WINAPI SetLastErrorEx( DWORD dwErrCode, DWORD dwType );
    #
    # dwErrCode:: The last-error code for the thread.
    # dwType:: This parameter is ignored.
    #
    # *Returns*:: This function does not return a value.
    # ---
    # *Remarks*:
    # The last-error code is kept in thread local storage so that multiple threads do not overwrite each
    # other's values.
    # This function is intended primarily for use by dynamic-link libraries (DLL). A DLL can provide the
    # applications that are using it with additional diagnostic information by calling this function after
    # an error occurs. Most functions call SetLastError or SetLastErrorEx only when they fail. However, some
    # system functions call SetLastError or SetLastErrorEx under conditions of success; those cases are
    # noted in each function's documentation.
    # Applications can optionally retrieve the value set by this function by using the GetLastError function
    # immediately after a function fails.
    # Error codes are 32-bit values (bit 31 is the most significant bit). Bit 29 is reserved for
    # application-defined error codes; no system error code has this bit set. If you are defining an error
    # code for your application, set this bit to indicate that the error code has been defined by the
    # application and to ensure that your error code does not conflict with any system-defined error codes.
    #
    # :call-seq:
    #  set_last_error_ex(err_code, dw_type)
    #
    try_function :SetLastErrorEx, [:DWORD, :DWORD], :void
    # fails silently unless platform is XP++

    ##
    # GetErrorMode Function
    # Retrieves the error mode for the current process.
    #
    # [*Syntax*] UINT WINAPI GetErrorMode( void );
    #
    # This function has no parameters.
    #
    # *Returns*:: The process error mode. This function returns one of the following values.
    #         SEM_FAILCRITICALERRORS:: The system does not display the critical-error-handler message box. Instead,
    #                                  the system sends the error to the calling process.
    #         SEM_NOALIGNMENTFAULTEXCEPT:: The system automatically fixes memory alignment faults and makes them
    #                                      invisible to the application. It does this for the calling process and any
    #                                      descendant processes. This feature is only supported by certain processor
    #                                      architectures. For more information, see the Remarks section.
    #                                      After this value is set for a process, subsequent attempts to clear the
    #                                      value are ignored.
    #         SEM_NOGPFAULTERRORBOX:: The system does not display the general-protection-fault message box. This flag
    #                                 should only be set by debugging applications that handle general protection (GP)
    #                                 faults themselves with an exception handler.
    #         SEM_NOOPENFILEERRORBOX:: The system does not display a message box when it fails to find a file. Instead,
    #                                  the error is returned to the calling process.
    # ---
    # *Remarks*:
    # Each process has an associated error mode that indicates to the system how the application is going to
    # respond to serious errors. A child process inherits the error mode of its parent process.
    # To change the error mode for the process, use the SetErrorMode function.
    # ------
    # <b> Only works in Vista++! </b>
    # ------
    # :call-seq:
    #  mode = get_error_mode()
    #
    try_function :GetErrorMode, [], :UINT
    # fails silently unless platform is Vista++

    ##
    # SetErrorMode Function controls whether the system will handle the specified types of serious errors or whether
    # the process will handle them.
    #
    # [*Syntax*] UINT WINAPI SetErrorMode( UINT uMode );
    #
    # uMode:: The process error mode. This parameter can be one or more of the following values.
    #         0:: Use the system default, which is to display all error dialog boxes.
    #         SEM_FAILCRITICALERRORS:: The system does not display the critical-error-handler message box. Instead,
    #                                  the system sends the error to the calling process.
    #         SEM_NOALIGNMENTFAULTEXCEPT:: The system automatically fixes memory alignment faults and makes them
    #                                      invisible to the application. It does this for the calling process and any
    #                                      descendant processes. This feature is only supported by certain processor
    #                                      architectures. For more information, see the Remarks section.
    #                                      After this value is set for a process, subsequent attempts to clear the
    #                                      value are ignored.
    #         SEM_NOGPFAULTERRORBOX:: The system does not display the general-protection-fault message box. This flag
    #                                 should only be set by debugging applications that handle general protection (GP)
    #                                 faults themselves with an exception handler.
    #         SEM_NOOPENFILEERRORBOX:: The system does not display a message box when it fails to find a file. Instead,
    #                                  the error is returned to the calling process.
    #
    # *Returns*:: The return value is the previous state of the error-mode bit flags.
    # ---
    # *Remarks*:
    # Each process has an associated error mode that indicates to the system how the application is going to
    # respond to serious errors. A child process inherits the error mode of its parent process. To retrieve
    # the process error mode, use the GetErrorMode function.
    # Because the error mode is set for the entire process, you must ensure that multi-threaded applications
    # do not set different error-mode flags. Doing so can lead to inconsistent error handling.
    # The system does not make alignment faults visible to an application on all processor architectures.
    # Therefore, specifying SEM_NOALIGNMENTFAULTEXCEPT is not an error on such architectures, but the system
    # is free to silently ignore the request. This means that code sequences such as the following are not
    # always valid on x86 computers:
    #
    #   SetErrorMode(SEM_NOALIGNMENTFAULTEXCEPT);
    #   fuOldErrorMode = SetErrorMode(0);
    #   ASSERT(fuOldErrorMode == SEM_NOALIGNMENTFAULTEXCEPT);
    #
    # Itanium::  An application must explicitly call SetErrorMode with SEM_NOALIGNMENTFAULTEXCEPT to have the
    #            system automatically fix alignment faults. The default setting is for the system to make alignment
    #            faults visible to an application.
    # Visual Studio 2005::  When declaring a pointer to a structure that may not have aligned data, you can use
    #                       __unaligned keyword to indicate that the type must be read one byte at a time. For more
    #                       information, see Windows Data Alignment.
    #
    # :call-seq:
    #  success = set_error_mode(mode)
    #
    function :SetErrorMode, [:UINT], :UINT

  end
end