//
//  ChooseTopupPlanViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BuybackDetailViewController.h"
#import "BuybackBurnUtil.h"

@interface BuybackDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIView *tipBack1;
@property (weak, nonatomic) IBOutlet UIView *tipBack2;
@property (weak, nonatomic) IBOutlet UIView *tipBack3;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *programLab;


@end

@implementation BuybackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//Program time: 10 days
//    
//QGas buyback price：1QGas= 2 QLC
//    
//Program implementation:
//    
//QGas is traded for QLC within the Q-Wallet OTC
//    
//* One campaign day starts from 7:00 pm till 7:00 pm the next day lasting for 24 hours.
//    
//* During each campaign, the team will gradually publish the QGas buy orders in Q-Wallet OTC  at 5 different time points, 7:00 pm, 12:00 am, 2:00 am, 5:00 am, 9:00 am (UTC+8).
//    
//* Each time there will be several QGas buy orders splitting the 4000 QGas placed, the QGas buyback amount may vary in each order.
//    
//* All the Q-Wallet users with no less than 1 QGas balance in their Q-Wallet are eligible to trade their QGas for QLC.
//    
//* The buyback program is expected to buy back a total of 20K QGas for burning later, at the buyback price of 1QGas=2 QLC which is slightly higher than the average public market price. The 40K QLC traded for QGas will be released to the QLC community.
//    
//* A dedicated QGas buyback pool which is a QGas address will be published to the public.
//    
//* Once the buyback concludes, all the QGas in the pool shall be burnt within 48 hours after the buyback completion.
    

    [self configInit];
    
//    [self requestBurn_qgas_list_v2];
}

#pragma mark - Operation
- (void)configInit {
    _contentBack.layer.cornerRadius = 10;
    _contentBack.layer.masksToBounds = YES;
    _tipBack1.layer.cornerRadius = 14;
    _tipBack1.layer.masksToBounds = YES;
    _tipBack2.layer.cornerRadius = 14;
    _tipBack2.layer.masksToBounds = YES;
    _tipBack3.layer.cornerRadius = 14;
    _tipBack3.layer.masksToBounds = YES;
    
    _priceLab.text = [NSString stringWithFormat:kLang(@"1qgas_2qlc"),_inputBuybackBurnM.unitPrice_str?:@"2"];
    _programLab.text = [NSString stringWithFormat:kLang(@"one_campaign_day___"),_inputBuybackBurnM.unitPrice_str?:@"2"];
}

#pragma mark - Request
//- (void)requestBurn_qgas_list_v2 {
//    kWeakSelf(self);
//    [BuybackBurnUtil requestBuybackBurn_list_v2:^(NSArray<BuybackBurnModel *> * _Nonnull arr) {
//
//    }];
//}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
