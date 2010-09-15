require 'spec_helper'

describe 'virus check service' do

  it "should passed clean virus check status for clean file" do
    visit '/'
    attach_file 'data', File.join(File.dirname(__FILE__), 'files/ateam.tiff')
    click_button 'check'
    last_response.should have_event(:type => "virus check", :outcome => "passed")
  end

  it "should return failed virus check event for infected file" do
    visit '/'
    attach_file 'data', File.join(File.dirname(__FILE__), 'files/eicar.com')
    click_button 'check'
    last_response.should be_ok
    last_response.should have_event(:type => "virus check", :outcome => "failed")
  end

  it "should return 400 if data is missing" do
    visit '/'
    click_button 'check'
    last_response.status.should == 400
  end

end
