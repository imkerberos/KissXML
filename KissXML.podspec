Pod::Spec.new do |s|
  s.name         = "KissXML"
  s.version      = "5.0.1"
  s.summary      = "A replacement for Cocoa\'s NSXML cluster of classes. Based on libxml."
  s.homepage     = "https://github.com/anagromataf/KissXML"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { 'Robbie Hanson' => 'robbiehanson@deusty.com' }
  s.source       = { :git => "https://github.com/anagromataf/KissXML.git", :tag => "#{s.version}" }

  s.source_files = 'KissXML/**/*.{h,m}'
  s.requires_arc = true
  s.library      = 'xml2'
  s.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end
