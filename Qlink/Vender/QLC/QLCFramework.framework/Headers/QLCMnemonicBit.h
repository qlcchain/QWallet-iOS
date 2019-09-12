//
//  Bit.h
//  Vite-keystore
//
//  Created by Water on 2018/9/20.
//

#import <Foundation/Foundation.h>

@interface QLCMnemonicBit : NSObject

+ (NSData *) entropyFromWords:(NSArray*)words wordLists:(NSArray *)wordList ;

@end
