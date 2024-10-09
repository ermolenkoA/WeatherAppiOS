platform :ios, '15.0'

target 'Weather' do

  pod 'SnapKit', '~> 5.7.1'
  
  pod 'SwiftLint', '~> 0.57.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end