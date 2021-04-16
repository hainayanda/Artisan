#
# Be sure to run `pod lib lint Artisan.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Artisan'
  s.version          = '2.0.2'
  s.summary          = 'Artisan is a DSL, MVVM and Data Binding framework for Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Artisan is a DSL, MVVM and Data Binding framework for Swift. But its more than that.
                       DESC

  s.homepage         = 'https://github.com/nayanda1/Artisan'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nayanda' => 'nayanda1@outlook.com' }
  s.source           = { :git => 'https://github.com/nayanda1/Artisan.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Artisan/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Artisan' => ['Artisan/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Draftsman', '~> 1.0.2'
  s.dependency 'Pharos', '~> 1.1.1'
  s.swift_version = '5.1'
end
