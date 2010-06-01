require 'spec_helper'

describe 'virus check service' do

  it "should passed clean virus check status for clean file" do
    file_string = File.read "spec/files/ateam.tiff"
    post "/", 'data' => file_string
    last_response.should have_event(:type => "virus check", :outcome => "passed")
  end

  it "should return failed virus check event for infected file" do
    file_string = File.read "spec/files/eicar.com"
    post "/", 'data' => file_string
    last_response.should be_ok
    last_response.should have_event(:type => "virus check", :outcome => "failed")
  end

  it "should return 400 if data is missing" do
    post "/"
    last_response.status.should == 400
  end

end
