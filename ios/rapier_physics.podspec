#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rapier_physics.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rapier_physics'
  s.version          = '0.3.0'
  s.summary          = 'Rapier Physics plugin project.'
  s.description      = <<-DESC
A Rapier Physics plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'

  s.vendored_frameworks = 'rapier_ffi.xcframework'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-all_load'
  }
end
