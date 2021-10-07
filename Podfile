source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.1'

target 'StoryIDDemo' do
  use_frameworks!

  pod 'InputMask'
  pod 'Former'
  pod 'SKPhotoBrowser'
  pod 'BiometricAuthentication'
  pod 'Valet'
  pod 'StoryID', :path => './StoryID'

end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
