# frozen_string_literal: true
require 'rspec'
# spec/env_spec.rb
require_relative 'D:/code/matcha-shell-util/src/util/Env'

RSpec.describe Env do
  describe "#env" do
    it "returns the value of the specified environment variable" do
      ENV['MY_VAR'] = 'my_value'
      result = env(a: 'MY_VAR')
      expect(result).to eq('my_value')
    end

    it "returns nil if the specified environment variable is not set" do
      result = env(a: 'NON_EXISTENT_VAR')
      expect(result).to be_nil
    end
  end
end