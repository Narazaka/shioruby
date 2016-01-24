require 'shioruby'

describe Shioruby do
  it "can parse request" do
    request = Shioruby.parse_request(<<-EOS
GET SHIORI/3.0
Charset: UTF-8
Sender: ikagaka
ID: OnClose
Reference0: user

    EOS
    )
    expect(request).to match OpenStruct.new({
      method: 'GET',
      version: '3.0',
      Charset: 'UTF-8',
      Sender: 'ikagaka',
      ID: 'OnClose',
      Reference0: 'user',
    })
  end

  it "can build response" do
    response = OpenStruct.new({
      code: 200,
      version: '3.0',
      Value: '\h\s[0]\e',
      Charset: 'UTF-8',
      Sender: 'shioruby',
    })
    response_str = Shioruby.build_response(response)
    expect(response_str).to be == <<-EOS
SHIORI/3.0 200 OK
Value: \\h\\s[0]\\e
Charset: UTF-8
Sender: shioruby

    EOS
  end
end

describe String do
  it 'can separate \x01' do
    expect("a\x01b\x01c".separated).to match ['a', 'b', 'c']
  end

  it 'can separate \x01,\x02' do
    expect("a1\x01a2\x02b1\x01b2".separated2).to match [['a1', 'a2'], ['b1', 'b2']]
  end
end

describe Array do
  it 'can combine \x01' do
    expect(['a', 'b', 'c'].combined).to be == "a\x01b\x01c"
  end

  it 'can combine \x01,\x02' do
    expect([['a1', 'a2'], ['b1', 'b2']].combined2).to be == "a1\x01a2\x02b1\x01b2"
  end
end
