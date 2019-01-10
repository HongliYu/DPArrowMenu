Pod::Spec.new do |s|

  s.name         = "DPArrowMenuKit"
  s.version      = "0.0.1"
  s.summary      = "arrow menu"

  s.description  = <<-DESC
                    click the button in any position, show a list of menu
                    DESC

  s.homepage     = "https://github.com/HongliYu/DPArrowMenu"
  s.license      = "MIT"
  s.author       = { "HongliYu" => "yhlssdone@gmail.com" }
  s.source       = { :git => "https://github.com/HongliYu/DPArrowMenu.git", :tag => "#{s.version}" }

  s.platform     = :ios, "10.0"
  s.requires_arc = true
  s.source_files = "DPArrowMenu/DPArrowMenuKit/"
  s.frameworks   = 'UIKit', 'Foundation'
  s.module_name  = 'DPArrowMenuKit'
  s.swift_version = "4.2"

end
