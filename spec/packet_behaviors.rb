
shared_examples_for "FFI::PCap::Packet" do
  it "should supply a way to get a pointer for the body" do
    @pkt.body_ptr.should_not be_nil
    ::FFI::Pointer.should === @pkt.body_ptr
  end

  it "should supply a way to get a String for the body" do
    @pkt.body.should_not be_nil
    String.should === @pkt.body
  end

  it "should supply a timestamp as a Time object" do
    @pkt.time.should_not be_nil
    Time.should === @pkt.time
  end

  it "should allow time timestamp to be changed" do
    t = Time.now
    lambda {@pkt.time = t}.should_not raise_error(Exception)
    @pkt.time.should == t
  end

  it "should return a deep copy of itself with copy()" do
    cp = @pkt.copy()
    cp.object_id.should_not == @pkt.object_id
    cp.body_ptr.object_id.should_not == @pkt.body_ptr.object_id
    cp.body.should == @pkt.body
  end
end

shared_examples_for "FFI::PCap::Packet populated" do
  it_should_behave_like "FFI::PCap::Packet"

  it "should have a non-zero packet length in the header" do
    @pkt.length.should_not == 0
  end

  it "should have a non-zero captured length in the header" do
    @pkt.captured.should_not == 0
  end

  it "should have a non-empty body" do
    @pkt.body.should_not be_empty
  end

  it "should have a non-null body pointer" do
    @pkt.body_ptr.should_not be_null
  end

end

shared_examples_for "FFI::PCap::Packet composed" do
  it "should return the expected header" do
    @pkt.header.should be_kind_of(PacketHeader)
    @pkt.header.len.should  == @test_body.size
    @pkt.header.caplen.should == @test_body.size
    @pkt.header.timestamp.to_time.to_i.should == 0
  end

  it "should return the expected body String" do
    @pkt.body.should == @test_body
  end

  it "should return a pointer to the expected body String" do
    @pkt.body_ptr.read_string(@pkt.caplen).should == @test_body
  end
end
