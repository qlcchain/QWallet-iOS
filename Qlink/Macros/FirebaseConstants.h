//
//  FirebaseConstants.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/17.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseConstants : NSObject

extern NSString *const Firebase_Event_StartApp;
extern NSString *const Firebase_Event_Login;
extern NSString *const Firebase_Event_Register;
extern NSString *const Firebase_Event_Trades_Mining;
extern NSString *const Firebase_Event_Claim_QLC;
extern NSString *const Firebase_Event_Trade_NOW;

// Topup
extern NSString *const Topup_Home_getMoreQGAS_ReferFriends;
extern NSString *const Topup_Home_getMoreQGAS_StakeQLC;
extern NSString *const Topup_Home_TradeMining_MoreDetails;
extern NSString *const Topup_Home_PartnerPlan_MoreDetails;
extern NSString *const Topup_Home_QGASBuyBack_MoreDetails;
extern NSString *const Topup_Home_QGASBuyBack_JoinNow;
extern NSString *const Topup_Home_MyReferralCode_Copy;
extern NSString *const Topup_Home_MyReferralCode_ReferNOW;
extern NSString *const Topup_Home_MyOrders;
extern NSString *const Topup_Home_ChooseToken;
extern NSString *const Topup_MyOrders_GroupOrders;
extern NSString *const Topup_MyOrders_BlockchainInvoice;
extern NSString *const Topup_MyOrders_Cancel;
extern NSString *const Topup_MyOrders_PayNow;

// OTC
extern NSString *const OTC_Home_BUY;
extern NSString *const OTC_Home_SELL;
extern NSString *const OTC_Home_Record;
extern NSString *const OTC_Home_NewOrder;
extern NSString *const OTC_Home_Filter;
extern NSString *const OTC_NewOrder_BUY_Confirm;
extern NSString *const OTC_NewOrder_SELL_Confirm;
extern NSString *const OTC_SELL_Submit;
extern NSString *const OTC_BUY_Submit;
extern NSString *const OTC_Entrust_SELL_Submit_Success;
extern NSString *const OTC_Entrust_BUY_Submit_Success;
extern NSString *const OTC_SELL_Order_Success;
extern NSString *const OTC_BUY_Order_Success;

// Partner Plan
extern NSString *const PartnerPlan_OpenDelegate_Success;

// Topup Group Buy
extern NSString *const Topup_GroupBuy_StartGroup_Success;
extern NSString *const Topup_GroupBuy_JoinGroup_Success;


extern NSString *const Me_Referral_Rewards;
extern NSString *const Me_Join_the_community;
extern NSString *const Community_Twitter;
extern NSString *const Community_Telegram;
extern NSString *const Community_Facebook;
extern NSString *const Community_QLC_Chain;
extern NSString *const Topup_China;
extern NSString *const Topup_Singapore;
extern NSString *const Topup_Indonesia;
extern NSString *const Topup_Choose_a_plan;
extern NSString *const Topup_Recharge_directly;
extern NSString *const Topup_Group_Plan;
extern NSString *const Topup_order_confirm;
extern NSString *const Topup_Confirm_buy;
extern NSString *const Topup_Confirm_Cancel;
extern NSString *const Topup_Confirm_Send_QGas;
extern NSString *const Topup_Confirm_Send_QLC;
extern NSString *const Topup_GroupPlan_10_off;
extern NSString *const Topup_GroupPlan_20_off;
extern NSString *const Topup_GroupPlan_30_off;
extern NSString *const Topup_GroupPlan_Stake;
extern NSString *const Wallet_MyStakings_InvokeNewStakings;
extern NSString *const Wallet_MyStakings_InvokeNewStakings_Invoke;
extern NSString *const Topup_Home_PartnerPlan_Be_Recharge_Partner;
extern NSString *const Topup_Home_MyReferralCode_Share;
extern NSString *const Me_Settings_Languages;
extern NSString *const Me_Settings_Languages_English;
extern NSString *const Me_Settings_Languages_Chinese;
extern NSString *const Me_Settings_Languages_Indonesian;
extern NSString *const Campaign_Covid19_more_details;
extern NSString *const Campaign_Covid19_QGas_Claim;
extern NSString *const Campaign_Covid19_QLC_Claim;

// Defi
extern NSString *const Defi_Home_Top_Defi; // defi首页点击defi
extern NSString *const Defi_Home_Top_Hot; // defi首页点击hot
extern NSString *const Defi_Home_Category_; // defi首页分类
extern NSString *const Defi_Home_Record; // defi首页历史记录
extern NSString *const Defi_Detail_KeyStats; // defi详情KeyStats
extern NSString *const Defi_Detail_ActiveData; // defi详情ActiveData
extern NSString *const Defi_Detail_HistoricalStats; // defi详情HistoricalStats
extern NSString *const Defi_Detail_Rate; // defi详情Rate
extern NSString *const Defi_Detail_Explore; // defi详情Explore

@end

NS_ASSUME_NONNULL_END
