Pod::Spec.new do |s|
  s.name         = "PScrollContainer"
  s.version      = "0.1.4"
  s.summary      = "左右滑动的容器"
  s.description  = <<-DESC
                   滑动容器
                   DESC
  s.homepage     = "https://github.com/yangmiemie1116/PScrollContainer.git"
  s.license      = "MIT"
  s.author             = { "杨志强" => "yangzhiqiang116@gmail.com" }
  s.social_media_url   = "http://www.jianshu.com/u/bd06a732c598"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/yangmiemie1116/PScrollContainer.git", :tag => "#{s.version}" }
  s.source_files = "PScrollContainer/*.{h,m}"
  s.requires_arc = true
  s.dependency 'Masonry'
  s.dependency 'FDStackView'
end
