Pod::Spec.new do |spec|
  spec.name               = "ExpoFpGpsProvider"
  spec.version            = "4.2.0"
  spec.platform           = :ios, '14.0'
  spec.summary            = "ExpoFP GPS location provider"
  spec.description        = "GPS location provider for ExpoFP SDK"
  spec.homepage           = "https://www.expofp.com"
  spec.documentation_url  = "https://expofp.github.io/expofp-mobile-sdk/ios-sdk"
  spec.license            = { :type => "MIT" }
  spec.author                = { 'ExpoFP' => 'support@expofp.com' }
  spec.source             = { :git => 'https://github.com/expofp/expofp-gpsprovider-ios.git', :tag => "#{spec.version}" }
  spec.swift_version      = "5"

  # Supported deployment targets
  spec.ios.deployment_target  = "14.0"

  # Published binaries
  spec.ios.vendored_frameworks = "xcframework/ExpoFpGpsProvider.xcframework"

  # Add here any resources to be exported.
  spec.dependency 'ExpoFpCommon', '4.2.0'

end
