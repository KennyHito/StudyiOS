#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

# 说明平台是ios，版本是10.0
platform :ios, '11.0'

#允许swift
use_frameworks!

# 忽略引入库的所有警告（强迫症者的福音啊）
inhibit_all_warnings!

LocationPath = './Lib/'

target 'StudyiOS' do
  pod 'Masonry', '~> 1.1.0'
  pod 'AFNetworking',:path => LocationPath + 'AFNetworking'
  pod 'HaHaHa',:path => LocationPath + 'HaHaHa'
  pod 'Test01',:path => LocationPath + 'Test01'
  
  pod 'SDWebImage', '~> 5.19.6'
  pod 'MJExtension'
  pod 'MJRefresh'
  pod 'FMDB', '~> 2.7.5'
  pod 'ReactiveObjC', '~> 3.1.1'
  pod 'FTPopOverMenu', '~> 2.1.1'
  pod 'YYText', '~> 1.0.7'
  pod 'IQKeyboardManager', '~> 6.5.10'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'MLeaksFinder', :configurations => ['Debug']
end

post_install do |installer|
  #-------------下面支持模拟器运行Podfile配置-----------------#
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      #给每个库单独指定Swift 版本
      config.build_settings["SWIFT_VERSION"] = "4.2"
      #给每个库单独指定最低支持的系统版本
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "11.0"
      #给每个库单独指定VALID_ARCHS
      config.build_settings["VALID_ARCHS"] = "arm64 x86_64"
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
  
  #------------下面两条是修复MLeaksFinder问题----------------#
  ## Fix for Xcode 12.5
  find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm","layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
  ## Fix for Xcode 13.0
  find_and_replace("Pods/FBRetainCycleDetector/fishhook/fishhook.c","indirect_symbol_bindings[i] = cur->rebindings[j].replacement;", "if (i < (sizeof(indirect_symbol_bindings) / sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }")
end

def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
    FileUtils.chmod("+w", name) #add
    text = File.read(name)
    replace = text.gsub(findstr,replacestr)
    if text != replace
      puts "Fix: " + name
      File.open(name, "w") { |file| file.puts replace }
      STDOUT.flush
    end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
