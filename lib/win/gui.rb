require 'win/gui/window'
require 'win/gui/input'
require 'win/gui/message'
require 'win/gui/dialog'

module Win
  
  # Contains several modules defining Win32 API functions and constants related to Windows GUI (Graphical User Interface)
  #
  module GUI
    include Win::GUI::Window
    include Win::GUI::Input
    include Win::GUI::Message
    include Win::GUI::Dialog
  end
end
