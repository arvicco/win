require 'win/gui/window'
require 'win/gui/input'
require 'win/gui/message'
require 'win/gui/dialog'

module Win
  
  # Contains several modules defining Win32 API functions and constants related to Windows GUI (Graphical User Interface)
  #
  module Gui
    include Win::Gui::Window
    include Win::Gui::Input
    include Win::Gui::Message
    include Win::Gui::Dialog
  end
end
