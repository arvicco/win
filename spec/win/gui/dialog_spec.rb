require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'

module WinGuiDialogTest

  include WinTestApp
  include Win::Gui::Dialog

  def test_app_with_dialog(type=:close)
    test_app do |app|
      case type
        when :close
          keystroke('A')
          shut_window app.handle
          sleep 0.01 until dialog = find_window(nil, "Steganos Locknote")
        when :save
          keystroke(VK_ALT, 'F', 'A')
          sleep 0.01 until dialog = find_window(nil, "Save As")
      end
      yield app, dialog
      keystroke(VK_ESCAPE)
    end
  end

  describe Win::Gui::Dialog do

    describe "#message_box" do
      spec{ pending; use{ selected_item = message_box(owner_handle=0, text="Text", caption="Caption", type=0) }}

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
      spec{ use{ control_handle = get_dlg_item(handle = 0, item_id = 1) }}

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

    end
  end
end

