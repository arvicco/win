require 'spec_helper'
require 'win/time'

include Win::Time

describe Win::Time do

  describe "#query_performance_frequency" do
    spec { use { success = QueryPerformanceFrequency(freq = FFI::MemoryPointer.new(:int64)) } }
    spec { use { freq = query_performance_frequency() } }

    it "original api returns non-zero and high-res performance counter frequency it a pointer" do
      QueryPerformanceFrequency(freq = FFI::MemoryPointer.new(:int64)).should be > 0
      freq.get_int64(0).should be > 500000
    end

    it "snake_case api returns high-res performance counter frequency or nil if counter not available. " do
      query_performance_frequency().should be > 500000
    end

  end # describe query_performance_frequency

  describe "#query_performance_counter" do
    spec { use { success = QueryPerformanceCounter(count = FFI::MemoryPointer.new(:int64)) } }
    spec { use { success = query_performance_counter() } }

    it "original api succeeds, the return value is nonzero, counter value returned at given pointer." do
      QueryPerformanceCounter(count = FFI::MemoryPointer.new(:int64)).should be > 0
      count.get_int64(0).should be > 500000000000
    end

    it "snake_case api succeeds, the return value is counter value (in counts)" do
      count = query_performance_counter()
      count.should be > 500000000000
    end

    it "successive function calls return (slightly) incremented counter values" do
      100.times do
        count1 = query_performance_counter()
        count2 = query_performance_counter()
        diff = count2 - count1
        diff.should be > 10
        diff.should be < 100
      end
    end
  end # describe query_performance_counter

end # describe Win::Time
