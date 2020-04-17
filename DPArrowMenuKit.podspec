Pod::Spec.new do |s|

  s.name         = "DPArrowMenuKit"
  s.version      = "0.0.3"
  s.summary      = "arrow menu"

  s.description  = <<-DESC
                    click the button in any position, show a list of menu
                    DESC

  s.homepage     = "https://github.com/HongliYu/DPArrowMenu"
  s.license      = "MIT"
  s.author       = { "HongliYu" => "yhlssdone@gmail.com" }
  s.source       = { :git => "https://github.com/HongliYu/DPArrowMenu.git", :tag => "#{s.version}" }
  s.source_files = "Sources/DPArrowMenu/"
  s.platform     = :ios, "11.0"
  s.requires_arc = true
  s.frameworks   = 'UIKit', 'Foundation'
  s.module_name  = 'DPArrowMenuKit'
  s.swift_version = "5.0"

end
