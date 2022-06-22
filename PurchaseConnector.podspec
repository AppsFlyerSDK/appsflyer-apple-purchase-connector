Pod::Spec.new do |s|


    s.name             = 'PurchaseConnector'
    s.version          = '6.6.0'
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

    s.ios.deployment_target = '9.0'

    s.ios.frameworks = 'Security', 'SystemConfiguration', 'CoreTelephony'
    s.ios.dependency 'AppsFlyerFramework/Dynamic', "~> #{s.version}"

    s.ios.preserve_paths = 'PurchaseConnector.xcframework'
    s.ios.vendored_frameworks = 'PurchaseConnector.xcframework'


end
