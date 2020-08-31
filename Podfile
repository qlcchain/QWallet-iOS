source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
install! 'cocoapods', :deterministic_uuids => false
inhibit_all_warnings!

use_frameworks!

#更新pod请用pod install

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
  
   pod 'Qlink', :path => '.'
   pod 'CryptoSwift', '~> 1.0'
   pod 'Starscream', '~> 3.1.1'
   pod 'secp256k1.c', '~> 0.1.2'
   
    pod 'SwiftyJSON', '~> 4.0'
    pod 'SwiftHTTP'
  
    pod 'R.swift'
    pod 'PromiseKit'
#    pod 'KeychainSwift'
#    pod 'APIKit'
    pod 'JSONRPCKit'
#    pod 'Eureka', '4.2.0'
    pod 'Moya', '~> 10.0.1'
    
    pod 'BigInt', '~> 3.0' #参考ETHFramework
    pod 'TrustCore', :git=>'https://github.com/TrustWallet/trust-core', :branch=>'master' #参考ETHFramework
    pod 'TrustKeystore', :git=>'https://github.com/TrustWallet/trust-keystore', :branch=>'master' #参考ETHFramework
    pod 'TrustWalletSDK', :git=>'https://github.com/TrustWallet/TrustSDK-iOS', :branch=>'master' #参考ETHFramework
    pod 'TrustWeb3Provider', :git=>'https://github.com/TrustWallet/trust-web3-provider', :commit=>'f4e0ebb1b8fa4812637babe85ef975d116543dfd' #参考ETHFramework

#    pod 'Eureka'
#    pod 'TrezorCrypto'
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

def pack_framework

#    pod 'AFNetworking'
#    pod 'APIKit'
#    pod 'Eureka'
#    pod 'KeychainSwift'
#    pod 'Masonry'
#    pod 'MJExtension'
#    pod 'MBProgressHUD'
#    pod 'SDWebImage'
#    pod 'Hero'
#    pod 'CocoaLumberjack/Swift'
#    pod 'RealmSwift', '3.18.0'
#    pod 'MJRefresh'
#    pod 'TMCache'
#    pod 'SwiftTheme'
#    pod 'Charts'

end

def app

#    pod 'Firebase/Core'
    pod 'ORCycleLabel'
    pod 'Firebase/Analytics'
    pod 'TTGTagCollectionView'
    pod 'BGFMDB'
    pod 'TYCyclePagerView'
    pod 'dsBridge'
    pod 'JCore', '2.1.4-noidfa' # 必选项
    pod 'JPush', '3.2.4-noidfa' # 必选项
    pod 'LYEmptyView'
    pod 'CYLTabBarController'
    pod 'Bugly'
#    pod 'NinaPagerView'
    pod 'KeychainAccess'  #编译成Framework会导致真机装不了
    pod 'IQKeyboardManager'   #编译成Framework会导致模拟器编译不过并且上传AppStore会出问题
    pod 'TOCropViewController'

  
end

def bnb
    
#    pod 'BinanceChain', :path => '.'
#    pod 'BinanceChain/Test', :path => '.'
    pod 'BinanceChain', :git => 'https://github.com/mh7821/SwiftBinanceChain.git'
    pod 'SwiftProtobuf', :inhibit_warnings => true
    pod 'Starscream', :inhibit_warnings => true
    pod 'HDWalletKit', :inhibit_warnings => true
    pod 'CryptoSwift', :inhibit_warnings => true
    
end
  
target "Qlink" do
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
    app
#    bnb
    pack_framework
   
end
