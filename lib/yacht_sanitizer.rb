class YachtSanitizer
  REQUIRED = %i(label price)

  attr_reader :logger
  def initialize(data)
    @data = data
    @logger = []
  end

  def to_h
    begin
      call
      @data
    rescue => _
      {}
    end
  end

  private

  def call
    loa
    boa
    validations
    price
    year
    condition
  end

  def validations
    required_validation
    year_validation
    length_validation
    beam_validation
  end

  def required_validation
    key_errors = []

    REQUIRED.each do |sym| 
      begin
        @data.fetch(sym) 
        raise KeyError.new("key not found: :#{sym}") if @data[sym].to_s.empty?
      rescue KeyError => e
        key_errors << e.message
      end
    end

    @logger += key_errors

    raise KeyError unless key_errors.empty?
  end

  def year_validation
    current_year = Time.new.year
    unless @data[:year].to_i.between?(Yacht::FIRST_JEANNEAU_BOAT, current_year)
      @logger << "RangeError: Value of [#{@data[:year]}] outside bounds of [#{Yacht::FIRST_JEANNEAU_BOAT}] to [#{current_year}]."

      raise RangeError
    end
  end

  def length_validation
    unless @data[:loa].to_i.between?(Yacht::MIN_LENGTH, Yacht::MAX_LENGTH)
      @logger << "RangeError: Value of [#{@data[:loa]}] outside bounds of [#{Yacht::MIN_LENGTH}] to [#{Yacht::MAX_LENGTH}]."

      raise RangeError
    end
  end

  def beam_validation
    unless @data[:boa].to_i.between?(Yacht::MIN_BEAM, Yacht::MAX_BEAM)
      @logger << "RangeError: Value of [#{@data[:boa]}] outside bounds of [#{Yacht::MIN_BEAM}] to [#{Yacht::MAX_BEAM}]."

      raise RangeError
    end
  end

  def price
    if @data[:price].to_s.include?("€")
      @data[:price] = @data[:price].split("€").first.tr(' ', '').to_i
    end

    @data[:price] = @data[:price].to_s.tr(" ", "").to_i

    @data[:price]
  end

  def year
    @data[:year] = @data[:year].to_i

    @data[:year]
  end

  def loa
    if @data[:loa].to_s.include?("m")
      @data[:loa] = m_to_cm(:loa)
    end

    @data[:loa]
  end

  def boa
    if @data[:boa].to_s.include?("m")
      @data[:boa] = m_to_cm(:boa)
    end

    @data[:boa]
  end

  def condition
    if ["bon", "très bon", "excellent"].include?(@data[:condition])
      @data[:condition] = Yacht::CONDITIONS[@data[:condition]]
    end

    @data[:condition]
  end

  def m_to_cm(sym)
    @data[sym].delete_suffix("m").to_f * 100
  end
end
