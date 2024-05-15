# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'RxSwiftDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RxSwiftDemo
 pod 'Moya/RxSwift'
 pod 'RxDataSources'
 pod 'NSObject+Rx'
 pod 'SwifterSwift'
 pod 'ReachabilitySwift'#网络状态监测
 pod 'Hero'#转场动画库
 pod 'DZNEmptyDataSet'#空数据集
 pod 'SnapKit'#布局库
 pod 'Toast-Swift'#Toast
 pod 'KafkaRefresh'#下拉刷新/上拉加载 库
 pod 'IQKeyboardManagerSwift'# Keyboard
end


# RxSwift Debug
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
    
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end
