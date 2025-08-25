# frozen_string_literal: true

require 'xorcist'

# Module for obfuscating a string with a xor key
module Xorob
  def self.split_byte(str, length = 16)
    str_length = str.bytesize

    arr = []

    current = 0
    while current < str_length
      arr.push(str.byteslice(current, length))
      current += length
    end

    arr
  end

  def self.xor_string(str, key)
    length = key.bytesize
    split_arr = split_byte(str, length)

    result_arr = split_arr.map do |item|
      Xorcist.xor(item, key)
    end

    result_arr.join
  end
end
