require File.join(File.dirname(__FILE__), "spec_helper" )
require 'extension'

module WinTest

  describe String do
    describe '#snake_case' do
      it 'transforms CamelCase strings' do
        'GetCharWidth32'.snake_case.should == 'get_char_width_32'
      end
      
      it 'leaves snake_case strings intact' do
        'keybd_event'.snake_case.should == 'keybd_event'
      end
    end

    describe '#camel_case' do
      it 'transforms snake_case strings' do
        'get_char_width_32'.camel_case.should == 'GetCharWidth32'
      end

      it 'leaves CamelCase strings intact' do
        'GetCharWidth32'.camel_case.should == 'GetCharWidth32'
      end
    end

    describe '#to_w' do
      it 'transcodes string to utf-16LE' do
        'GetCharWidth32'.to_w.encoding.name.should == 'UTF-16LE'
      end

      it 'ensures that encoded string is null-terminated' do
        'GetCharWidth32'.to_w.bytes.to_a[-2..-1].should == [0, 0]
      end
    end

#    context '#to_vkeys' do
#      it 'transforms number char into [equivalent key code]' do
#       ('0'..'9').each {|char| char.to_vkeys.should == char.unpack('C')}
#      end
#
#      it 'transforms uppercase letters into [shift, equivalent key code]' do
#       ('A'..'Z').each {|char| char.to_vkeys.should == [0x10, *char.unpack('C')]}
#        # Win.const_get(:VK_SHIFT) = 0x10 Bad coupling
#      end
#
#      it 'transforms lowercase letters into [(upcase) key code]' do
#       ('a'..'z').each {|char| char.to_vkeys.should == char.upcase.unpack('C')}
#      end
#
#      it 'transforms space into [equivalent key code]' do
#        " ".to_vkeys.should == " ".unpack('C')
#      end
#
#      it 'raises error if char is not implemented punctuation' do
#       ('!'..'/').each {|char| lambda {char.to_vkeys}.should raise_error CONVERSION_ERROR }
#       (':'..'@').each {|char| lambda {char.to_vkeys}.should raise_error CONVERSION_ERROR }
#       ('['..'`').each {|char| lambda {char.to_vkeys}.should raise_error CONVERSION_ERROR }
#       ('{'..'~').each {|char| lambda {char.to_vkeys}.should raise_error CONVERSION_ERROR }
#      end
#
#      it 'raises error if char is non-printable or non-ascii' do
#        lambda {1.chr.to_vkeys}.should raise_error CONVERSION_ERROR
#        lambda {230.chr.to_vkeys}.should raise_error CONVERSION_ERROR
#      end
#
#      it 'raises error if string is multi-char' do
#        lambda {'hello'.to_vkeys}.should raise_error CONVERSION_ERROR
#        lambda {'23'.to_vkeys}.should raise_error CONVERSION_ERROR
#      end
#    end
  end
end
