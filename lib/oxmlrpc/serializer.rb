module OXMLRPC
  class Serializer
    def initialize(data = {})
      @data = data
    end

    def to_rpc
      doc = Ox::Document.new(:version => '1.0')
      doc << mr = Ox::Element.new('methodResponse')
      mr << params = Ox::Element.new('params')
      params << param = Ox::Element.new('param')
      param << serialize(@data)
      Ox.dump(doc, :indent => -1)
    end

    private

    def serialize(sth)
      case sth
      when String then serialize_string(sth)
      when Integer then serialize_integer(sth)
      when Hash then serialize_hash(sth)
      when Array then serialize_array(sth)
      else
        raise "Uknkown type"
      end
    end

    def serialize_hash(hash)
      value = Ox::Element.new('value')
      value << struct = Ox::Element.new('struct')
      hash.each do |key, value|
        struct << member = Ox::Element.new('member')
        member << (Ox::Element.new('name') << key.to_s)
        member << serialize(value)
      end
      value
    end

    def serialize_array(arr)
      value = Ox::Element.new('value')
      value << array = Ox::Element.new('array')
      array << data = Ox::Element.new('data')
      arr.each do |element|
        data << serialize(element)
      end
      value
    end

    def serialize_string(string)
      value = Ox::Element.new('value')
      value << string
      value
    end

    def serialize_integer(integer)
      value = Ox::Element.new('value')
      value << int = Ox::Element.new('int')
      value << integer.to_s
      value
    end
  end
end
