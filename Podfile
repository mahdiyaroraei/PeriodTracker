# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'PeriodTracker' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

pod ‘Alamofire’
pod 'RealmSwift'
pod 'AMPopTip'
pod 'KeychainSwift', '~> 8.0'
pod 'Gecco'


# Pods for Test

end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '3.1'
end
end
end
