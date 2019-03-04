Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name             = 'Sylvester'
  s.version          = '1.1'
  s.summary          = '😼 A type-safe, XPC-available SourceKitten (SourceKit) interface with some sugar.'
  s.homepage         = 'https://github.com/chriszielinski/Sylvester'
  s.screenshots     = 'https://raw.githubusercontent.com/chriszielinski/Sylvester/master/.readme-assets/header.png'


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license          = { :type => 'MIT', :file => 'LICENSE' }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author           = { 'chriszielinski' => 'chrisz@berkeley.edu' }
  s.social_media_url = 'http://twitter.com/mightbesuperman'


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform = :osx, '10.12'


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source           = { :git => 'https://github.com/chriszielinski/Sylvester.git', :tag => s.version.to_s }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.swift_version    = "4.2"

  # ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.default_subspec = 'Sylvester'
  s.dependency 'SourceKittenFramework'

#  s.subspec 'SylvesterXPC' do |xpc|
#    xpc.source_files     = 'Source/**/*.swift'
#    xpc.dependency 'Sylvester/SylvesterCommon'
#  end

  s.subspec 'Sylvester' do |core|
    core.source_files     = 'Source/**/*.swift'
    core.dependency 'Sylvester/SylvesterCommon'
  end

  s.subspec 'SylvesterCommon' do |common|
    common.source_files     = 'SylvesterCommon/**/*.swift'
  end

end