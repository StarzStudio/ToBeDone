source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0' 
use_frameworks!
target 'ToBeDone' do
    
    pod 'Toast-Swift', '~> 2.0.0'
    
    #firebase
    #pod 'Firebase/Core'
    pod 'Firebase/Storage' 
    #pod 'Firebase/AdMob'
    pod 'Firebase/Auth'
    pod 'Firebase/Crash'
    pod 'Firebase/Database'
    #pod 'Firebase/RemoteConfig'
    #firebase
    
    
    pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    #pod 'Popover'
    #pod 'AZExpandableIconListView'
    pod 'TRMosaicLayout'
    pod 'FoldingCell’, '~> 2.0.1'
    pod 'M13Checkbox'
    pod 'AFDateHelper', '~> 3.5.3'
    pod 'SnapKit', '~> 3.0'
    pod 'TagListView', '~> 1.0'
    pod 'SwiftMessages'
    pod 'Material', '~> 2.0'
    #pod 'IGListKit', '~> 1.0.0'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'FlowingMenu', '~> 2.0.1'
    pod 'GuillotineMenu', '~> 3.0'
    pod 'Material', '~> 2.0'
    pod 'ExpandingMenu', '~> 0.3'
    pod 'RKTagsView'
    pod 'FlatUIKit'
    pod 'MKDropdownMenu'
    
    # lint to enforce Swift style
    # pod 'SwiftLint'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
