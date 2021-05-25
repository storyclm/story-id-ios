Pod::Spec.new do |s|
  s.name		= "StoryID"
  s.version		= "0.5.2"
  s.license		= "MIT"
  s.homepage	= "https://breffi.ru/en/storyclm"
  s.author 		= "Breffi LLC"
  s.summary		= "StoryID is the module of Story platform"
  s.description	= "<<-DESC
                     Story— a digital-platform developed by BREFFI, allowing you to create interactive presentations with immediate feedback on the change in the customer perception of the brand and the representative’s activity.
                   DESC"                 

  s.source      = { :git => "https://github.com/storyclm/story-id-ios", :tag => s.version.to_s }
  
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2', 'OTHER_LDFLAGS' => '-all_load' }

  s.source_files 		= 'StoryID/StoryID/**/*.{h,swift}'
  s.public_header_files	= 'StoryID/StoryID/*.h'
  s.resources 			= 'StoryID/StoryID/**/*.xcdatamodeld'

  s.ios.deployment_target	= "11.0"
  s.swift_version			= "5.0"

  s.dependency 'Alamofire', '~> 4.9'
  s.dependency 'AlamofireImage', '~> 3.5'
  s.dependency 'p2.OAuth2', '~> 5.2'
  s.dependency 'CryptoSwift', '~> 1.3'

end