require 'spec_helper'
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
  end
end
