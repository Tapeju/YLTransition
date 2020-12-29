
Pod::Spec.new do |s|
    s.name         = "YLTransition"
    s.version      = "1.1.0"
    s.summary      = "自定义转场动画"
    s.description  = <<-DESC
                    几行条码即可添加自定义转场动画
                   DESC
    s.homepage     = "https://github.com/Tapeju/YLTransition.git"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Destiny' => '673795524@qq.com' }
    s.source           = { :git => 'https://github.com/Tapeju/YLTransition.git', :tag => s.version.to_s }
    s.ios.deployment_target = '11.0'
    s.source_files = 'YLTransition/*.{h,m}'


    s.subspec 'Animator' do |ss|
          ss.source_files = 'YLTransition/Animator/*.{h,m}'
    end
 
    s.subspec 'Categories' do |ss|
          ss.source_files = 'YLTransition/Categories/*.{h,m}'
    end
  
    s.subspec 'GestureRecognizer' do |ss|
          ss.source_files = 'YLTransition/GestureRecognizer/*.{h,m}'
    end
  
    s.subspec 'Interactive' do |ss|
          ss.source_files = 'YLTransition/Interactive/*.{h,m}'
          ss.dependency 'YLTransition/GestureRecognizer'
          ss.dependency 'YLTransition/Animator'
    end

    s.subspec 'ModalTransition' do |ss|
          ss.source_files = 'YLTransition/ModalTransition/*.{h,m}'
          ss.dependency 'YLTransition/GestureRecognizer'
          ss.dependency 'YLTransition/Interactive'
          ss.dependency 'YLTransition/Categories'
          ss.dependency 'YLTransition/Animator'
    end
end
