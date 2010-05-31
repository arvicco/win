require 'win/library'
require 'win/gui/window'

module Win
  module Gui
    # Contains constants and Win32API functions related to dialog manipulation
    #
    module Dialog

      # IDs of standard dialog controls and items
      IDOK = 1
      IDCANCEL = 2
      IDABORT = 3
      IDRETRY = 4
      IDIGNORE = 5
      IDYES = 6
      IDNO = 7
      ErrorIcon = 0x0014

      include Win::Library
      include Win::Gui::Window

      ##
      # The GetDlgItem function retrieves a handle to a control in the specified dialog box.
      #
      # [*Syntax*]  HWND GetDlgItem( HWND hDlg, int nIDDlgItem );
      #
      # hDlg:: <in> Handle to the dialog box that contains the control.
      # nIDDlgItem:: <in> Specifies the identifier of the control to be retrieved.
      # *Returns*:: If the function succeeds, the return value is the window handle of the specified control.
      #             If the function fails, the return value is NULL, indicating an invalid dialog box handle
      #             or a nonexistent control. To get extended error information, call GetLastError.
      # ---
      # *Remarks*:
      # You can use the GetDlgItem function with any parent-child window pair, not just with dialog boxes.
      # As long as the hDlg parameter specifies a parent window and the child window has a unique identifier
      # (as specified by the hMenu parameter in the CreateWindow or CreateWindowEx function that created the 
      # child window), GetDlgItem returns a valid handle to the child window.
      #
      # :call-seq:
      #   control_handle = [get_]dlg_item( dialog_handle, id )
      #
      function :GetDlgItem, [:ulong, :int], :ulong

    end
  end
end


