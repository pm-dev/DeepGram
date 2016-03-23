Pod::Spec.new do |s|
  s.name             = "DeepGram"
  s.version          = "0.1.4"
  s.summary          = "Use AI to spot keywords and get insights in audio"
  s.description      = "DeepGram uses artificial intelligence to recognize speech, search for moments, and categorize audio and video. Try it on calls, meetings, podcasts, video clips, lectures—and get actionable insights from an easy to use API."
  s.homepage         = "https://www.deepgram.com"
  s.license          = 'MIT'
  s.author           = { "Peter Meyers" => "petermeyers1@gmail.com" }
  s.source           = { :git => "https://github.com/pm-dev/DeepGram.git", :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc = true
  s.frameworks = 'Foundation'

    s.subspec 'Core' do |ss|
    ss.public_header_files = 'Pod/Classes/DeepGram.h'
    ss.source_files = 'Pod/Classes/DeepGram.{h,m}'
    ss.dependency 'AFNetworking/NSURLSession', '~> 3.0'
    end

    s.subspec 'PromiseKit' do |ss|
    ss.public_header_files = 'Pod/Classes/DeepGram+PromiseKit.h'
    ss.source_files = 'Pod/Classes/DeepGram+PromiseKit.{swift,h,m}'
    ss.dependency 'PromiseKit/CorePromise', '~> 3.0'
    ss.dependency 'DeepGram/Core'
    end

end
