Pod::Spec.new do |s|

  s.name                  = 'GKStorageKit'
  s.version               = '2.2.0'
  s.summary               = 'GKStorageKit framework.'
  s.description           = <<-DESC
                            * GKStorageKit framework
                              DESC
  s.homepage              = 'https://github.com/gligorkot/GKStorageKit'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author                = { 'Gligor Kotushevski' => 'gligorkot@gmail.com' }
  s.social_media_url      = 'https://twitter.com/gligor_nz'
  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.source                = { :git => 'https://github.com/gligorkot/GKStorageKit.git', :tag => s.version.to_s }

  s.source_files          = 'Sources/GKStorageKit/**/*'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.5' }

  s.dependency 'Valet', '~> 4.1.x'
  s.dependency 'GKBaseKit', '~> 2.0.x'
  s.requires_arc          = true
  s.swift_versions        = ['4.0', '4.1', '4.2', '5.0', '5.1', '5.2', '5.3', '5.4', '5.5']

end
