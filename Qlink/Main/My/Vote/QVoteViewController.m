//
//  QVoteViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/26.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QVoteViewController.h"
#import "QgasVoteUtil.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "RLArithmetic.h"
#import "NSString+Trim.h"

@interface QVoteViewController ()

@property (weak, nonatomic) IBOutlet UIView *textBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseBackWidth1; // 46
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth1; // 66
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectShowWidth1; // 56
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn1;
@property (weak, nonatomic) IBOutlet UILabel *numLab1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseBackWidth2; // 46
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth2; // 66
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectShowWidth2; // 56
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn2;
@property (weak, nonatomic) IBOutlet UILabel *numLab2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseBackWidth3; // 46
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth3; // 66
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectShowWidth3; // 56
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn3;
@property (weak, nonatomic) IBOutlet UILabel *numLab3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseBackWidth4; // 46
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth4; // 66
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectShowWidth4; // 56
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn4;
@property (weak, nonatomic) IBOutlet UILabel *numLab4;

@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBackHeight; // 66


@property (nonatomic) QgasVoteState currentVoteState;
@property (nonatomic, strong) NSString *voteChoose;
//@property (nonatomic, strong) NSDictionary *voteChooseDic;
@property (nonatomic, strong) NSString *voteNum1;
@property (nonatomic, strong) NSString *voteNum2;
@property (nonatomic, strong) NSString *voteNum3;
@property (nonatomic, strong) NSString *voteNum4;

@end

@implementation QVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self getQgasVoteState];
}

#pragma mark - Operation
- (void)configInit {
    _textBack.layer.cornerRadius = 4;
    _textBack.layer.masksToBounds = YES;
    _textBack.layer.borderWidth = 1;
    _textBack.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    
    _voteNum1 = @"0";
    _voteNum2 = @"0";
    _voteNum3 = @"0";
    _voteNum4 = @"0";
    
    [self refreshViewZero];
}

- (void)refreshViewZero {
    
    _chooseBackWidth1.constant = 0; // 46
    _numWidth1.constant = 0; // 66
    _selectShowWidth1.constant = 0; // 56
    
    _chooseBackWidth2.constant = 0; // 46
    _numWidth2.constant = 0; // 66
    _selectShowWidth2.constant = 0; // 56
    
    _chooseBackWidth3.constant = 0; // 46
    _numWidth3.constant = 0; // 66
    _selectShowWidth3.constant = 0; // 56
    
    _chooseBackWidth4.constant = 0; // 46
    _numWidth4.constant = 0; // 66
    _selectShowWidth4.constant = 0; // 56
    
    _textBack.hidden = YES;
    _commitBackHeight.constant = 0; // 66
}

- (void)refreshSelectBtnState:(UIButton *)selectBtn {
    _chooseBtn1.selected = selectBtn==_chooseBtn1;
    _chooseBtn2.selected = selectBtn==_chooseBtn2;
    _chooseBtn3.selected = selectBtn==_chooseBtn3;
    _chooseBtn4.selected = selectBtn==_chooseBtn4;
}

