//
//  QConstants.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 环境   0:appstore发布  1:个人开发
//#define K_Global_Environment 1

// Bundle ID
//com.qlink.winq
//com.qlcchain.qwallet

// APP Store ID
#define AppStore_ID @"1470918335"

// 是否打印jsonstr
#define K_Print_JsonStr @(YES)

//#define AppID @"1234893685"
#define Bugly_AppID @"30b074db54"

#define JPush_AppKey @"0b552b82816c33ceda8a8d16" //
//#define JPush_AppKey @"75f163203819cc97f4ba16b8" // local test

#define Download_Link @"http://app.tby03.com/ABn6"

#pragma mark -  颜色值        *****************数码测试计sRGB 测试显示才正确
//#define MAIN_COLOR RGB(76,5,123)
//#define MAIN_PURPLE_COLOR RGB(73,0,128)
//#define MAIN_PURPLE_COLOR RGB(102,101,255)
//#define MAIN_PURPLE_COLOR UIColorFromRGB(0x4A0081)
#define MAIN_WHITE_COLOR UIColorFromRGB(0xffffff)

#define kEffectBtnColor [UIColor colorWithRed:0 green:0 blue:0 alpha:.1]
#define kClickEffectBtnImage [UIImage imageWithColor:kEffectBtnColor]
//#define kClickEffectBtnImage [UIImage imageNamed:@"test111"]
#define kEffectCellColor [UIColor colorWithRed:0 green:0 blue:0 alpha:.1]
#define kClickEffectCellImage [UIImage imageWithColor:kEffectCellColor]
#define kClickEffectCellImageView [[UIImageView alloc] initWithImage:kClickEffectCellImage]
#define kEffect_Light_Color UIColorFromRGB(0x58B0F0)
#define kEffect_Dark_Color UIColorFromRGB(0x047AD0)

#define BACK_GRAY UIColorFromRGB(0xEFEFEF)
//#define SRREFRESH_BACK_COLOR RGB(41,0,76)
#define SRREFRESH_BACK_COLOR UIColorFromRGB(0x4455EE)

#pragma mark - O3 asset
#define AESSET_TEST_HASH  @"b9d7ea3062e6aeeb3e8ad9548220c4ba1361d263"
#define AESSET_MAIN_HASH  @"0d821bd7b6d53f5c2b40e217c6defc8bbe896cf5"


#pragma mark - 通知
#define WALLET_PASS_SET_SUCESS   @"wallet_set_sucess"
#define SELECT_COUNTRY_NOTI_VPNLIST @"SELECT_COUNTRY_NOTI_VPNLIST"
#define SELECT_COUNTRY_NOTI_VPNREGISTER @"SELECT_COUNTRY_NOTI_VPNREGISTER"
#define CHECK_PROCESS_SUCCESS_VPN_ADD @"CHECK_PROCESS_SUCCESS_VPN_ADD"
#define CHECK_PROCESS_SUCCESS_VPN_LIST @"CHECK_PROCESS_SUCCESS_VPN_LIST"
// 切换服务器通知
#define CHANGE_SERVER_NOTI           @"CHANGE_SERVER_NOTI"
// 抢注vpn
#define CHECK_PROCESS_SUCCESS_VPN_SEIZE @"CHECK_PROCESS_SUCCESS_VPN_SEIZE"
//static NSString *VPN_CONNECTED_NOTI = @"VPN_CONNECTED_NOTI";
static NSString *VPN_STATUS_CHANGE_NOTI = @"VPN_STATUS_CHANGE_NOTI";
#define USER_HEAD_CHANGE_NOTI  @"user_head_change"
#define SEIZE_VPN_SUCCESS_NOTI @"SEIZE_VPN_SUCCESS_NOTI"

