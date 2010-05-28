require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::Gui::Input

  describe Win::Gui::Input, ' defines a set of API functions related to user input' do

    describe '#keydb_event' do
      spec{ use{ keybd_event(vkey = 0, bscan = 0, flags = 0, extra_info = 0) }}

      it 'synthesizes a numeric keystrokes, emulating keyboard driver' do
        test_app do |app|
          text = '12 34'
          text.upcase.each_byte do |b| # upcase needed since user32 keybd_event expects upper case chars
            keybd_event(b.ord, 0, KEYEVENTF_KEYDOWN, 0)
            sleep KEY_DELAY
            keybd_event(b.ord, 0, KEYEVENTF_KEYUP, 0)
            sleep KEY_DELAY
          end
          text(app.textarea).should =~ Regexp.new(text)
          5.times {keystroke(VK_CONTROL, 'Z'.ord)} # rolling back changes to allow window closing without dialog!
        end
      end
    end # describe '#keydb_event'
    
    describe '#mouse_event' do
      spec { use {mouse_event( flags = MOUSEEVENTF_ABSOLUTE , dx = 0, dy = 0, data=0, extra_info=0 )}}
      it 'Emulates Mouse clicks'
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
        get_cursor_pos().should == [600,600]
        set_cursor_pos(x=0, y=0).should be_true
        get_cursor_pos().should == [0,0]
      end
    end # describe '#set_cursor_pos'

  end # Win::Gui::Input, ' defines a set of API functions related to user input'

  describe Win::Gui::Input, ' defines convenience/service methods on top of Windows API' do
    describe '#keystroke' do
      spec{ use{ keystroke( vkey = 30, vkey = 30) }}

      it 'emulates combinations of keys pressed (Ctrl+Alt+P+M, etc)' do
        test_app do |app|
          keystroke(VK_CONTROL, 'A'.ord)
          keystroke(VK_SPACE)
          text(app.textarea).should.should == ' '
          2.times {keystroke(VK_CONTROL, 'Z'.ord)} # rolling back changes to allow window closing without dialog!
        end
      end
    end # describe '#keystroke'

    describe '#type_in' do
      spec{ use{ type_in(message = '') }}

      it 'types text message into the window holding the focus' do
        test_app do |app|
          text = '12 34'
          type_in(text)
          text(app.textarea).should =~ Regexp.new(text)
          5.times {keystroke(VK_CONTROL, 'Z'.ord)} # rolling back changes to allow window closing without dialog!
        end
      end
    end # describe '#type_in'

  end # Win::Gui::Input, ' defines convenience/service methods on top of Windows API'
end

