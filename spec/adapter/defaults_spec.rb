require 'helper'

describe Adapter::Defaults do
  let(:mod) do
    Module.new.tap do |m|
      m.extend(Adapter::Defaults)
    end
  end

  describe "#key_for" do
    it "returns value for string" do
      mod.key_for('foo').should == 'foo'
    end

    it "returns string for symbol" do
      mod.key_for(:foo).should == 'foo'
    end

    it "marshals anything not a string or symbol" do
      mod.key_for({'testing' => 'this'}).should == %Q(\x04\b{\x06I\"\ftesting\x06:\x06EFI\"\tthis\x06;\x00F)
    end
  end

  describe "#encode" do
    it "marshals value" do
      mod.encode(nil).should == "\004\b0"
      mod.encode({'testing' => 'this'}).should == %Q(\x04\b{\x06I\"\ftesting\x06:\x06EFI\"\tthis\x06;\x00F)
    end
  end

  describe "#decode" do
    it "returns nil if nil" do
      mod.decode(nil).should be_nil
    end

    it "returns marshal load if not nil" do
      mod.decode(%Q(\x04\b{\x06I\"\ftesting\x06:\x06EFI\"\tthis\x06;\x00F)).should == {'testing' => 'this'}
    end
  end
end