// p2p
#define P2P_ONLINE_NOTI @"P2P_ONLINE_NOTI" // p2p上线通知
#define P2P_OFFLINE_NOTI @"P2P_OFFLINE_NOTI" // p2p下线通知
#define FRIEND_STATUS_CHANGE_NOTI   @"FRIEND_STATUS_CHANGE_NOTI" // 好友状态改变通知
#define RECEIVE_VPN_FILE_NOTI @"RECEIVE_VPN_FILE_NOTI" // 收到vpn配置文件通知
static NSString *SAVE_VPN_PREFERENCE_FAIL_NOTI = @"SAVE_VPN_PREFERENCE_FAIL_NOTI";  // 保存vpn手机配置失败
//#define CHECK_CONNECT_RSP_NOTI @"CHECK_CONNECT_RSP_NOTI" // 获取到检查p2pconnect消息的rsp通知
#define CheckConnectRsp_Register_Noti @"CheckConnectRsp_Register_Noti"
#define CheckConnectRsp_Connect_Noti @"CheckConnectRsp_Connect_Noti"
#define P2P_JOINGROUP_NOTI @"P2P_JOINGROUP_NOTI" // 收到邀请加入群聊的通知
#define P2P_JOINGROUP_SUCCESS_NOTI @"P2P_JOINGROUP_SUCCESS_NOTI" // 加入群聊成功通知
#define GROUP_CHAT_MESSAGE_NOTI @"GROUP_CHAT_MESSAGE_NOTI" // 收到群聊消息通知
#define ADD_GROUP_CHAT_MESSAGE_COMPLETE_NOTI @"ADD_GROUP_CHAT_MESSAGE_COMPLETE_NOTI" // 添加群聊消息通知

//钱包更改 获取资产通知
#define WALLET_CHANGE_TZ   @"wallet_change_tz"
// 刷新资产通知
#define WALLET_RELOAD     @"wallet_reload"
// 添加钱包通知
#define WALLET_ADD_TZ   @"wallet_add_tz"
// 更改资产通知
#define UPDATE_ASSETS_TZ @"update_assets_tz"

// chainkey
#pragma mark - #####chainkey######

#pragma mark - NEO
#define WALLET_PASS_KEY  @"walletPassKey"
#define WALLET_PRIVATE_KEY  @"walletPrivateKey"
#define WALLET_PUBLIC_KEY  @"walletPublicKey"
#define WALLET_ADDRESS_KEY  @"walletAddressKey"
#define WALLET_WIF_KEY      @"walletWifKey"
#define NEO_WALLET_KEYCHAIN @"NEO_WALLET_KEYCHAIN"

#pragma mark - ETH
#define ETH_WALLET_KEYCHAIN @"ETH_WALLET_KEYCHAIN"

#pragma mark - EOS
#define EOS_WALLET_KEYCHAIN @"EOS_WALLET_KEYCHAIN"

#pragma mark - QLC
#define QLC_WALLET_KEYCHAIN @"QLC_WALLET_KEYCHAIN"



#define INPUNT_PASS_TIME_KEY @"pass_input_time"
#define LOGIN_PW_KEY @"LOGIN_PW_KEY"

// vpn配置key
#define VPN_FILE_KEY        @"vpn_file_key"
// data文件key
#define DATA_KEY    @"data_key"
// 用户头像
//#define USER_HEAD_KEY        @"user_head_key"
// 记录json请求时间
#define JSON_REQUEST_TIME_KEY  @"json_request_time"
// 当前选择钱包的index
#define CURRENT_WALLET_KEY @"current_wallet_key"
// p2pid
#define P2P_KEY          @"p2p_key"
// Topup_p2pid 充值
#define Topup_p2p_key          @"Topup_p2p_key"
// 我的VPN资产key
#define VPN_ASSETS_KEY    @"vpn_assets_key"
// 指纹开关
#define TOUCH_SWITCH_KEY    @"touch_key"
// 服务器网络切换key
//#define SERVER_NETWORK      @"server_network"
// 版本号
#define VERSION_KEY      @"version_key"
//---------------- 表名 ----------------------
#define HISTORYRECRD_TABNAME  @"historyRecrd_tab"
#define VPNREGISTER_TABNAME @"VPNREGISTER_TABNAME" // 注册的vpn资产表

