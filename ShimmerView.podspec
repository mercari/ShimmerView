# ShimmerView.podspec

Pod::Spec.new do |s|
  s.name         = "ShimmerView"
  s.version      = "0.4.0"
  s.summary      = "A framework to create Skelton View + Shimmering Effect type loading indicator on UIKit and SwiftUI."
  s.homepage     = "https://github.com/mercari/ShimmerView"
  s.license      = "MIT"
  s.author       = ['Mercari, Inc.']
  s.swift_version = "5.0"
  s.ios.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/mercari/ShimmerView.git", :tag => s.version }
  s.source_files = "ShimmerView/**/*.swift"
end
