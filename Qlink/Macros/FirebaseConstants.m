//
//  FirebaseConstants.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/17.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FirebaseConstants.h"

@implementation FirebaseConstants

NSString *const Firebase_Event_StartApp =  @"startApp";
NSString *const Firebase_Event_Login =  @"login";
NSString *const Firebase_Event_Register =  @"register";
NSString *const Firebase_Event_Trades_Mining = @"tradesMining";
NSString *const Firebase_Event_Claim_QLC = @"claimQLC";
NSString *const Firebase_Event_Trade_NOW = @"tradeNOW";

// Topup
NSString *const Topup_Home_getMoreQGAS_ReferFriends = @"Topup_Home_getMoreQGAS_ReferFriends";
NSString *const Topup_Home_getMoreQGAS_StakeQLC = @"Topup_Home_getMoreQGAS_StakeQLC";
NSString *const Topup_Home_TradeMining_MoreDetails = @"Topup_Home_TradeMining_MoreDetails";
NSString *const Topup_Home_PartnerPlan_MoreDetails = @"Topup_Home_PartnerPlan_MoreDetails";
NSString *const Topup_Home_QGASBuyBack_MoreDetails = @"Topup_Home_QGASBuyBack_MoreDetails";
NSString *const Topup_Home_QGASBuyBack_JoinNow = @"Topup_Home_QGASBuyBack_JoinNow";
NSString *const Topup_Home_MyReferralCode_Copy = @"Topup_Home_MyReferralCode_Copy";
NSString *const Topup_Home_MyReferralCode_ReferNOW = @"Topup_Home_MyReferralCode_ReferNOW";
NSString *const Topup_Home_MyOrders = @"Topup_Home_MyOrders";
NSString *const Topup_Home_ChooseToken = @"Topup_Home_ChooseToken";
NSString *const Topup_MyOrders_GroupOrders = @"Topup_MyOrders_GroupOrders";
NSString *const Topup_MyOrders_BlockchainInvoice = @"Topup_MyOrders_BlockchainInvoice";
NSString *const Topup_MyOrders_Cancel = @"Topup_MyOrders_Cancel";
NSString *const Topup_MyOrders_PayNow = @"Topup_MyOrders_PayNow";

// OTC
NSString *const OTC_Home_BUY = @"OTC_Home_BUY";
NSString *const OTC_Home_SELL = @"OTC_Home_SELL";
NSString *const OTC_Home_Record = @"OTC_Home_Record";
NSString *const OTC_Home_NewOrder = @"OTC_Home_NewOrder";
NSString *const OTC_Home_Filter = @"OTC_Home_Filter";
NSString *const OTC_NewOrder_BUY_Confirm = @"OTC_NewOrder_BUY_Confirm";
NSString *const OTC_NewOrder_SELL_Confirm = @"OTC_NewOrder_SELL_Confirm";
NSString *const OTC_SELL_Submit = @"OTC_SELL_Submit";
NSString *const OTC_BUY_Submit = @"OTC_BUY_Submit";
NSString *const OTC_Entrust_SELL_Submit_Success = @"OTC_Entrust_SELL_Submit_Success";
NSString *const OTC_Entrust_BUY_Submit_Success = @"OTC_Entrust_BUY_Submit_Success";
NSString *const OTC_SELL_Order_Success = @"OTC_SELL_Order_Success";
NSString *const OTC_BUY_Order_Success = @"OTC_BUY_Order_Success";

// Partner Plan
NSString *const PartnerPlan_OpenDelegate_Success = @"PartnerPlan_OpenDelegate_Success";

// Topup Group Buy
NSString *const Topup_GroupBuy_StartGroup_Success = @"Topup_GroupBuy_StartGroup_Success";
NSString *const Topup_GroupBuy_JoinGroup_Success = @"Topup_GroupBuy_JoinGroup_Success";


