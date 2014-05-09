platform :ios, '5.0'
pod 'RestKit',       '~> 0.20.3'
pod 'MBProgressHUD', '~> 0.5'
pod 'SDWebImage',    '~> 3.6'
pod 'WEPopover',     '~> 0.0.1'
pod 'Mixpanel',      '~> 1.1.1'
pod 'Parse',         '~> 1.2.19'
pod 'Facebook-iOS-SDK', '~> 3.14.0'
pod 'TestFlightSDK', '~> 3.0.0'

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DIRECT_OBJC_ISA_USAGE'] = 'YES'
        end
    end
end;