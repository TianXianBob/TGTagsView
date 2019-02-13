Pod::Spec.new do |s|

  s.name         = "TGTagsView"
  s.version      = "0.0.2"
  s.summary      = "一个简单的标签库。"
  s.description  = <<-DESC
                   一个方便的创建标签的三方库。支持横向标签布局和纵向标签布局。
                   DESC

  s.homepage     = "https://github.com/TianXianBob/TGTagsView"
  s.license      = "MIT"
  s.author       = { "Bob" => "bobcxc@163.com" }
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/TianXianBob/TGTagsView.git", :tag => "0.0.2" }


  s.source_files  = "Classes/**/*.{h,m}"

  s.frameworks = "Foundation","UIKit"

  s.requires_arc = true

end
