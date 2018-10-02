require 'spec_helper'

RSpec.describe Domainotron do
  it "has a version number" do
    expect(Domainotron::VERSION).not_to be nil
  end

  describe 'get_domain' do
    context 'without www' do
      [
        ['http://craft.co', 'craft.co'],
        ['www.craft.co', 'craft.co'],
        ['www.craft.co/', 'craft.co'],
        ['craft.co', 'craft.co'],
        ['http://www.craft.co/test', 'craft.co'],
        ['http://www.craft.co/index.php', 'craft.co'],
        ['http://www.craft.co/test/test1', 'craft.co'],
        ['http://www.craft.co/test?abs', 'craft.co'],
        ['http://www.craft.co?test_param=1', 'craft.co'],
        ['https://www.craft.co', 'craft.co'],
        ['https://www.craft.co/test?abs=2', 'craft.co'],
        ['https://craft.co/test?abs=2', 'craft.co'],
        ['https://www.en.craft.co/test?abs=2', 'en.craft.co'],
        ['https://www.craft.co.uk/test?abs=2', 'craft.co.uk'],
        ['https://www.craft.co.test.test/test?abs=2', 'craft.co.test.test'],
        ['https://www.craft.co.test.test//', 'craft.co.test.test'],
        ['https://www.craft.co.test.test//#', 'craft.co.test.test'],
        ['//www.craft.co.test.test//#', 'craft.co.test.test'],
        ['//www.craft.co.test.test?abs=2', 'craft.co.test.test'],
        ['http://www.http-com.com/', 'http-com.com'],
        ['http-com.com/', 'http-com.com'],
        ['https://www.royalhaskoningdhv.com:443/', 'royalhaskoningdhv.com'],
        ['https://www.royalhaskoningdhv.com:443', 'royalhaskoningdhv.com'],
        ['http://www.royalhaskoningdhv.com:443/', 'royalhaskoningdhv.com'],
        ['//royalhaskoningdhv.co.uk:443/', 'royalhaskoningdhv.co.uk'],
        ['http://royalhaskoningdhv.co.uk:443/', 'royalhaskoningdhv.co.uk'],
        ['royalhaskoningdhv.co.uk:80/', 'royalhaskoningdhv.co.uk'],
        ['royalhaskoningdhv.co.uk:80/index.php', 'royalhaskoningdhv.co.uk'],
        ['royalhaskoningdhv.co.uk:443/test', 'royalhaskoningdhv.co.uk'],
        ['https://www.royalhaskoningdhv.co.uk:80?get_params=1', 'royalhaskoningdhv.co.uk'],
      ].each do |test_case|
        it "extracts #{test_case[1]} domain from #{test_case[0]}" do
          expect(subject.get_domain test_case[0]).to eq test_case[1]
        end
      end
    end

    context 'with www' do
      [
        ['http://www.craft.co', 'www.craft.co'],
        ['http://craft.co', 'craft.co'],
        ['www.craft.co', 'www.craft.co'],
        ['www.craft.co/', 'www.craft.co'],
        ['craft.co', 'craft.co'],
        ['http://www.craft.co/test', 'www.craft.co'],
        ['http://www.craft.co/index.php', 'www.craft.co'],
        ['http://www.craft.co/test/test1', 'www.craft.co'],
        ['http://www.craft.co/test?abs', 'www.craft.co'],
        ['http://www.craft.co?test_param=1', 'www.craft.co'],
        ['https://www.craft.co', 'www.craft.co'],
        ['https://www.craft.co/test?abs=2', 'www.craft.co'],
        ['https://craft.co/test?abs=2', 'craft.co'],
        ['https://www.en.craft.co/test?abs=2', 'www.en.craft.co'],
        ['https://www.craft.co.uk/test?abs=2', 'www.craft.co.uk'],
        ['https://www.craft.co.test.test/test?abs=2', 'www.craft.co.test.test'],
        ['https://www.craft.co.test.test//', 'www.craft.co.test.test'],
        ['https://www.craft.co.test.test//#', 'www.craft.co.test.test'],
        ['//www.craft.co.test.test//#', 'www.craft.co.test.test'],
        ['//www.craft.co.test.test?abs=2', 'www.craft.co.test.test'],
        ['http-com.com/', 'http-com.com'],
        ['https://www.royalhaskoningdhv.com:80/', 'www.royalhaskoningdhv.com'],
        ['https://www.royalhaskoningdhv.com:443', 'www.royalhaskoningdhv.com'],
        ['http://www.royalhaskoningdhv.com:80/', 'www.royalhaskoningdhv.com'],
        ['//royalhaskoningdhv.co.uk:443/', 'royalhaskoningdhv.co.uk'],
        ['http://royalhaskoningdhv.co.uk:443/', 'royalhaskoningdhv.co.uk'],
        ['royalhaskoningdhv.co.uk:443/', 'royalhaskoningdhv.co.uk'],
        ['www.royalhaskoningdhv.co.uk:443/index.php', 'www.royalhaskoningdhv.co.uk'],
        ['royalhaskoningdhv.co.uk:443/test', 'royalhaskoningdhv.co.uk'],
        ['https://www.royalhaskoningdhv.co.uk:443?get_params=1', 'www.royalhaskoningdhv.co.uk'],
      ].each do |test_case|
        it "extracts #{test_case[1]} domain from #{test_case[0]}" do
          expect(subject.get_domain test_case[0], remove_www: false).to eq test_case[1]
        end
      end
    end
  end
end
