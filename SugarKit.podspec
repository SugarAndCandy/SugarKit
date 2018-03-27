

Pod::Spec.new do |s|


  s.name         = "SugarKit"
  s.version      = "0.0.3"
  s.summary  = 'Framework which hepls You develop your app faster'


  s.description  = <<-DESC
                   Initial description for Project
                   I will hope i change this soon
                   native swift POP
                   DESC

  s.homepage = 'https://github.com/SugarAndCandy/SugarKit.git'
 
  s.license      = "MIT"
 
  s.author             = { "MAXIM KOLESNIK" => "makleso6@gmail.com" }
  
  s.ios.deployment_target = "9.0"
 
  s.source   = { :git => 'https://github.com/SugarAndCandy/SugarKit.git', :tag => s.version, :submodules => false }
  
  s.source_files = 'SugarKit/**/*.swift'

  s.subspec 'Router' do |ss|
    ss.source_files = 'Router/**/*.swift'
  end

  s.subspec 'Analytics' do |ss|
    ss.source_files = 'Analytics/Analytics/Analytics/**/*.swift'
  end
end
