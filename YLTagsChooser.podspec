
Pod::Spec.new do |s|

  s.name         = "YLTagsChooser"
  s.version      = "1.0"
  s.summary      = "用UICollectionView实现的兴趣标签选择器 (A interest tag selector implemented with the UICollectionView.)"
  s.homepage     = "https://github.com/lqcjdx/YLTagsChooser"
  s.license      = "MIT"
  s.author       = { "lgcjdx" => "lgcjdx@163.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/lqcjdx/YLTagsChooser.git", :tag => "#{s.version}" }
  s.source_files = "YLTagsChooser/YLTagsChooser/TagsChooser/*.{h,m}"
  s.requires_arc = true
end
