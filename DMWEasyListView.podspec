Pod::Spec.new do |s|
  s.name             = 'DMWEasyListView'
  s.version          = '1.0.0'
  s.summary          = 'The list view display is data-driven, simplifying the use of list objects'

  s.homepage         = 'https://github.com/yiyucanglang'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/DMWEasyListView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = '*.{h,m}'
 end
