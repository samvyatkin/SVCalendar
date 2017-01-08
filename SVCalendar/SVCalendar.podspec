Pod::Spec.new do |s|
    s.name = 'SVCalendar'
    s.version = 'v1.0.1'
    s.summary = 'SVCalendar lets a user see default calendar'
    s.description = 'SVCalendar allows to show calendar on current date or date which was selected by user by switching between months'    
    s.homepage = 'https://github.com/S7Vyto/SVCalendar'
    s.license = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author = { 'Sam Vyatkin' => 'samvyto@gmail.com' }
    s.source = { :git => 'https://github.com/S7Vyto/SVCalendar.git', :tag => '#{s.version}' }    
    s.requires_arc = true
    s.ios.deployment_target = '9.3'
    s.source_files = 'SVCalendar/*'
end