NSString *const Me_Referral_Rewards = @"Me_Referral_Rewards";
NSString *const Me_Join_the_community = @"Me_Join_the_community";
NSString *const Community_Twitter = @"Community_Twitter";
NSString *const Community_Telegram = @"Community_Telegram";
NSString *const Community_Facebook = @"Community_Facebook";
NSString *const Community_QLC_Chain = @"Community_QLC_Chain";
NSString *const Topup_China = @"Topup_China";
NSString *const Topup_Singapore = @"Topup_Singapore";
NSString *const Topup_Indonesia = @"Topup_Indonesia";
NSString *const Topup_Choose_a_plan = @"Topup_Choose_a_plan";
NSString *const Topup_Recharge_directly = @"Topup_Recharge_directly";
NSString *const Topup_Group_Plan = @"Topup_Group_Plan";
NSString *const Topup_order_confirm = @"Topup_order_confirm";
NSString *const Topup_Confirm_buy = @"Topup_Confirm_buy";
NSString *const Topup_Confirm_Cancel = @"Topup_Confirm_Cancel";
NSString *const Topup_Confirm_Send_QGas = @"Topup_Confirm_Send_QGas";
NSString *const Topup_Confirm_Send_QLC = @"Topup_Confirm_Send_QLC";
NSString *const Topup_GroupPlan_10_off = @"Topup_GroupPlan_10%off";
NSString *const Topup_GroupPlan_20_off = @"Topup_GroupPlan_20%off";
NSString *const Topup_GroupPlan_30_off = @"Topup_GroupPlan_30%off";
NSString *const Topup_GroupPlan_Stake = @"Topup_GroupPlan_Stake";
NSString *const Wallet_MyStakings_InvokeNewStakings = @"Wallet_MyStakings_InvokeNewStakings";
NSString *const Wallet_MyStakings_InvokeNewStakings_Invoke = @"Wallet_MyStakings_InvokeNewStakings_Invoke";
NSString *const Topup_Home_PartnerPlan_Be_Recharge_Partner = @"Topup_Home_PartnerPlan_Be_Recharge_Partner";
NSString *const Topup_Home_MyReferralCode_Share = @"Topup_Home_MyReferralCode_Share";
NSString *const Me_Settings_Languages = @"Me_Settings_Languages";
NSString *const Me_Settings_Languages_English = @"Me_Settings_Languages_English";
NSString *const Me_Settings_Languages_Chinese = @"Me_Settings_Languages_Chinese";
NSString *const Me_Settings_Languages_Indonesian = @"Me_Settings_Languages_Indonesian";
NSString *const Campaign_Covid19_more_details = @"Campaign_Covid19_more_details"; // 充值页面的疫情查看banner 的 more details
NSString *const Campaign_Covid19_QGas_Claim = @"Campaign_Covid19_QGas_Claim"; // 奖金页面，每日奖金 领取 button
NSString *const Campaign_Covid19_QLC_Claim = @"Campaign_Covid19_QLC_Claim"; //奖金页面，14天后奖金 领取button 事件名称：

// Defi
NSString *const Defi_Home_Top_Defi = @"Defi_Home_Top_Defi"; // defi首页点击defi
NSString *const Defi_Home_Top_Hot = @"Defi_Home_Top_Hot"; // defi首页点击hot
NSString *const Defi_Home_Category_ = @"Defi_Home_Category_"; // defi首页分类
NSString *const Defi_Home_Record = @"Defi_Home_Record"; // defi首页历史记录
NSString *const Defi_Detail_KeyStats = @"Defi_Detail_KeyStats"; // defi详情KeyStats
NSString *const Defi_Detail_ActiveData = @"Defi_Detail_ActiveData"; // defi详情ActiveData
NSString *const Defi_Detail_HistoricalStats = @"Defi_Detail_HistoricalStats"; // defi详情HistoricalStats
NSString *const Defi_Detail_Rate_ = @"Defi_Detail_Rate_"; // defi详情Rate
NSString *const Defi_Detail_Explore = @"Defi_Detail_Explore"; // defi详情Explore





@end
