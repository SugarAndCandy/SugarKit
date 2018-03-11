

Pod::Spec.new do |s|


  s.name         = "SugarKit"
  s.version      = "0.0.1"
  s.summary  = 'Framework which hepls You develop your app faster'


  s.description  = <<-DESC
                   Initial description for Project
                   I will hope i change this soon
                   native swift POP
                   DESC

  s.homepage = 'https://github.com/makleso6/SugarKit.git'
 
  s.license      = "MIT"
 
  s.author             = { "MAXIM KOLESNIK" => "makleso6@gmail.com" }
  
  s.ios.deployment_target = "9.0"
 
  s.source   = { :git => 'https://github.com/makleso6/SugarKit.git', :tag => s.version, :submodules => false }
  
  s.source_files = 'SugarKit/**/*.swift'

  s.subspec 'Router' do |ss|
    ss.source_files = 'Router/**/*.swift'
    #ss.public_header_files = 'AFNetworking/AFURL{Request,Response}Serialization.h'
    #ss.watchos.frameworks = 'MobileCoreServices', 'CoreGraphics'
    #ss.ios.frameworks = 'MobileCoreServices', 'CoreGraphics'
    #ss.osx.frameworks = 'CoreServices'
  end

end
