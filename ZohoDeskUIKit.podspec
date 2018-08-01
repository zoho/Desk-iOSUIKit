Pod::Spec.new do |spec|
spec.name          = 'ZohoDeskUIKit'
spec.version       = '0.0.7'
spec.license       = { :type => 'MIT' }
spec.homepage      = 'https://desk.zoho.com'
spec.authors       = { 'Rajeshkumar Lingavel' => 'rajeshkumar.l@zohocorp.com' }
spec.summary       = 'UIComponent framework for Desk'
spec.source        = { :git => 'https://github.com/zoho/Desk-iOSUIKit.git', :tag => spec.version }
spec.social_media_url = 'https://twitter.com/zoho'
spec.documentation_url = 'https://www.zoho.com/desk/developers/mobilesdk/ios'

spec.ios.deployment_target  = '9.0'

spec.source_files   = 'native/**/*.{swift,h,plist}'
spec.resources = 'native/**/*.{strings,xib,xcassets,strings,ttf,otf}'

spec.framework      = 'UIKit'
spec.dependency 'ZohoDeskSDK'


end