#pragma mark - 大陆板块名称
#define ASIA_CONTINENT @"asia"
#define AFRICA_CONTINENT @"africa"
#define OCEANIA_CONTINENT @"oceania"
#define EUROPE_CONTINENT @"europe"
#define NORTHAMERICA_CONTINENT @"northamerica"
#define SOUTHAMERICA_CONTINENT @"southamerica"

// ----------------转帐成功通知对方的key -------------
#define APPVERSION   @"appVersion"
#define ASSETS_NAME  @"assetName"
#define QLC_COUNT    @"qlcCount"
#define P2P_ID       @"p2pId"
#define TRAN_TYPE    @"transactiomType"
#define EXCANGE_ID   @"exChangeId"
#define TIME_SAMP    @"timestamp"
#define TX_ID        @"txid"
#define IS_MAINNET @"isMainNet"
#define VPN_NAME @"vpnName"

// 上传头像大小
#define UploadImage_Size 50*1024  // 50kb
// 身份认证大小
#define Upload_ID_Image_Size 5*1024*1024  // 5M
// 用户默认头像
#define User_PlaceholderImage [UIImage imageNamed:@"icon_owner"]
#define Photo_White_Circle_Length 2.0f

#pragma mark - UserDefault
#define Current_Connenct_VPN @"Current_Connenct_VPN"

#define NEW_GUIDE_VPN_CONNECT     @"NEW_GUIDE_VPN_CONNECT"
#define NEW_GUIDE_CLICK_WALLET @"NEW_GUIDE_CLICK_WALLET"
#define NEW_GUIDE_UNLOCK_WALLET @"NEW_GUIDE_UNLOCK_WALLET"
#define NEW_GUIDE_CREATE_NEW_WALLET @"NEW_GUIDE_CREATE_NEW_WALLET"
#define NEW_GUIDE_WALLET_DETAIL @"NEW_GUIDE_WALLET_DETAIL"
#define NEW_GUIDE_BACKUP_KEY @"NEW_GUIDE_BACKUP_KEY"
#define NEW_GUIDE_ENTER_WALLET @"NEW_GUIDE_ENTER_WALLET"
#define NEW_GUIDE_SETTING_MORE @"NEW_GUIDE_SETTING_MORE"
#define NEW_GUIDE_VPN_REGISTER @"NEW_GUIDE_VPN_REGISTER"
#define NEW_GUIDE_VPN_SERVER_LOCATION @"NEW_GUIDE_VPN_SERVER_LOCATION"
#define NEW_GUIDE_VPN_LIST @"NEW_GUIDE_VPN_LIST"
#define NEW_GUIDE_VPN_LIST_CONNECT @"NEW_GUIDE_VPN_LIST_CONNECT"

#define In_Background_Time @"In_Background_Time" // app进入后台的时间


#pragma mark - SYSTEM
// 编译号
#define APP_Build [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// APP NAME
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// 版本号
#define APP_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark - NORMAL
#define ASSETNAME @"assetName"
#define CONNECT_VPN_TIMEOUT 30
#define LANGUAGES    @"myLanguage" // 语言key

// PacketTunnelBundleID
//static NSString *PacketTunnelBundleID = @"com.qlink.winq.PacketTunnel";
static NSString *PacketTunnelBundleID = @"com.qlcchain.qwallet.PacketTunnel";
static NSString *WINQ_VPN = @"WINQ-VPN";


