//
//  ServerConstants.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//http://192.168.0.190:8080/dapp

@interface ServerConstants : NSObject

extern NSString *const Server_Data;
extern NSString *const Server_Msg;
extern NSString *const Server_Code;
extern NSString *const Server_Result;
extern NSInteger const Server_Code_Success;
extern NSInteger const Server_TimeOut_Code;
extern NSInteger const Server_ConnectLost_Code;
extern NSInteger const Server_CouldNotConnectServer_Code;

extern NSString *const ssIdsave_Url; // 1、    保存ssid
extern NSString *const recordsave_Url; // 2、保存record 接口
extern NSString *const ssIdquery_Url; // 3、查询单个ssid 接口
extern NSString *const recordquery_Url; // 4、查询单个record接口
extern NSString *const ssIdquerys_Url; // 5、查询多个ssid 接口
extern NSString *const recordquerys_Url; // 6、查询多个record接口
extern NSString *const createWallet_Url; // 7、创建钱包
extern NSString *const createWalletV2_Url;
//extern NSString *const getTokenBalance_Url; // 8、获取资产balance
extern NSString *const transfer_Url; // 9、交易接口
extern NSString *const wifds_Url; // 10、wifi打赏接口
extern NSString *const exportKey_Url; // 11、导入钱包接口
extern NSString *const getTokenInfo_Url; // 12、获取tokenInfo信息接口
extern NSString *const getTranRecord_Url; // 13、获取交易记录接口
extern NSString *const recordsaveOver_Url; // 14、断开wifi时，保存record接口
extern NSString *const raw_Url; // 15、获取汇率接口
extern NSString *const neoExchangeQlc_Url; // 16、neo兑换qlc接口
extern NSString *const neoExchangeQlcV2_Url; // 16、neo兑换qlc接口2
extern NSString *const ssIdrecoveryAssets_Url; // 17、根据地址恢复资产接口
extern NSString *const recordrecoveryRecords_Url; // 18、根据地址恢复记录接口
extern NSString *const vpnsave_Url; // 19、注册vpn资产接口
extern NSString *const vpnquery_Url; // 20、根据国家获取vpn资产列表接口
extern NSString *const vpnsaveCVpnRecord_Url; // 21、保存VPN记录接口
extern NSString *const validateAssetIsexist_Url; // 22、验证资产是否存在接口
extern NSString *const ssIdregisterWifiByFee_Url; // 23、注册wifi资产（包含扣费功能）接口
extern NSString *const ssIdregisterVpnByFee_Url; // 24、注册vpn资产（包含扣费功能）接口
extern NSString *const ssIdregisterWifiByFeeV2_Url; // 25、注册wifi资产接口（第二版本）
extern NSString *const ssIdregisterVpnByFeeV2_Url; // 26、注册vpn资产接口(第二版本)
extern NSString *const batchExportKey_Url; // 27、批量导入钱包
extern NSString *const uploadHeadView_Url; // 28、上传用户头像
extern NSString *const getHeadView_Url; // 29、获取用户头像
extern NSString *const heartbeat_Url; // 30 资产心跳接口
extern NSString *const ssIdregisterWifiByFeeV3_Url; // 31、注册wifi资产接口（第三版本）
extern NSString *const ssIdregisterVpnByFeeV3_Url; // 32、注册vpn资产接口(第三版本)
extern NSString *const ssIdregisterVpnByFeeV4_Url; // 44、注册vpn资产接口(第四版本)

