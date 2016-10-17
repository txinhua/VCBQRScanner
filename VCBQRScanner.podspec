Pod::Spec.new do |s|

  s.name         = "VCBQRScanner"
  s.version      = "1.0.1"
  s.summary      = "Barcode&QRcode recognize"

  s.description  = <<-DESC
  1. Create a QRCode Scanner  simply.
  2. Customize UI.
  DESC

  s.homepage     = "https://github.com/txinhua/VCBQRScanner"

  s.license      = { :type => "Apache License", :file => "LICENSE" }


  s.author             = { "gftang" => "gftang@vcainfo.com" }

  s.platform     = :ios, "7.0"

  s.requires_arc = true

  s.source       = { :git => "https://github.com/txinhua/VCBQRScanner.git", :tag => s.version }

  s.source_files  = "VCBQCodeScanner/VCBQRScanner/*.{h,m}"

  s.resources = "VCBQCodeScanner/VCBQRScanner/Resources/*"

  s.frameworks = "UIKit","AVFoundation"

end
