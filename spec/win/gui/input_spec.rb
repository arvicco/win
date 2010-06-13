require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'

module WinGuiInputTest

  include WinTestApp
  include Win::Gui::Input

  describe Win::Gui::Input, ' defines a set of API functions related to user input' do

    describe '#keydb_event' do
      spec{ use{ keybd_event(vkey = 0, bscan = 0, flags = 0, extra_info = 0) }}
      before(:each){ (@app=launch_test_app)}
      after(:each) do
        3.times do  # rolling back changes to allow window closing without dialog!
          keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYDOWN, 0)
          sleep KEY_DELAY
          keybd_event('Z'.ord, 0, KEYEVENTF_KEYDOWN, 0)
          sleep KEY_DELAY
          keybd_event('Z'.ord, 0, KEYEVENTF_KEYUP, 0)
          sleep KEY_DELAY
          keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0)
          sleep KEY_DELAY
        end
        close_test_app
      end

      it 'synthesizes a numeric keystrokes, emulating keyboard driver' do
        text = '123'
        text.upcase.each_byte do |b| # upcase needed since user32 keybd_event expects upper case chars
          keybd_event(b.ord, 0, KEYEVENTF_KEYDOWN, 0)
          sleep KEY_DELAY
          keybd_event(b.ord, 0, KEYEVENTF_KEYUP, 0)
          sleep KEY_DELAY
        end
        text(@app.textarea).should =~ Regexp.new(text)
      end
    end # describe '#keydb_event'

    describe '#mouse_event' do
      spec { use {mouse_event( flags = MOUSEEVENTF_ABSOLUTE, dx = 0, dy = 0, data=0, extra_info=0 )}}

      it 'emulates mouse clicks' do
        test_app do |app|
          # Position cursor at app's "Close Window" control
          left, top, right, bottom = get_window_rect(app.handle)
          set_cursor_pos(x=right-5, y=top+5).should be_true

          mouse_event MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0
          mouse_event MOUSEEVENTF_LEFTUP, 0, 0, 0, 0
          sleep SLEEP_DELAY
          window?(app.handle).should == false
        end
      end

    end # describe '#mouse_event'

    describe "#get_cursor_pos" do
      spec{ use{ success = GetCursorPos(lp_point=FFI::MemoryPointer.new(:long, 2)) }}
      spec{ use{ x, y = get_cursor_pos() }}

      it "original api returns success code and puts cursor's screen coordinates into supplied buffer" do
        success = GetCursorPos(lp_point=FFI::MemoryPointer.new(:long, 2))
        success.should_not == 0
        x, y = lp_point.read_array_of_long(2)
        x.should be_an Integer
        x.should be >= 0
        y.should be_an Integer
        y.should be >= 0
      end

      it "snake_case api returns the cursor's position, in screen coordinates" do
        x, y = get_cursor_pos()
        x.should be_an Integer
        x.should be >= 0
        y.should be_an Integer
        y.should be >= 0
      end
    end # describe get_cursor_pos

    describe '#set_cursor_pos' do
      spec { use {success = SetCursorPos(x=0, y=0)}}
      spec { use {success = set_cursor_pos(x=0, y=0)}}

      it 'sets cursor`s position, in screen coordinates' do
        SetCursorPos(x=600, y=600).should be_true
        get_cursor_pos().should == [600, 600]
        set_cursor_pos(x=0, y=0).should be_true
        get_cursor_pos().should == [0, 0]
      end
    end # describe '#set_cursor_pos'

  end # Win::Gui::Input, ' defines a set of API functions related to user input'

end

