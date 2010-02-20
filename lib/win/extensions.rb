class String
  # returns snake_case representation of string
  def snake_case
    gsub(/([a-z])([A-Z0-9])/, '\1_\2' ).downcase
  end
  
  # converts string to 'wide char' (Windows Unicode) format
  def to_w
    (self+"\x00").encode('utf-16LE')
  end
  
  # converts one-char string into keyboard-scan 'Virtual key' code
  # only letters and numbers convertable so far, need to be extended
  def to_vkeys
    unless size == 1
      raise "Can't convert but a single character: #{self}"
    end
    ascii = upcase.unpack('C')[0]
    case self
      when 'a'..'z', '0'..'9', ' '
      [ascii]
      when 'A'..'Z'
      [0x10, ascii]    # Win.const_get(:VK_SHIFT) = 0x10 Bad coupling
    else
      raise "Can't convert unknown character: #{self}"
    end
  end
end
