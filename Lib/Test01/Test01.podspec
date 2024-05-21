
Pod::Spec.new do |s|
  s.name             = 'Test01'
  s.version          = '1.0.0'
  s.summary          = 'Test01'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
                       
  s.homepage         = 'https://www.baidu.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张三' => 'zhagnsan@baidu.com' }
  s.source           = { :git => 'https://www.baidu.com', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Test01/**/*'
  
  s.dependency 'AFNetworking'
  
end
