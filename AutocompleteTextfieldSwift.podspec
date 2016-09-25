Pod::Spec.new do |s|
  s.name          = "AutocompleteTextfieldSwift"
  s.version       = "2.0"
  s.summary       = "Simple and straightforward sublass of UITextfield to manage string suggestions"
  s.homepage      = "https://github.com/mnbayan/AutocompleteTextfieldSwift"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "mnbayan" => "mylenebayan@gmail.com" }
  s.platform      = :ios, '8.0'
  s.source        = { :git => "https://github.com/mnbayan/AutocompleteTextfieldSwift.git", :tag => "v#{s.version}" }
  s.source_files  = 'Classes', 'AutocompleteTextfieldSwift/AutoCompleteTextField/AutoCompleteTextField.swift'
  s.requires_arc  = true
  s.framework     = "UIKit"
end
