require 'spec_helper'
require 'win/gui/input'

include WinTestApp
include Win::Gui::Dialog

describe Win::Gui::Dialog do

  describe "#message_box" do
    spec { pending; use { selected_item = message_box(owner_handle=0, text="Text", caption="Caption", type=0) } }

    it "creates, displays, and operates a message box" do
      pending 'Not possible to test message_box directly, it blocks all related threads :('
      t = Thread.new do
        selected_item = message_box(handle=0, text="Text", caption="Caption", type=MB_YESNO | MB_HELP)
        puts selected_item
      end
      t.join
    end
  end # describe message_box


  describe '#get_dlg_item' do
    spec { use { control_handle = get_dlg_item(handle = 0, item_id = 1) } }

    it 'returns handle to an existing controls in a dialog' do
      test_app_with_dialog(:close) do |app, dialog|
        get_dlg_item(dialog, item_id=IDYES).should_not == nil
        get_dlg_item(dialog, item_id=IDNO).should_not == nil
        get_dlg_item(dialog, item_id=IDCANCEL).should_not == nil
      end
    end

    it 'returns nil/0 for non-existing controls in a dialog' do
      test_app_with_dialog(:close) do |app, dialog|
        get_dlg_item(dialog, item_id=IDOK).should == nil
        get_dlg_item(dialog, item_id=IDABORT).should == nil
        GetDlgItem(dialog, item_id=IDRETRY).should == 0
        GetDlgItem(dialog, item_id=IDCONTINUE).should == 0
      end
    end

    describe "#get_dlg_ctrl_id" do
      spec { use { control_id = GetDlgCtrlID(control_handle=0) } }
      spec { use { control_id = get_dlg_ctrl_id(control_handle=0) } }

      it "retrieves the identifier of the specified control" do
        test_app_with_dialog do |app, dialog|
          control = find_window_ex(dialog, 0, "Button", "&Yes")
          get_dlg_ctrl_id(control).should == IDYES
        end
      end

      it "returns 0/nil for invalid control (say, if given handle is top level window" do
        invalid_control = find_window(nil, nil) # Top level, so it must be invalid
        GetDlgCtrlID(invalid_control).should == 0
        get_dlg_ctrl_id(invalid_control).should == nil
      end

    end # describe get_dlg_ctrl_id

  end
end

