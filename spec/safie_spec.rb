RSpec.describe Safie do
  its(:version) do
    Safie::VERSION.should_not be_blank
  end

  describe 'debugging feature' do
    after { Safie.debugging = false }

    its(:logger) { should be_a Logger }
    its(:debugging?) { should == false }

    describe '.debug!' do
      before { Safie.debug! }
      its(:debugging?) { should == true }
    end

    describe '.debug' do
      it 'should enable debugging within given block' do
        Safie.debug do
          Rack::OAuth2.debugging?.should == true
          Safie.debugging?.should == true
        end
        Rack::OAuth2.debugging?.should == false
        Safie.debugging?.should == false
      end

      it 'should not force disable debugging' do
        Rack::OAuth2.debug!
        Safie.debug!
        Safie.debug do
          Rack::OAuth2.debugging?.should == true
          Safie.debugging?.should == true
        end
        Rack::OAuth2.debugging?.should == true
        Safie.debugging?.should == true
      end
    end
  end
end
