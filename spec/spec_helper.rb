Bundler.setup

RSpec::Matchers.define :order_element do |first|
  match do |actual|
    actual.index(first) < actual.index(@second)
  end

  chain :before do |second|
    @second = second
  end
end