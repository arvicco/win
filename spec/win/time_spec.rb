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

    it "return (slightly) incremented counter values in successive function calls" do
      100.times do
        count1 = query_performance_counter()
        count2 = query_performance_counter()
        diff = count2 - count1
        diff.should be > 10
        diff.should be < 50000 # GC calls make it hard to guarantee uniform measurements?
      end
    end

    it 'returns correct counter counts' do
      count1 = query_performance_counter()
      sleep 0.3
      count2 = query_performance_counter()
      seconds_passed = (count2 - count1).to_f/query_performance_frequency()
      seconds_passed.should be_within(0.02).of(0.3)
    end
  end # describe query_performance_counter

  describe '.now' do
    it 'returns enhanced-precision Time on Windows platform' do
      time = Win::Time.now
      time.should be_a_kind_of ::Time
    end

    it 'is really really enhanced precision' do
      normal_moved = 0
      hi_res_moved = 0
      100.times do
        normal = ::Time.now
        hi_res = Win::Time.now
#        puts "Normal Time.now: #{normal.strftime('%Y-%m-%d %H:%M:%S.%6N')}," +
#                 "Win::Time.now: #{hi_res.strftime('%Y-%m-%d %H:%M:%S.%6N')} "
        normal1 = ::Time.now
        hi_res1 = Win::Time.now
        normal_moved += 1 if normal1 != normal
        hi_res_moved += 1 if hi_res1 != hi_res
      end
      normal_moved.should be < 5
      hi_res_moved.should == 100
    end
  end
end # describe Win::Time
