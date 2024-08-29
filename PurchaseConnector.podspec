Pod::Spec.new do |s|

    s.name             = 'PurchaseConnector'
    s.version          = "6.15.2"
    s.summary          = 'AppsFlyer iOS SDK ARS Beta'

    s.description      = <<-DESC
    AppsFlyer native track allows you to find what attracts new users to your app,
    measure all your app marketing activities on one dashboard, and add new traffic sources in minutes,
    all without having to update SDK.
    DESC

    s.homepage         = 'https://www.appsflyer.com'
    s.license          = { :type => 'Proprietary', :text => 'Copyright 2018 AppsFlyer Ltd. All rights reserved.' }
    s.author           = { 'Maxim' => 'maxim\@appsflyer.com', 'af-obodovskyi' => 'ivan.obodovskyi\@appsflyer.com', 'Andrii' => 'andrii.h\@appsflyer.com' }
    s.source           = { :git => 'https://github.com/AppsFlyerSDK/appsflyer-framework-ars-beta.git', :tag => s.version.to_s }
    s.requires_arc = true
    s.platform     = :ios
    s.ios.deployment_target = '12.0'
    s.ios.frameworks = 'StoreKit'
    s.default_subspecs = 'Main'
    s.swift_version = '5.0'

    s.subspec 'Main' do |ss|
        ss.ios.dependency 'AppsFlyerFramework','6.15.2'
        ss.ios.preserve_paths = 'PurchaseConnector.xcframework'
        ss.ios.vendored_frameworks = 'PurchaseConnector.xcframework'
        ss.ios.resource_bundles = {'PurchaseConnector_Privacy' => ['Resources/PrivacyInfo.xcprivacy']}
     end

    s.subspec 'Dynamic' do |ss|
        ss.ios.dependency 'AppsFlyerFramework/Dynamic','6.15.2'
        ss.ios.preserve_paths = 'Dynamic/PurchaseConnector.xcframework'
        ss.ios.vendored_frameworks = 'Dynamic/PurchaseConnector.xcframework'
   end

    s.subspec 'Strict' do |ss|
        ss.ios.dependency 'AppsFlyerFramework/Strict','6.15.2'
        ss.ios.preserve_paths = 'PurchaseConnector.xcframework'
        ss.ios.vendored_frameworks = 'PurchaseConnector.xcframework'
        ss.ios.resource_bundles = {'PurchaseConnector_Privacy' => ['Resources/PrivacyInfo.xcprivacy']}
    end

end
