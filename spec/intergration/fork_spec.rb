
# frozen_string_literal: true

RSpec.describe 'forking' do
  include Dry::Effects.State(:counter)
  include Dry::Effects::Handler.State(:counter)
  include Dry::Effects.Fork
  include Dry::Effects::Handler.Fork

  it 'duplicates a handler with the current stack' do
    result = handle_fork do
      handle_counter(0) do
        self.counter += 1
        fork do
          self.counter += 10
          :done
        end
      ensure
        self.counter += 1
      end
    end

    expect(result).to eql([2, :done])
  end
end
