source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0' 
use_frameworks!
target 'ToBeDone' do
    
    #pod 'Toast-Swift', '~> 2.0.0'
    
    
    
    pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    #pod 'Popover'
    #pod 'AZExpandableIconListView'
    pod 'FoldingCell’, '~> 2.0.1'
    #pod 'M13Checkbox'
    pod 'AFDateHelper', '~> 4.2.2'
    pod 'SwiftMessages'
    pod 'IGListKit', '~> 1.0.0'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'FlowingMenu', '~> 2.0.1'
    pod 'RKTagsView'
    pod 'FlatUIKit'
    pod 'MKDropdownMenu'
    pod 'DZNEmptyDataSet'

    #pod 'Material', '~> 2.0'
    #pod 'ExpandingMenu', '~> 0.3'
    
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
