//
//  HFCaculator.h
//  HFIOS
//
//  Created by Repeatlink-HouFeng on 16/1/29.
//  Copyright © 2016年 houfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFCaculator : NSObject
@property(nonatomic,assign)BOOL isEqule;
@property(nonatomic,assign)int result;
-(HFCaculator *)caculator:(int(^)(int result))caculator;
-(HFCaculator *)equle:(BOOL(^)(int result))operation;


@end
