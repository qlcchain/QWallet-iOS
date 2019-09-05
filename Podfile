source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
inhibit_all_warnings!

use_frameworks!

#  shadowsock-----pod

def model
#    3.11.1
    pod 'RealmSwift', '3.7.6'
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
    pod 'Firebase/Core', '~> 5.4.1'
#    pod 'MMWormhole'
#    pod 'TagListView'
    pod 'TTGTagCollectionView'
    pod 'Charts', '3.1.0'
    pod 'SwiftTheme', '0.4.1'
    pod 'TYCyclePagerView'
    pod 'MJRefresh'
    pod 'TMCache'

#  shadowsock
    pod 'SwiftColor'
    pod 'AsyncSwift'
    pod 'Appirater'
    pod 'HandyJSON'
    pod 'NinaPagerView'
    pod 'dsBridge'

    # qlc_sign
#    pod 'TrezorCryptoEd25519WithBlake2b'

    tunnel
    library
    #fabric
    socket
    model
    eth

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
