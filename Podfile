source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

#  shadowsock-----pod

def model
    pod 'RealmSwift'
end

def socket
    pod 'CocoaAsyncSocket', '~> 7.4.3'
end

def library
    pod 'KissXML', '~> 5.2.2'
    #pod 'ICSMainFramework', :path => "./Library/ICSMainFramework/"
    pod 'MMWormhole', '~> 2.0.0'
    pod 'KeychainAccess'
end

def tunnel
    pod 'MMWormhole', '~> 2.0.0'
end

target "Qlink" do

    pod 'AFNetworking'
    pod 'IQKeyboardManager'
    pod 'Masonry'
    pod 'MJExtension'
    pod 'MBProgressHUD'
    pod 'SDWebImage'
#    pod 'MJRefresh'
    pod 'Hero'
#    pod 'FMDB'
    pod 'BGFMDB'
    pod 'CocoaLumberjack/Swift'
    pod 'Bugly'
    pod 'OLImageView'
    pod 'Firebase/Core'
#    pod 'MMWormhole'



#  shadowsock
    pod 'SwiftColor'
    pod 'AsyncSwift'
    pod 'Appirater'

    tunnel
    library
    #fabric
    socket
    model

end


target "ShadowsockLibrary" do
    library
    model
    # YAML-Framework 0.0.3 is not available in cocoapods so we install it from local using git submodule
    # pod 'YAML-Framework', :path => "./Library/YAML-Framework"
end

target "ShadowsockModel" do
    model
end

target "ShadowsockTunnel" do
    tunnel
    socket
end

target "ShadowsockProcessor" do
    socket
end