#pragma mark - 旷
// 当前选择国家
#define CURRENT_SELECT_COUNTRY  @"current_select_country"
#define OTHERS    @"Others"
#define VPN_CONNECT_LIST     @"VPN_CONNECT_LIST"
#define VPN_TRANFER_TIME     60
#define VPN_FREE_COUNT        @"VPN_FREE_COUNT"
#define CHECK_PROCESS_SUCCESS_VPN_CONNECT @"CHECK_PROCESS_SUCCESS_VPN_CONNECT"
#define CHEKC_VPN_FREE_COUNT_SUCCESS       @"CHEKC_VPN_FREE_COUNT_SUCCESS"
#define VPN_CONNECT_CANCEL_LOADING            @"VPN_CONNECT_CANCEL_LOADING"
#define VPN_FREE_MAIN_COUNT        @"VPN_FREE_MAIN_COUNT"
#define SUCCESS      @"success"
#define FILE_SEND_SUCCESS_NOTI @"FILE_SEND_SUCCESS_NOTI"

#pragma mark - Jelly
#define User_PlaceholderImage1 [UIImage imageNamed:@"icon_owner1"]
#define User_DefaultImage [UIImage imageNamed:@"icon_default_user"]

#define Connect_Vpn_Timeout_Noti @"Connect_Vpn_Timeout_Noti"
#define Check_Connect_Timeout_Noti @"Check_Connect_Timeout_Noti"
#define Get_Vpn_Pass_Timeout_Noti @"Get_Vpn_Pass_Timeout_Noti"
#define Get_Vpn_Key_Timeout_Noti @"Get_Vpn_Key_Timeout_Noti"
//static NSString *GROUP_WORMHOLE = @"group.qlink.winq";
static NSString *GROUP_WORMHOLE = @"group.qlcchain.qwallet";
static NSString *DIRECTORY_WORMHOLE = @"wormhole";
static NSString *VPN_EVENT_IDENTIFIER = @"vpn_event";
static NSString *VPN_MESSAGE_IDENTIFIER = @"vpn_message";
static NSString *VPN_ERROR_REASON_IDENTIFIER = @"vpn_error_reason";
#define Receive_PrivateKey_Noti @"Receive_PrivateKey_Noti"
#define Receive_UserPass_Noti @"Receive_UserPass_Noti"
#define Receive_UserPass_PrivateKey_Noti @"Receive_UserPass_PrivateKey_Noti"
#define KEYWINDOW [UIApplication sharedApplication].keyWindow
static NSString *CONFIG_VPN_ERROR_NOTI = @"CONFIG_VPN_ERROR_NOTI";  // Failed to configure OpenVPN adapted
#define Get_Profile_Timeout_Noti @"Get_Profile_Timeout_Noti"
#define WINQ_WEBSITE @"https://winq.net"

// 当前选择钱包
//#define Current_Select_Wallet @"Current_Select_Wallet"
// 本地所有钱包
#define Local_All_Wallet @"Local_All_Wallet"
// 切换钱包通知
#define Wallet_Change_Noti @"Wallet_Change_Noti"
// 添加本地ETH钱包通知
#define Add_ETH_Wallet_Noti @"Add_ETH_Wallet_Noti"
// 删除钱包成功通知
#define Delete_Wallet_Success_Noti @"Delete_Wallet_Success_Noti"
// 添加本地NEO钱包通知
#define Add_NEO_Wallet_Noti @"Add_NEO_Wallet_Noti"
// neo转账成功通知
//#define NEO_Transfer_Success_Noti @"NEO_Transfer_Success_Noti"
// 添加本地EOS钱包通知
#define Add_EOS_Wallet_Noti @"Add_EOS_Wallet_Noti"
// 添加本地QLC钱包通知
#define Add_QLC_Wallet_Noti @"Add_QLC_Wallet_Noti"

