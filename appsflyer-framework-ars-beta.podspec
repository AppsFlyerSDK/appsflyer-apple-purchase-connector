Pod::Spec.new do |s|
    s.name             = 'appsflyer-framework-ars-beta'
    s.version          = '6.4.0'
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
    s.platform     = :ios, :tvos, :osx

    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.11'

    s.ios.frameworks = 'Security', 'SystemConfiguration', 'CoreTelephony'
    s.osx.frameworks  = 'Security'


    ss.ios.preserve_paths = 'AppsFlyerLib.xcframework'
    ss.ios.vendored_frameworks = 'AppsFlyerLib.xcframework'

    ss.tvos.preserve_paths = 'AppsFlyerLib.xcframework'
    ss.tvos.vendored_frameworks = 'AppsFlyerLib.xcframework'

    ss.osx.preserve_paths = 'AppsFlyerLib.xcframework'
    ss.osx.vendored_frameworks = 'AppsFlyerLib.xcframework'


end
