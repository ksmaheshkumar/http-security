require "spec_helper"
require "http/security/response"

describe Response do
  subject { described_class }

  describe "#initialize" do
    subject do
      described_class.new(
      )
    end
  end

  describe ".parse_header" do
    let(:name)  { 'Set-Cookie' }
    let(:value) { "_twitter_sess=BAh7CSIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo%250ASGFzaHsABjoKQHVzZWR7ADoPY3JlYXRlZF9hdGwrCOzcmMpJAToMY3NyZl9p%250AZCIlYmEzNTQ5YzM0MzYwZjAzZWMwMTFmZDY3MzVhMjE0MzM6B2lkIiUxMzI3%250AY2M1OWIyYzM3N2IzMmYxZWZiNmJlN2ZmYzdjZQ%253D%253D--09c51d06332d2b4cf102948a3f0491131ed952fa; Path=/; Domain=.twitter.com; Secure; HTTPOnly, guest_id=v1%3A141644325604142464; Domain=.twitter.com; Path=/; Expires=Sat, 19 Nov 2016 00:27:36 GMT" }

    it "should parse the given headre" do
      expect(subject.parse_header(name,value)).to be == [
        {
          cookie:    {:_twitter_sess=>"BAh7CSIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo%250ASGFzaHsABjoKQHVzZWR7ADoPY3JlYXRlZF9hdGwrCOzcmMpJAToMY3NyZl9p%250AZCIlYmEzNTQ5YzM0MzYwZjAzZWMwMTFmZDY3MzVhMjE0MzM6B2lkIiUxMzI3%250AY2M1OWIyYzM3N2IzMmYxZWZiNmJlN2ZmYzdjZQ%253D%253D--09c51d06332d2b4cf102948a3f0491131ed952fa"},
          path:      "/",
          domain:    ".twitter.com",
          secure:    "Secure",
          http_only: "HTTPOnly"
        },
        {
          cookie:  {:guest_id=>"v1%3A141644325604142464"},
          domain:  ".twitter.com",
          path:    "/",
          expires: Date.parse('Sat, 19 Nov 2016 00:27:36 GMT')
        }
      ]
    end
  end

  describe ".parse" do
    let(:response) do
      {
        "Cache-Control" => "no-cache, no-store, must-revalidate, pre-check=0, post-check=0",
        "Content-Length" => "12682",
        "Content-Security-Policy" => "default-src https:; connect-src https:; font-src https: data:; frame-src https: twitter:; img-src https: data:; media-src https:; object-src https:; script-src 'unsafe-inline' 'unsafe-eval' https:; style-src 'unsafe-inline' https:; report-uri https://twitter.com/i/csp_report?a=NVQWGYLXFVZXO2LGOQ%3D%3D%3D%3D%3D%3D&ro=false;",
        "Content-Security-Policy-Report-Only" => "default-src https:; connect-src https:; font-src https: data:; frame-src https: twitter:; img-src https: data:; media-src https:; object-src https:; script-src 'unsafe-inline' 'unsafe-eval' https:; style-src 'unsafe-inline' https:; report-uri https://twitter.com/i/csp_report?a=NVQWGYLXFVZXO2LGOQ%3D%3D%3D%3D%3D%3D&ro=false;",
        "Content-Type" => "text/html;charset=utf-8",
        "Date" => "Thu, 20 Nov 2014 00:27:36 UTC",
        "Expires" => "Tue, 31 Mar 1981 05:00:00 GMT",
        "Last-Modified" => "Thu, 20 Nov 2014 00:27:36 GMT",
        "Ms" => "A",
        "Pragma" => "no-cache",
        "Server" => "tsa_b",
        "Set-Cookie" => 
        "_twitter_sess=BAh7CSIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo%250ASGFzaHsABjoKQHVzZWR7ADoPY3JlYXRlZF9hdGwrCOzcmMpJAToMY3NyZl9p%250AZCIlYmEzNTQ5YzM0MzYwZjAzZWMwMTFmZDY3MzVhMjE0MzM6B2lkIiUxMzI3%250AY2M1OWIyYzM3N2IzMmYxZWZiNmJlN2ZmYzdjZQ%253D%253D--09c51d06332d2b4cf102948a3f0491131ed952fa; Path=/; Domain=.twitter.com; Secure; HTTPOnly, guest_id=v1%3A141644325604142464; Domain=.twitter.com; Path=/; Expires=Sat, 19 Nov 2016 00:27:36 GMT",
        "Status" => "200 OK",
        "Strict-Transport-Security" => "max-age=631138519",
        "X-Connection-Hash" => "f58cf3aa568cfd2abfd6a259c85a453b",
        "X-Content-Type-Options" => "nosniff",
        "X-Frame-Options" => "SAMEORIGIN",
        "X-Transaction" => "a0c1a67d4d799176",
        "X-Permitted-Cross-Domain-Policies" => "none",
        "X-Ua-Compatible" => "IE=edge,chrome=1",
        "X-Xss-Protection" => "1; mode=block"
      }
    end

    subject { described_class.parse(response) }

    it "should parse Cache-Control" do
      expect(subject.cache_control).to_not be_nil
    end

    it "should parse Content-Security-Policy" do
      expect(subject.content_security_policy).to_not be_nil
    end

    it "should parse Content-Security-Policy-Report-Only" do
      expect(subject.content_security_policy_report_only).to_not be_nil
    end

    it "should parse Expires" do
      expect(subject.expires).to_not be_nil
    end

    it "should parse Pragma" do
      expect(subject.pragma).to_not be_nil
    end

    it "should parse Set-Cookie" do
      expect(subject.set_cookie).to_not be_nil
    end

    it "should parse Strict-Transport-Security" do
      expect(subject.strict_transport_security).to_not be_nil
    end

    it "should parse X-Content-Type-Options" do
      expect(subject.x_content_type_options).to_not be_nil
    end

    it "should parse X-Frame-Options" do
      expect(subject.x_frame_options).to_not be_nil
    end

    it "should parse X-Permitted-Cross-Domain-Policies" do
      expect(subject.x_permitted_cross_domain_policies).to_not be_nil
    end

    it "should parse X-XSS-Protection" do
      expect(subject.x_xss_protection).to_not be_nil
    end

    context "when parsing a malformed headers" do
      let(:response) do
        {
          "Date"=>"Sat, 24 Jan 2015 01:06:57 GMT",
          "X-Servedby"=>"ny1-prod6-web022.int.peer1.squarespace.net",
          "Set-Cookie"=>
          "JSESSIONID=3bGO1nRYPl_-0xhNbk8nlpt-5ulKdHw9_ofbsM_wsJ-Wcul2ODOLqQ;Path=/;HttpOnly, crumb=ce3ba8cfc3;Path=/, SS_MID=0763cce4-5adf-4332-a545-f5b4ebefd803i5aarqtx;Path=/;Domain=.singularads.com;Expires=Tue, 21-Jan-2025 01:06:57 GMT",
          "Expires"=>"Thu, 01 Jan 1970 00:00:00 GMT",
          "Accept-Ranges"=>"bytes",
          "Content-Type"=>"text/html; charset=UTF-8",
          "X-Pc-Appver"=>"3070",
          "Content-Encoding"=>"gzip",
          "X-Pc-Date"=>"Fri, 23 Jan 2015 21:00:13 GMT",
          "X-Pc-Host"=>"10.100.101.11",
          "Etag"=>"W/\"0eaeb395a0f1a569174a067510085a66\"",
          "X-Pc-Key"=>"m7ZrcPWNTQjYc6jL7aW2oRSLPko-daniel-matalon-vim3",
          "X-Pc-Hit"=>"true",
          "Content-Length"=>"27469",
          "X-Contextid"=>"nLOTffVs/ksjmZDEy",
          "X-Via"=>"1.1 ny1-prod-echo016.int.peer1.squarespace.net"
        }
      end

      it "should map exceptions to MalformedHeader objects" do
        expect(subject.set_cookie).to be_kind_of(MalformedHeader)
      end
    end

    context "Alexa 100", :gauntlet do
      require 'csv'
      require 'net/http'

      path = File.expand_path('../data/alexa.csv', __FILE__)
      csv  = CSV.new(open(path), headers: false)

      csv.each do |row|
        rank, domain = row[0].to_i, row[1].downcase

        context domain do
          it "should not raise a ParseError" do
            begin
              response = Net::HTTP.get_response(URI("http://#{domain}/"))

              expect {
                described_class.parse(response)
              }.to_not raise_error(Parslet::ParseError)
            rescue => error
              pending error.message
            end
          end
        end
      end
    end
  end

  describe ".parse!" do
    let(:response) do
      {
        "Date"=>"Sat, 24 Jan 2015 01:06:57 GMT",
        "X-Servedby"=>"ny1-prod6-web022.int.peer1.squarespace.net",
        "Set-Cookie"=>
        "JSESSIONID=3bGO1nRYPl_-0xhNbk8nlpt-5ulKdHw9_ofbsM_wsJ-Wcul2ODOLqQ;Path=/;HttpOnly, crumb=ce3ba8cfc3;Path=/, SS_MID=0763cce4-5adf-4332-a545-f5b4ebefd803i5aarqtx;Path=/;Domain=.singularads.com;Expires=Tue, 21-Jan-2025 01:06:57 GMT",
          "Expires"=>"Thu, 01 Jan 1970 00:00:00 GMT",
          "Accept-Ranges"=>"bytes",
          "Content-Type"=>"text/html; charset=UTF-8",
          "X-Pc-Appver"=>"3070",
          "Content-Encoding"=>"gzip",
          "X-Pc-Date"=>"Fri, 23 Jan 2015 21:00:13 GMT",
          "X-Pc-Host"=>"10.100.101.11",
          "Etag"=>"W/\"0eaeb395a0f1a569174a067510085a66\"",
          "X-Pc-Key"=>"m7ZrcPWNTQjYc6jL7aW2oRSLPko-daniel-matalon-vim3",
          "X-Pc-Hit"=>"true",
          "Content-Length"=>"27469",
          "X-Contextid"=>"nLOTffVs/ksjmZDEy",
          "X-Via"=>"1.1 ny1-prod-echo016.int.peer1.squarespace.net"
      }
    end

    context "when parsing malformed headers" do
      it "should raise a Parslet::ParseFailed exception" do
        expect {
          subject.parse!(response)
        }.to raise_error(Parslet::ParseFailed)
      end
    end
  end
end
