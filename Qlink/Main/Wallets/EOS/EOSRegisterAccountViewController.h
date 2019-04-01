//
//  EOSRegisterAccountViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EOSCreateSourceModel : BBaseModel

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *ownerPrivateKey;
@property (nonatomic, copy) NSString *ownerPublicKey;
@property (nonatomic, copy) NSString *activePrivateKey;
@property (nonatomic, copy) NSString *activePublicKey;

@end

@interface EOSRegisterAccountViewController : QBaseViewController

@end

NS_ASSUME_NONNULL_END
