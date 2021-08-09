Pod::Spec.new do |spec|
  spec.name                  = 'YAPComponents'
  spec.version               = '0.0.1'
  spec.summary               = 'YAP Components'

  spec.homepage              = 'https://bitbucket.org/mb28/ios-yap-ui-kit/'
  spec.source                = { :git => 'https://bitbucket.org/mb28/ios-yap-ui-kit.git',
                                 :tag => 'v0.0.1' }

  spec.license               = { :type => 'Apache 2.0' }
  spec.authors               = { 'Tayyab Akram' => 'tayyab.akram@digitify.com' }
  
  spec.platform              = :ios
  spec.ios.deployment_target = '12.0'
  spec.swift_version         = '5.0'

  spec.source_files          = 'Source/**/*.swift'

  spec.resources             = ['Source/**/*.gif',
                                'Source/**/*.jpg',
                                'Source/**/*.jpeg',
                                'Source/**/*.json',
                                'Source/**/*.mp4',
                                'Source/**/*.png',
                                'Source/**/*.xcassets']

end