extern NSString *const ssIdupdateWifiInfoV3_Url; // 33、更新wifi基本信息接口
extern NSString *const ssIdupdateVpnInfoV3_Url; // 34、更新vpn基本信息接口
extern NSString *const queryVpnV2_Url; // 35、根据国家获取vpn资产列表接口（第二版）
extern NSString *const heartbeatV2_Url; // 36 资产心跳接口（第二版）
extern NSString *const unpspentAsset_Url; // 37获取未花费的交易输出
extern NSString *const allUnpspentAsset_Url; // 38 获取所有未花费的交易输出
extern NSString *const sendrawtransaction_Url; // 39 交易广播
extern NSString *const heartbeatV3_Url; // 40 资产心跳接口（第三版）
//extern NSString *const mainAddress_Url ; //47 获取主帐号地址 (第一版)
extern NSString *const mainAddressV2_Url ; //49 获取主帐号地址 (第f二版)
extern NSString *const transTypeOperate_Url ; // vpn wifi打赏
extern NSString *const getServerTime_Url; // 51、获取服务器时间接口
extern NSString *const queryVpnV3_Url; // 55、根据国家获取vpn资产列表接口（第三版）
extern NSString *const zsFreeNum_Url ; //56、赠送免费次数接口
extern NSString *const freeConnection_Url ; //57、免费连接vpn接口
extern NSString *const queryFreeRecords_Url ;  //58、查找免费使用记录接口
extern NSString *const reportVpnInfo_Url;  // 46、上报vpn信息接口
extern NSString *const queryActs_Url ;  // 59、获取活动列表接口
extern NSString *const queryVpnRankings_Url ; // 60、获取活动vpn列表
extern NSString *const isShowRanking_Url ; // 61、活动ranking控制开关接
extern NSString *const ssIdRegisterVpnByFeeV5_Url; // 62、注册vpn资产接口(第五版本)
extern NSString *const ssIdUpdateVpnInfoV4_Url; // 63、更新vpn基本信息接口(第四版本)
extern NSString *const ssIdRegisterVpnByFeeV6_Url; // 64、注册vpn资产接口(第六版本)
extern NSString *const ethAddressInfo_Url; // 65、获取ETH地址的信息(包含token余额)
extern NSString *const neoAddressInfo_Url; // 66、获取NEO地址的信息(包含token余额)
extern NSString *const binaKlines_Url; // 67获取token K线图数据
extern NSString *const binaTpcs_Url; // 68获取token 24小时涨跌信息
extern NSString *const ethAddressHistory_Url; // 69获取地址的交易历史
extern NSString *const neoGetAllTransferByAddress_Url; // 70 NEO根据地址获取所有的交易记录
extern NSString *const tokenPrice_Url; // 71 获取数字货币的价格
extern NSString *const walletReport_wallet_create_Url; // 72 上报创建钱包地址接口
extern NSString *const walletReport_wallet_transfer_Url; // 73 上报钱包转账接口
extern NSString *const neoMainNetNep5Transfer_Url; // 74 NEO所有代币正式转账接口
extern NSString *const neoMainNetAllUnpspentAsset_Url; // 75 获取正式链未花费的接口
extern NSString *const ethAddress_transactions_Url; // 76 获取地址的交易历史(ETH)
extern NSString *const neoGotWGas_Url; // 77 领取winGas接口
extern NSString *const neoQueryWGas_Url; // 78 查询winGas接口
extern NSString *const neoGetClaims_Url; // 79 查询claimGas接口
extern NSString *const eosNew_account_Url; // 80 创建EOS账户
extern NSString *const eosGet_token_list_Url; // 81 查询账户的某个代币或所有代币余额
extern NSString *const eosGet_account_related_trx_info_Url; // 82 查询账户的代币转账记录
extern NSString *const eosGet_account_resource_info_Url; // 83 查询账户的RAM/CPU/NET等资源信息
extern NSString *const eosGet_account_info_Url; // 84 查询账户的基本信息
extern NSString *const binaGetTokens_Url; // 85 查询支持24小时涨跌的所有tokens
extern NSString *const eosEos_verify_Url; // 86 EOS数据签名公匙验证
extern NSString *const walletReport_wallet_create_v2_Url; // 87 上报创建钱包地址接口（第二版本）
extern NSString *const ethEth_address_Url; // 88 系统ETH地址
extern NSString *const ethEth_for_activate_eos_wallet; // 89 激活EOS钱包所需ETH数量
extern NSString *const eosEos_resource_price_Url; // 90 获取资源[RAM,CPU,NET]价格
extern NSString *const btcRawaddr_Url; // 91 BTC查询地址交易记录
extern NSString *const wgas_history_Url; // 92 资产[VPN]获取WGAS记录
extern NSString *const convert_wgas_Url; // 93 兑换WGAS
extern NSString *const signup_code_Url; // 94 获取注册验证码
extern NSString *const sign_up_Url; // 95 注册
extern NSString *const sign_in_Url; // 96 登录
extern NSString *const invite_Url; // 97 邀请好友
extern NSString *const invite_rankings_Url; // 98 邀请排名
extern NSString *const rich_list_Url; // 99 富豪榜
extern NSString *const product_list_Url; // 100 产品列表
extern NSString *const product_info_Url; // 101 产品详情
extern NSString *const order_Url; // 102 购买产品
extern NSString *const order_list_Url; // 103 订单列表
extern NSString *const redeem_Url; // 104 订单赎回
extern NSString *const vcode_signin_code_Url; // 105 获取登录验证码
extern NSString *const user_signin_code_Url; // 106 验证码登录
extern NSString *const vcode_change_password_code_Url; // 107 获取修改密码验证码
extern NSString *const vcode_change_phone_code_Url; // 108 获取更换手机验证码
extern NSString *const vcode_change_email_code_Url; // 109 获取更换邮箱验证码
extern NSString *const user_change_password_Url; // 110 修改密码
extern NSString *const user_change_phone_Url; // 111 更换手机号码
extern NSString *const user_change_email_Url; // 112 更换邮箱
extern NSString *const user_change_nickname_Url; // 113 修改昵称
extern NSString *const user_upload_headview_Url; // 114、上传用户头像（不需要sign验证）
extern NSString *const history_record_Url; // 115 财富-历史记录
extern NSString *const upload_id_card_Url; // 116、上传用户身份证/护照
extern NSString *const entrust_order_Url; // 117 添加委托订单
extern NSString *const entrust_order_list_Url; // 118 委托订单列表
extern NSString *const entrust_order_info_Url; // 119 委托订单详情
extern NSString *const entrust_cancel_order_Url; // 120 取消委托订单
extern NSString *const trade_buy_order_Url; // 121 生成买单
extern NSString *const trade_buyer_confirm_Url; // 122 买家确认已转出USDT
extern NSString *const trade_sell_order_Url; // 123 生成卖单
extern NSString *const trade_sell_order_v2_Url; //
extern NSString *const trade_seller_confirm_Url; // 124 卖家确认已收到USDT
extern NSString *const trade_order_list_Url; // 125 买卖订单列表
extern NSString *const trade_order_info_Url; // 126 委托订单详情
//extern NSString *const trade_appeal_Url; // 127 申诉
extern NSString *const trade_appeal_Url; // 127 申诉
extern NSString *const user_user_info_Url; // 128 用户详情
extern NSString *const trade_cancel_Url; // 129 买卖订单取消
extern NSString *const sys_version_info_Url; // 130  APP版本信息
extern NSString *const pairs_pairs_Url; // 交易对
extern NSString *const sys_contract_unlock_Url; // 调用智能合约'unlock'方法
extern NSString *const topup_product_list_Url; // 132 充值产品列表
extern NSString *const topup_order_Url; // 133 充值订单
extern NSString *const topup_order_list_Url; // 134 充值订单列表
extern NSString *const topup_cancel_order_Url; // 135 取消订单
extern NSString *const log_save_Url; // 136 保存错误日志
extern NSString *const user_bind_Url; // 137 用户绑定QLC-CHAIN钱包地址
extern NSString *const reward_reward_list_Url; // 138 QGAS奖励列表
extern NSString *const reward_claim_bind_Url; // 139 领取绑定钱包获取的QGAS奖励
extern NSString *const reward_reward_total_Url; // 140 QGAS奖励总数
extern NSString *const sys_dict_Url; // 141 字典查询
extern NSString *const user_invite_amount_Url; // 142 邀请人数
extern NSString *const reward_claim_invite_Url; // 143 领取邀请用户获取的QGAS奖励
extern NSString *const user_bind_jpush_Url; // 144 用户绑定极光推送ID
extern NSString *const user_logout_Url; // 145 退出登录
extern NSString *const topup_pay_token_Url;
extern NSString *const topup_order_confirm_Url;
extern NSString *const trade_mining_list_Url; // 148 交易挖矿活动列表
extern NSString *const trade_mining_reward_list_Url; // 149 交易挖矿奖励列表
extern NSString *const trade_mining_claim_Url; // 150 领取交易挖矿奖励
extern NSString *const trade_mining_reward_total_Url; // 151 交易挖矿奖励总数
extern NSString *const trade_mining_reward_rankings_Url; // 152 交易挖矿奖励排行榜
extern NSString *const trade_mining_index_Url; //
extern NSString *const user_red_point_Url; // 红点
extern NSString *const sys_txid_backup_Url; //
extern NSString *const trade_sell_order_txid_Url; // 156 卖单保存买卖币TXID
extern NSString *const topup_country_list_Url; // 158 国家列表
extern NSString *const topup_product_list_v2_Url; // 159 充值产品列表V2
extern NSString *const topup_isp_list_Url; // 160 运营商列表
extern NSString *const topup_province_list_Url; // 161 省/区域列表
extern NSString *const topup_order_v2_Url; // 162 充值订单V2
extern NSString *const topup_deduction_token_txid_Url; // 163 保存充值订单的抵扣币转入TXID
extern NSString *const topup_pay_token_txid_Url; // 164 保存充值订单的支付币转入TXID
extern NSString *const user_bind_qlc_address_Url; // 165 用户绑定QLC-CHAIN钱包地址
extern NSString *const user_topup_reward_rankings_Url; // 166 充值奖励列表
extern NSString *const topup_group_kind_list_Url; // 167 团购类型列表
extern NSString *const topup_create_group_Url; // 168 创建团购
extern NSString *const topup_group_list_Url; // 169 团购列表
extern NSString *const topup_join_group_Url; // 170 参加团购
extern NSString *const topup_group_item_list_Url; // 171 团购条目列表
extern NSString *const topup_item_deduction_token_txid_Url; // 172 团购条目抵扣币TXID
extern NSString *const topup_item_deduction_token_confirm_Url; // 173 团购条目抵扣币确认
extern NSString *const topup_item_pay_token_txid_Url; // 174 团购条目支付币TXID
extern NSString *const user_invite_list_Url; // 175 受邀者列表
extern NSString *const topup_dedicate_list_Url; // 176 充值奖励贡献者列表
extern NSString *const topup_product_list_v3_Url; // 177 充值产品列表V3
extern NSString *const sys_vote_Url; // 180 QGAS销毁投票
extern NSString *const sys_vote_result_Url; // 181 QGAS销毁投票结果
extern NSString *const burn_qgas_list_Url; //
extern NSString *const burn_qgas_list_v2_Url;
extern NSString *const vcode_verify_code_Url; // 182 获取验证码
extern NSString *const reward_claim_invite_v2_Url; // 183 领取邀请用户获取的QGAS奖励V2
extern NSString *const reward_claim_bind_v2_Url; // 184 领取绑定钱包获取的QGAS奖励V2
extern NSString *const sys_index_Url; //
extern NSString *const sys_location_Url; //
extern NSString *const defi_project_list_Url; // 190 DeFi项目列表
extern NSString *const defi_stats_list_Url; // 191 DeFi项目统计数据列表
extern NSString *const defi_rating_Url; // 192 DeFi项目评级
extern NSString *const defi_category_list_Url; // 193 DeFi项目类型列表
extern NSString *const defi_project_Url; // 194 DeFi项目详情
extern NSString *const defi_news_list_Url; // 195 DeFi新闻列表
extern NSString *const defi_news_Url; // 196 DeFi 新闻详情
extern NSString *const defi_rating_info_Url; // 197 DeFi 项目评级详情
extern NSString *const defi_stats_cache_Url; // 198 DeFi 项目统计缓存


extern NSString *const allUnpspentAsset_url; // 正式接口（neo及其token转账）
extern NSString *const allUnpspentAsset_v2_url;

@end

NS_ASSUME_NONNULL_END
