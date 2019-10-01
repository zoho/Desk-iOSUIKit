Pod::Spec.new do |s|
s.name             = "ZohoDeskUIKit"
s.version          = "1.0.0"
s.summary          = "iOS API Provoider for Desk"
s.license          = { :type => "MIT", :text=> <<-LICENSE
MIT License
Copyright (c) 2017 Zoho
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or  substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
LICENSE
}
s.homepage         = "https://www.zoho.com/desk"
s.author           = { "Zoho Desk mobile" => "desk-mobile@zohocorp.com" }
s.source        = { :git => 'https://github.com/zoho/Desk-iOSSDK.git', :tag => s.version }
s.platform         = :ios, '9.0'
s.requires_arc     = true
s.social_media_url = 'https://twitter.com/zoho'
s.documentation_url = 'https://www.zoho.com/desk/developers/mobilesdk/ios'

s.preserve_paths   = "native/ZohoDeskUIKit.framework"
s.vendored_frameworks = "native/ZohoDeskUIKit.framework"
s.frameworks       = 'UIKit'
s.dependency 'ZohoDeskSDK'
end
