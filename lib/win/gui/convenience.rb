require 'win/library'
require 'win/gui/window'
require 'win/gui/message'
require 'win/gui/input'

module Win
  module Gui
    # Contains convenience methods and extra wrappers for Windows Gui related functions
    #
    module Convenience
      include Win::Gui::Window
      include Win::Gui::Message
      include Win::Gui::Input

      # Internal constants:

      # Key event delay
      KEY_DELAY  = 0.00001
      # Wait delay
      SLEEP_DELAY = 0.001
      # Timeout waiting for Window to be closed
      CLOSE_TIMEOUT = 1

      # Convenience wrapper methods:

      # Hides the window and activates another window
      def hide_window(win_handle)
        show_window(win_handle, SW_HIDE)
      end

      ##
      # Tests if given window handle points to foreground (topmost) window
      #
      def foreground?(win_handle)
        win_handle == foreground_window
      end

      ##
      # Emulates combinations of (any amount of) keys pressed one after another (Ctrl+Alt+P) and then released
      # *keys should be a sequence of a virtual-key codes. The codes must be a value in the range 1 to 254.
      # For a complete list, see msdn:Virtual Key Codes.
      def keystroke(*keys)
        return if keys.empty?
        keybd_event keys.first, 0, KEYEVENTF_KEYDOWN, 0
        sleep KEY_DELAY
        keystroke *keys[1..-1]
        sleep KEY_DELAY
        keybd_event keys.first, 0, KEYEVENTF_KEYUP, 0
      end

      # types text message into window holding the focus
      def type_in(message)
        message.scan(/./m) do |char|
          keystroke(*char.to_vkeys)
        end
      end

      # finds top-level dialog window by title and yields found dialog window to block if given
      def dialog(title, seconds=3)
        d = begin
          win = WrapWindow.top_level(title, seconds)
          yield(win) ? win : nil
        rescue TimeoutError
        end
        d.wait_for_close if d
        return d
      end

      # This class is a thin wrapper around window handle
      class WrapWindow
        include Win::Gui::Window
        extend Win::Gui::Window
        include Win::Gui::Message

        attr_reader :handle

        # find top level window by title, return wrapped Window object
        def self.top_level(title, seconds=3)
          @handle = timeout(seconds) do
            sleep SLEEP_DELAY while (h = find_window nil, title) == nil; h
          end
          WrapWindow.new @handle
        end

        def initialize(handle)
          @handle = handle
        end

        # find child window (control) by title, window class, or control ID:
        def child(id)
          result = case id
            when String
              by_title = find_window_ex @handle, 0, nil, id.gsub('_', '&' )
              by_class = find_window_ex @handle, 0, id, nil
              by_title ? by_title : by_class
            when Fixnum
              get_dlg_item @handle, id
            when nil
              find_window_ex @handle, 0, nil, nil
            else
              nil
          end
          raise "Control '#{id}' not found" unless result
          WrapWindow.new result
        end

        def children
          enum_child_windows(@handle).map{|child_handle| WrapWindow.new child_handle}
        end

        # emulate click of the control identified by id
        def click(id)
          h = child(id).handle
          rectangle = [0, 0, 0, 0].pack 'LLLL'
          get_window_rect h, rectangle
          left, top, right, bottom = rectangle.unpack 'LLLL'
          center = [(left + right) / 2, (top + bottom) / 2]
          set_cursor_pos *center
          mouse_event MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0
          mouse_event MOUSEEVENTF_LEFTUP, 0, 0, 0, 0
        end

        def close
          post_message @handle, WM_SYSCOMMAND, SC_CLOSE, 0
        end

        def wait_for_close
          timeout(CLOSE_TIMEOUT) do
            sleep SLEEP_DELAY while window_visible?(@handle)
          end
        end

        def text
          buffer = "\x0" * 2048
          length = send_message @handle, WM_GETTEXT, buffer.length, buffer
          length == 0 ? '' : buffer[0..length - 1]
        end
      end
    end
  end
end