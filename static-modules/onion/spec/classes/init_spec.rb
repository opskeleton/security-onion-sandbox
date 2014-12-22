require 'spec_helper'
describe 'onion' do

  context 'with defaults for all parameters' do
    it { should contain_class('onion') }
  end
end
