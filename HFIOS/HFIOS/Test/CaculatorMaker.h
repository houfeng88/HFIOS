//
//  CaculatorMaker.h
//  HFIOS
//
//  Created by Repeatlink-HouFeng on 16/1/29.
//  Copyright © 2016年 houfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject
@property(nonatomic,assign)int result;
-(CaculatorMaker *(^)(int))add;
-(CaculatorMaker *(^)(int))sub;
-(CaculatorMaker *(^)(int))muilt;
-(CaculatorMaker *(^)(int))divide;

@end

@interface NSObject(Caculator)
+(int)makeCaculators:(void(^)(CaculatorMaker *make))caculatorMaker;
@end
