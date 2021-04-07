require "spec_helper"

RSpec.describe YachtSanitizer do
  EXPECTED = {
    label: "Sun Fast 40",
    price: 98000,
    year: 2001,
    loa: 1140,
    boa: 390,
    condition: 1
  }.freeze

  describe "#logger", :focus do
    it "return expected array of errors" do
      data = {
        year: 2001,
        loa: 1140,
        boa: 390,
        condition: 1
      }

      yacht_sanitizer = YachtSanitizer.new(data)

      yacht_sanitizer.to_h

      expect(yacht_sanitizer.logger).to eq(["key not found: :label", "key not found: :price"])
    end

    it "return expected array of errors" do
      data = {
        label: nil,
        price: nil,
        year: 2001,
        loa: 1140,
        boa: 390,
        condition: 1
      }

      yacht_sanitizer = YachtSanitizer.new(data)

      yacht_sanitizer.to_h

      expect(yacht_sanitizer.logger).to eq(["key not found: :label", "key not found: :price"])
    end

    it "return expected range error for invalid year" do
      data = {
        label: "Sun Fast 40",
        price: 98000,
        year: 0,
        loa: 1140,
        boa: 390,
        condition: 1
      }
      current_year = Time.new.year

      yacht_sanitizer = YachtSanitizer.new(data)

      yacht_sanitizer.to_h

      expect(yacht_sanitizer.logger).to eq(["RangeError: Value of [0] outside bounds of [#{Yacht::FIRST_JEANNEAU_BOAT}] to [#{current_year}]."])
    end

    it "return expected range error for invalid length" do
      data = {
        label: "Sun Fast 40",
        price: 98000,
        year: 2001,
        loa: 0,
        boa: 390,
        condition: 1
      }
      current_year = Time.new.year
  
      yacht_sanitizer = YachtSanitizer.new(data)
  
      yacht_sanitizer.to_h
  
      expect(yacht_sanitizer.logger).to eq(["RangeError: Value of [0] outside bounds of [#{Yacht::MIN_LENGTH}] to [#{Yacht::MAX_LENGTH}]."])
    end

    it "return expected range error for invalid length" do
      data = {
        label: "Sun Fast 40",
        price: 98000,
        year: 2001,
        loa: 1140,
        boa: 0,
        condition: 1
      }
      current_year = Time.new.year
  
      yacht_sanitizer = YachtSanitizer.new(data)
  
      yacht_sanitizer.to_h
  
      expect(yacht_sanitizer.logger).to eq(["RangeError: Value of [0] outside bounds of [#{Yacht::MIN_BEAM}] to [#{Yacht::MAX_BEAM}]."])
    end
  end

  describe "#to_h" do
    it "return hash of sanitized data with valid input" do
      data = EXPECTED.dup
      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return hash of sanitized data with string price '98 000€ ttc'" do
      data = EXPECTED.dup
      data[:price] = "98 000€ ttc"

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return hash of sanitized data with string price '98 000€ ttc'" do
      data = EXPECTED.dup
      data[:price] = "98 000"

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return hash of sanitized data with string year '2001'" do
      data = EXPECTED.dup
      data[:year] = "2001"

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return hash of sanitized data with string loa '11.4m'" do
      data = EXPECTED.dup
      data[:loa] = "11.4m"

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return hash of sanitized data with string boa '3.9m'" do
      data = EXPECTED.dup
      data[:boa] = "3.9m"

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return hash of sanitized data with string condition 'très bon'" do
      data = EXPECTED.dup
      data[:condition] = "très bon"

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq(EXPECTED)
    end

    it "return empty hash with empty label" do
      data = {
        price: 98000,
        year: 2001,
        loa: 1140,
        boa: 390,
        condition: 1
      }

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq({})
    end

    it "return empty hash with empty price" do
      data = {
        label: "Sun Fast 40",
        year: 2001,
        loa: 1140,
        boa: 390,
        condition: 1
      }

      sanitized_data = YachtSanitizer.new(data).to_h

      expect(sanitized_data).to eq({})
    end
  end
end