- (void)refreshView {
    [self refreshViewZero];
    
    NSString *allVote = _voteNum1.add(_voteNum2).add(_voteNum3).add(_voteNum4);
    
    if (_currentVoteState == QgasVoteStateOngoing) { // 活动中
        if (!_voteChoose) { // 未投票
            _chooseBackWidth1.constant = 46; // 46
            _chooseBackWidth2.constant = 46; // 46
            _chooseBackWidth3.constant = 46; // 46
            _chooseBackWidth4.constant = 46; // 46
            
            _textBack.hidden = NO;
            _commitBackHeight.constant = 66; // 66
            _tipLab.text = kLang(@"if_you_got_more_to_share_with_us_leave_your_opinions_and_comments_below_");
        } else { // 已投票
            
            _numWidth1.constant = 66; // 66
            _numLab1.text = [_voteNum1.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];
            _selectShowWidth1.constant = [_voteChoose integerValue]==1?56:0; // 56

            _numWidth2.constant = 66; // 66
            _numLab2.text = [_voteNum2.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];
            _selectShowWidth2.constant = [_voteChoose integerValue]==2?56:0; // 56

            _numWidth3.constant = 66; // 66
            _numLab3.text = [_voteNum3.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];
            _selectShowWidth3.constant = [_voteChoose integerValue]==3?56:0; // 56

            _numWidth4.constant = 66; // 66
            _numLab4.text = [_voteNum4.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];
            _selectShowWidth4.constant = [_voteChoose integerValue]==4?56:0; // 56
            _tipLab.text = kLang(@"you_have_voted_successfully_thanks_for_your_engagement");
            
        }
    } else if (_currentVoteState == QgasVoteStateDone) { // 活动结束
        if (!_voteChoose) { // 未投票
            
        } else { // 已投票
            
            _selectShowWidth1.constant = [_voteChoose integerValue]==1?56:0; // 56
            _selectShowWidth2.constant = [_voteChoose integerValue]==2?56:0; // 56
            _selectShowWidth3.constant = [_voteChoose integerValue]==3?56:0; // 56
            _selectShowWidth4.constant = [_voteChoose integerValue]==4?56:0; // 56

        }
        _numWidth1.constant = 66; // 66
        _numLab1.text = [_voteNum1.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];
        
        _numWidth2.constant = 66; // 66
        _numLab2.text = [_voteNum2.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];

        _numWidth3.constant = 66; // 66
        _numLab3.text = [_voteNum3.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];

        _numWidth4.constant = 66; // 66
        _numLab4.text = [_voteNum4.div(allVote).mul(@"100").roundPlain(1) stringByAppendingString:@"%"];
        
        _tipLab.text = kLang(@"the_voting_has_been_closed");
    }
    
}

#pragma mark - Request
- (void)getQgasVoteState {
    kWeakSelf(self);
    [QgasVoteUtil requestState:^(QgasVoteState state) {
        weakself.currentVoteState = state;
        if (state == QgasVoteStateNotyet) {
            [weakself backAction:nil];
        } else {
            [weakself requestVoteResult];
        }
    }];
}

- (void)requestVoteResult {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSDictionary *params = @{@"userAccount":account};
    [RequestService requestWithUrl10:sys_vote_result_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.voteChoose = responseObject[@"choose"];
            NSString *opinion = responseObject[@"opinion"];
            NSDictionary *voteChooseDic = responseObject[Server_Result];
            weakself.voteNum1 = [NSString stringWithFormat:@"%@",voteChooseDic[@"1"]?@([voteChooseDic[@"1"] integerValue]):@"0"];
            weakself.voteNum2 = [NSString stringWithFormat:@"%@",voteChooseDic[@"2"]?@([voteChooseDic[@"2"] integerValue]):@"0"];
            weakself.voteNum3 = [NSString stringWithFormat:@"%@",voteChooseDic[@"3"]?@([voteChooseDic[@"3"] integerValue]):@"0"];
            weakself.voteNum4 = [NSString stringWithFormat:@"%@",voteChooseDic[@"4"]?@([voteChooseDic[@"4"] integerValue]):@"0"];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestVote {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSString *choose = _chooseBtn1.selected?@"1":_chooseBtn2.selected?@"2":_chooseBtn3.selected?@"3":_chooseBtn4.selected?@"4":@"";
    NSString *opinion = _textV.text.trim_whitespace?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"choose":choose,@"opinion":opinion};
    [RequestService requestWithUrl11:sys_vote_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself requestVoteResult];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseBtn1Action:(id)sender {
    [self refreshSelectBtnState:_chooseBtn1];
}

- (IBAction)chooseBtn2Action:(id)sender {
    [self refreshSelectBtnState:_chooseBtn2];
}

- (IBAction)chooseBtn3Action:(id)sender {
    [self refreshSelectBtnState:_chooseBtn3];
}

- (IBAction)chooseBtn4Action:(id)sender {
    [self refreshSelectBtnState:_chooseBtn4];
}

- (IBAction)voteAction:(id)sender {
    if (!_chooseBtn1.selected && !_chooseBtn2.selected && !_chooseBtn3.selected && !_chooseBtn4.selected) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_select_one")];
        return;
    }
    
    [self requestVote];
}



@end
