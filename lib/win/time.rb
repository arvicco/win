require 'win/library'

module Win

  # Includes functions related to Time in Windows
  # In general you will want to use this module with Win::National because
  # it contains the various LOCALE and TIME constants.
  #
  # *NB*: Millisecond granularity may NOT be supported by a hardware platform.
  # The caller of these functions should not rely on more than second granularity.
  # In fact, granularity of all the GetTime... functions is about ~16msec on Windows.
  # You'll need to mess with QueryPerformanceFrequency() and QueryPerformanceCounter()
  # to get real msec granularity on MS Windows;
  #
  module Time
    extend Win::Library
    TIME_ZONE_ID_UNKNOWN  = 0
    TIME_ZONE_ID_STANDARD = 1
    TIME_ZONE_ID_DAYLIGHT = 2


    ##
    # QueryPerformanceFrequency Function
    # Retrieves the frequency of the high-resolution performance counter, if one exists.
    # The frequency cannot change while the system is running.
    #
    # [*Syntax*] BOOL WINAPI QueryPerformanceFrequency( lpFrequency );
    #
    # lpFrequency <out>
    # Type: LARGE_INTEGER*
    # A pointer to a variable that receives the current performance-counter frequency,
    # in counts per second. If the installed hardware does not support a high-resolution
    # performance counter, this parameter can be zero.
    #
    # *Returns*:: Type: BOOL
    # If the installed hardware supports a high-resolution performance counter, the return
    # value is nonzero. If the function fails, the return value is zero. To get extended
    # error information, call GetLastError. For example, if the installed hardware does
    # not support a high-resolution performance counter, the function fails.
    #
    # ---
    # <b>Enhanced (snake_case) API: returns high-resolution performance counter frequency
    # or nil if no high-resolution performance counter is available</b>
    #
    # :call-seq:
    #  frequency = query_performance_frequency()
    #
    function :QueryPerformanceFrequency, [:pointer], :int8,
             &->(api){
             freq = FFI::MemoryPointer.new(:int64)
             api.call(freq) == 0 ? nil : freq.get_int64(0) }

    ##
    # QueryPerformanceCounter Function
    # Retrieves the current value of the high-resolution performance counter.
    #
    # [*Syntax*] BOOL WINAPI QueryPerformanceCounter( __out  LARGE_INTEGER *lpPerformanceCount );
    #
    # lpPerformanceCount <out>
    # Type: LARGE_INTEGER*
    # A pointer to a variable that receives the current performance-counter value, in counts.
    #
    # *Returns*:: Type: BOOL
    # If the function succeeds, the return value is nonzero.
    # If the function fails, the return value is zero. To get extended error information,
    # call GetLastError.
    # ---
    # *Remarks*:
    # On a multiprocessor computer, it should not matter which processor is called. However,
    # you can get different results on different processors due to bugs in the basic
    # input/output system (BIOS) or the hardware abstraction layer (HAL). To specify
    # processor affinity for a thread, use the SetThreadAffinityMask function.
    # ---
    # <b>Enhanced (snake_case) API: returns current performance counter value, in counts.
    # Returns nil if function fails</b>
    #
    # :call-seq:
    #  counter = query_performance_counter()
    #
    function :QueryPerformanceCounter, [:pointer], :int8,
             &->(api){
             count = FFI::MemoryPointer.new(:int64)
             api.call(count) == 0 ? nil : count.get_int64(0) }

    # Untested

    ##
    function :CompareFileTime, 'PP', 'L'
    ##
    function :DosDateTimeToFileTime, 'IIP', :int8, boolean: true
    ##
    function :FileTimeToDosDateTime, 'PPP', :int8, boolean: true
    ##
    function :FileTimeToLocalFileTime, 'PP', :int8, boolean: true
    ##
    function :FileTimeToSystemTime, 'PP', :int8, boolean: true
    ##
    function :GetFileTime, 'LPPP', :int8, boolean: true
    ##
    # [out] Pointer to a SYSTEMTIME structure to receive the current local date and time.
    function :GetLocalTime, 'P', :void
    ##
    # This function retrieves the current system date and time. The system time is expressed in UTC.
    #    [out] Pointer to a SYSTEMTIME structure to receive the current system date and time.
    function :GetSystemTime, 'P', :void
    ##
    function :GetSystemTimeAdjustment, 'PPP', :int8, boolean: true
    ##
    function :GetSystemTimeAsFileTime, 'P', :void
    ##
    function :GetTickCount, [], :void
    ##
    function :GetTimeFormat, 'ILPPPI', 'I'
    ##
    function :GetTimeZoneInformation, 'P', 'L'
    ##
    function :LocalFileTimeToFileTime, 'PP', :int8, boolean: true
    ##
    function :SetFileTime, 'LPPP', :int8, boolean: true
    ##
    function :SetLocalTime, 'P', :int8, boolean: true
    ##
    function :SetSystemTime, 'P', :int8, boolean: true
    ##
    function :SetTimeZoneInformation, 'P', :int8, boolean: true
    ##
    function :SetSystemTimeAdjustment, 'LI', :int8, boolean: true
    ##
    function :SystemTimeToFileTime, 'PP', :int8, boolean: true
    ##
    function :SystemTimeToTzSpecificLocalTime, 'PPP', :int8, boolean: true

    ##
    try_function :GetSystemTimes, 'PPP', :int8, boolean: true
    ##
    try_function :TzSpecificLocalTimeToSystemTime, 'PPP', :int8, boolean: true


  end
end
