require 'win/library'

module Win
  module Gui
    # Contains constants and Win32API functions related to inter-Window messaging
    #
    module Message
      include Win::Library

      # Windows Message Get Text
      WM_GETTEXT = 0x000D
      # Windows Message Sys Command
      WM_SYSCOMMAND = 0x0112
      # Sys Command Close
      SC_CLOSE = 0xF060

      function 'PostMessage', 'LLLL', 'L'
      function 'SendMessage', 'LLLP', 'L'
    end
  end
end

