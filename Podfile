# Uncomment the next line to define a global platform for your project
platform :ios, '14.4'

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.4'
      end
    end
end

abstract_target 'Shared' do
  
  use_frameworks!
  inhibit_all_warnings!

  #Release pods
  pod 'JGProgressHUD', '~> 2.0.4'
 
  target 'ContactsList' do
  end

end
