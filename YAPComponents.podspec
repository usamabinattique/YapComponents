Pod::Spec.new do |s|
  s.name             = 'YAPComponents'
  s.version          = '0.1.0'
  s.summary          = 'YAP Reusable UI Components'

  s.homepage         = 'https://bitbucket.org/mb28/ios-yap-ui-kit/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tayyab Akram' => 'tayyab.akram@digitify.com' }
  s.source           = { :git => 'https://bitbucket.org/mb28/ios-yap-ui-kit.git', :tag => s.version.to_s }

  s.platform              = :ios
  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.0'

  s.source_files     = 'YAPComponents/Classes/**/*'

  s.resource_bundles = {
    'YAPComponents' => [
      'YAPComponents/Assets/Resources/**/*.gif',
      'YAPComponents/Assets/Resources/**/*.jpg',
      'YAPComponents/Assets/Resources/**/*.jpeg',
      'YAPComponents/Assets/Resources/**/*.json',
      'YAPComponents/Assets/Resources/**/*.mp4',
      'YAPComponents/Assets/Resources/**/*.png',
      'YAPComponents/Assets/Resources/**/*.strings',
      'YAPComponents/Assets/Assets.xcassets']
  }
end
