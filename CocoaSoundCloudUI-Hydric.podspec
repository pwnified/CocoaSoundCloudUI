Pod::Spec.new do |s|
  s.name     = 'CocoaSoundCloudUI-Hydric'
  s.version  = '1.0.9'
  s.summary  = 'A simple way to share audio on soundcloud.com.'
  s.homepage = 'https://github.com/brightec/CocoaSoundCloudUI'
  s.author   = { 'Ullrich Schäfer' => 'ullrich@soundcloud.com',
                 'Robert Böhnke' => 'robb@soundcloud.com',
                 'Tobias Kräntzer' => 'tk@soundcloud.com',
                 'Rob Siwek' => 'robert@soundcloud.com',
                 'Vincent Garrigues' => 'vincent@soundcloud.com',
                 'Slavko Krucaj' => 'slavko@soundcloud.com',
                 'Ray Yamamoto Hilton' => 'ray@wirestorm.net' }
  s.license  = 'Apache License, Version 2.0'

  s.source   = { :git => 'https://github.com/hydricmedia/CocoaSoundCloudUI.git', :branch => 'master'}

  s.platform = :ios, '8.0'

  s.source_files = 'Sources', 'Sources/**/*.{h,m}'

  s.resource = "SoundCloud.bundle"

  s.framework = 'AddressBook'
  s.framework = 'AddressBookUI'
  s.framework = 'QuartzCore'
  s.framework = 'CoreGraphics'
  s.framework = 'CoreText'
  s.framework = 'CoreLocation'

  s.dependency 'SoundCloud-Cocoa-API'
  s.dependency 'OHAttributedLabel'
end
