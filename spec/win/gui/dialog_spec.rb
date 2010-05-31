require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'win/gui/input'
#require 'win/gui/window'

module WinWindowTest

  include WinTestApp
  include Win::Gui::Dialog

  describe Win::Gui::Dialog do

    describe '#get_dlg_item' do
      spec{ use{ control_handle = get_dlg_item(handle = 0, item_id = 1) }}

      it 'returns handle to correctly specified control'

    end
  end
end

