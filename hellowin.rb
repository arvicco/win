require 'ffi'

module HelloWin
  extend FFI::Library

  ffi_lib 'user32'
  ffi_convention :stdcall

  attach_function :message_box, :MessageBoxA,[ :pointer, :string, :string, :uint ], :int
  attach_function :SendMessageW, [:long, :int, :int, :pointer], :int
  #attach_function :send_two, :SendMessage, [:ulong, :uint, :uint, :pointer], :int

end

p HelloWin.respond_to?(:send_one)
p HelloWin.respond_to?(:send_two)

rc = HelloWin.message_box nil, 'Hello Windows!', 'FFI on Windows', 1
puts "Return code: #{rc}"