// 切换货币通知
#define Currency_Change_Noti @"Currency_Change_Noti"
// 切换钱包更换token通知
//#define Token_Change_Noti @"Token_Change_Noti"
// 获取注册vpn列表成功通知
#define SendVpnFileListRsp_Success_Noti @"SendVpnFileListRsp_Success_Noti"
// 通过vpnname拿到vpndata成功通知
#define SendVpnFileNewRspOfRegister_Success_Noti @"SendVpnFileNewRspOfRegister_Success_Noti"
#define SendVpnFileNewRspOfConnect_Success_Noti @"SendVpnFileNewRspOfConnect_Success_Noti"
// eos转账成功通知
#define EOS_Transfer_Success_Noti @"EOS_Transfer_Success_Noti"
// eos转账失败通知
#define EOS_Transfer_Fail_Noti @"EOS_Transfer_Fail_Noti"
// eos buy ram 成功通知
#define EOS_BuyRam_Success_Noti @"EOS_BuyRam_Success_Noti"
// eos buy ram 失败通知
#define EOS_BuyRam_Fail_Noti @"EOS_BuyRam_Fail_Noti"
// eos sell ram 成功通知
#define EOS_SellRam_Success_Noti @"EOS_SellRam_Success_Noti"
// eos sell ram 失败通知
#define EOS_SellRam_Fail_Noti @"EOS_SellRam_Fail_Noti"
// eos 抵押 cpu/net 成功通知
#define EOS_Approve_Success_Noti @"EOS_Approve_Success_Noti"
// eos 抵押 cpu/net 失败通知
#define EOS_Approve_Fail_Noti @"EOS_Approve_Fail_Noti"
// eos 赎回 cpu/net 成功通知
#define EOS_Unstake_Success_Noti @"EOS_Unstake_Success_Noti"
// eos 赎回 cpu/net 失败通知
#define EOS_Unstake_Fail_Noti @"EOS_Unstake_Fail_Noti"
// eos 创建账号 失败通知
#define EOS_CreateAccount_Success_Noti @"EOS_CreateAccount_Success_Noti"
// eos 创建账号 失败通知
#define EOS_CreateAccount_Fail_Noti @"EOS_CreateAccount_Fail_Noti"

// 当前货币
#define Local_Currency @"Local_Currency"
// 是否打开指纹验证
#define Local_Show_Touch @"Local_Show_Touch"
// 默认NEO钱包
#define Default_NEOWallet_Address @"Default_NEOWallet_Address"
// 本地存储的markets symbol
#define Local_Markets_Symbol @"Local_Markets_Symbol"
// EOS创建账号时保存生成的信息
#define EOS_CreateSource_InKeychain @"EOS_CreateSource_InKeychain"
// NEO decimals
#define NEO_Decimals @"8"
// ETH decimals
#define ETH_Decimals @"1e-9"


// 退出登录通知
#define User_Logout_Success_Noti @"User_Logout_Success_Noti"
// 登录成功通知
#define User_Login_Success_Noti @"User_Login_Success_Noti"
// 更新用户信息通知
#define User_UpdateInfo_Noti @"User_UpdateInfo_Noti"
#define User_UpdateInfoAfterLogin_Noti @"User_UpdateInfoAfterLogin_Noti"
// qlc account pending结束通知
//#define QLC_AccountPending_Done_Noti @"QLC_AccountPending_Done_Noti"
// 切换ETH钱包token请求完成通知
//#define Update_ETH_Wallet_Token_Noti @"Update_ETH_Wallet_Token_Noti"
// 切换NEO钱包token请求完成通知
//#define Update_NEO_Wallet_Token_Noti @"Update_NEO_Wallet_Token_Noti"
// 切换QLC钱包token请求完成通知
//#define Update_QLC_Wallet_Token_Noti @"Update_QLC_Wallet_Token_Noti"
// 更新ETH 备份助记词 更新通知
static NSString*ETH_Wallet_Backup_Update_Noti = @"ETH_Wallet_Backup_Update_Noti";
// 更新EOS 备份助记词 更新通知
static NSString*EOS_Wallet_Backup_Update_Noti = @"EOS_Wallet_Backup_Update_Noti";
// 更新NEO 备份助记词 更新通知
static NSString*NEO_Wallet_Backup_Update_Noti = @"NEO_Wallet_Backup_Update_Noti";
// 更新QLC 备份助记词 更新通知
static NSString*QLC_Wallet_Backup_Update_Noti = @"QLC_Wallet_Backup_Update_Noti";

