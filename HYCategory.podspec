Pod::Spec.new do |s|
  s.name             = 'HYCategory'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HYCategory.'
  s.description      = 'A short description of HYCategory.'

  s.homepage         = 'https://github.com/fangyuxi/HYCategory'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fangyuxi' => 'xcoder.fang@gmail.com' }
  s.source           = { :git => 'https://github.com/fangyuxi/HYCategory.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.source_files = 'HYCategory/Classes/**/*'


    s.subspec 'Core' do |spec|
    spec.requires_arc = false
    spec.compiler_flags = '-ObjC'
    spec.source_files = 'HYCategory/Classes/Foundation/NSThread+Runloop.m'
    end

  # s.resource_bundles = {
  #   'HYCategory' => ['HYCategory/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
