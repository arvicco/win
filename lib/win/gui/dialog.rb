require 'win/library'

module Win
  module Gui
    # Contains constants and Win32API functions related to dialog manipulation
    #
    module Dialog
      include Win::Library

      function 'GetDlgItem', 'LL', 'L'
    end
  end
end


