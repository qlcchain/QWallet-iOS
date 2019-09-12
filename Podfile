source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
inhibit_all_warnings!

use_frameworks!

#  shadowsock-----pod
def socket
#    pod 'CocoaAsyncSocket', '~> 7.4.3'
end

def library
#    pod 'KissXML', '~> 5.2.2'
    #pod 'ICSMainFramework', :path => "./Library/ICSMainFramework/"
#    pod 'MMWormhole', '~> 2.0.0'
end

def tunnel
#    pod 'MMWormhole', '~> 2.0.0'
end

def eth
    pod 'BigInt', '~> 3.0'
    pod 'R.swift'
#    pod 'JSONRPCKit', :git=> 'https://github.com/bricklife/JSONRPCKit.git'
    pod 'JSONRPCKit', '3.0.0'
    pod 'PromiseKit', '~> 6.0'
    pod 'APIKit'
#    pod 'Eureka'
    pod 'Eureka', '4.2.0'
    pod 'KeychainSwift'
    pod 'Moya', '~> 10.0.1'
    pod 'TrustCore', :git=>'https://github.com/TrustWallet/trust-core', :branch=>'master'
    pod 'TrustKeystore', :git=>'https://github.com/TrustWallet/trust-keystore', :branch=>'master'
#    pod 'TrezorCrypto'
    pod 'TrustWeb3Provider', :git=>'https://github.com/TrustWallet/trust-web3-provider', :commit=>'f4e0ebb1b8fa4812637babe85ef975d116543dfd'
    pod 'TrustWalletSDK', :git=>'https://github.com/TrustWallet/TrustSDK-iOS', :branch=>'master'
#    pod 'Result', '~> 3.0'
end

def qlc
#  pod 'APIKit'
#  pod 'JSONRPCKit'
#  pod 'PromiseKit'
#  pod 'Result'
#  pod 'CryptoSwift'
#  pod 'MJExtension'
#  pod 'MBProgressHUD'
#  pod 'BigInt'  #(已集成在QLCFramework中)
#  pod 'HandyJSON'   #(已集成在QLCFramework中)
end

target "Qlink" do

#    pod 'AFNetworking'
#    pod 'IQKeyboardManager'
#    pod 'Masonry'
#    pod 'MJExtension'
#    pod 'MBProgressHUD'
#    pod 'SDWebImage'
#    pod 'Hero'
#    pod 'CocoaLumberjack/Swift'
#    pod 'Bugly'
#    pod 'KeychainAccess'
#    pod 'RealmSwift', '3.7.6'
#    pod 'MJRefresh'
#    pod 'TMCache'
#    pod 'SwiftTheme', '0.4.1'
#    pod 'Charts', '3.1.0'

    pod 'Firebase/Core', '~> 5.4.1'
    pod 'OLImageView'
    pod 'TTGTagCollectionView'
    pod 'NinaPagerView'
    pod 'BGFMDB'
    pod 'TYCyclePagerView'
    pod 'dsBridge'

#  shadowsock
#    pod 'MMWormhole'
#    pod 'SwiftColor'
#    pod 'AsyncSwift'
#    pod 'Appirater'

    tunnel
    library
    #fabric
    socket
    eth
    qlc

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
#        if ['JSONRPCKit'].include? target.name
#            target.build_configurations.each do |config|
#                config.build_settings['SWIFT_VERSION'] = '3.0'
#            end
#        end
        if ['TrustKeystore'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end
        end
        # if target.name != 'Realm'
        #     target.build_configurations.each do |config|
        #         config.build_settings['MACH_O_TYPE'] = 'staticlib'
        #     end
        # end
    end
end