static NSString *NEO_Transfer_Remark = @"My QWallet";
//static double NEO_fee = 0.00000001;
static double NEO_fee = 0.0;
// 是否开启指纹锁
static NSString *title_screen_lock = @"title_screen_lock";

// 交易订单状态
static NSString *ORDER_STATUS_TRADE_TOKEN_PENDING = @"TRADE_TOKEN_PENDING";
static NSString *ORDER_STATUS_QGAS_TO_PLATFORM = @"QGAS_TO_PLATFORM";
static NSString *ORDER_STATUS_OVERTIME = @"OVERTIME";
static NSString *ORDER_STATUS_NORMAL = @"NORMAL";
static NSString *ORDER_STATUS_PENDING = @"PENDING";
static NSString *ORDER_STATUS_USDT_PAID = @"USDT_PAID";
static NSString *ORDER_STATUS_USDT_PENDING = @"USDT_PENDING";
static NSString *ORDER_STATUS_NEW = @"NEW";
static NSString *ORDER_STATUS_QGAS_PAID = @"QGAS_PAID";
static NSString *ORDER_STATUS_CANCEL = @"CANCEL";
static NSString *ORDER_STATUS_END = @"END";
static NSString *ORDER_STATUS_TXID_ERROR = @"TXID_ERROR";

static NSString *APPEAL_STATUS_NO = @"NO"; // 无申诉
static NSString *APPEAL_STATUS_YES = @"YES"; // 申诉中
static NSString *APPEAL_STATUS_SUCCESS = @"SUCCESS"; // 申诉成功
static NSString *APPEAL_STATUS_FAIL = @"FAIL"; // 申诉失败

#pragma mark - Transaction
static NSString *QLC_Transaction_Url = @"https://explorer.qlcchain.org/transaction/";
static NSString *ETH_Transaction_Url = @"https://etherscan.io/tx/";
static NSString *NEO_Transaction_Url = @"https://neoscan.io/transaction/";
static NSString *EOS_Transaction_Url = @"https://eosflare.io/tx/";

static NSString *Explorer_QLCChain_Org_Url = @"https://explorer.qlcchain.org";
static NSString *QLCChainOfTitle = @"QLCChain";

static NSString *TermsOfServiceAndPrivatePolicy_Url = @"https://docs.google.com/document/d/1yTr1EDXmOclDuSt4o0RRUc0fVjJU3zPREK97C1RmYdI/edit?usp=sharing";
static NSString *TermsOfTitle = @"Privacy Policy";

static NSString *QLCChain_Environment = @"QLCChain_Environment";
static NSString *QLCServer_Environment = @"QLCServer_Environment";

static NSInteger const QLC_UnitNum = 100000000;

@interface QConstants : NSObject

// 钱包TokenChain
extern NSString *const QLC_Chain;
extern NSString *const NEO_Chain;
extern NSString *const EOS_Chain;
extern NSString *const ETH_Chain;

extern NSString *const Local_Select_Pairs;

#pragma mark - 充值-微信支付
extern NSString *const Weixin_Pay_Url_Scheme;
extern NSString *const Weixin_Pay_Back_Noti;

// OTC 显示挂单挖矿奖励
extern NSString *const OTC_Show_SheetMining_ID;

extern NSString *const Txid_Backup_Type_TOPUP;
extern NSString *const Txid_Backup_Type_ENTRUST_ORDER;
extern NSString *const Txid_Backup_Type_TRADE_ORDER;

extern NSString *const Platform_iOS;

extern NSString *const QLC_Data_Topup;
extern NSString *const QLC_Data_Otc;
  
extern NSString *const Join_Telegram_Key;

extern NSString *const GlobalOutbreak_domestic;
extern NSString *const GlobalOutbreak_overseas;
extern NSString *const GlobalOutbreak_title;
extern NSString *const OutbreakRedFocus_Showed;

extern NSString *const IS_Review_Version; // 是否是审核版本
extern NSString *const IsReview_Update_Noti;

extern NSString *const Defi_Record_Local;

@end

NS_ASSUME_NONNULL_END
