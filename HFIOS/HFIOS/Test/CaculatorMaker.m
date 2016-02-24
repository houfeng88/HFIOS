//
//  CaculatorMaker.m
//  HFIOS
//
//  Created by Repeatlink-HouFeng on 16/1/29.
//  Copyright © 2016年 houfeng. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker
-(CaculatorMaker *(^)(int))add{
    return ^CaculatorMaker *(int value){
        _result += value;
        return self;
    };
}
-(CaculatorMaker *(^)(int))sub{
    return ^CaculatorMaker *(int value){
        _result -= value;
        return self;
    };
}
-(CaculatorMaker *(^)(int))muilt{
    return ^CaculatorMaker *(int value){
        _result *= value;
        return self;
    };
}
-(CaculatorMaker *(^)(int))divide{
    return ^CaculatorMaker *(int value){
        _result /= value;
        return self;
    };
}
@end

@implementation NSObject(Caculator)
+(int)makeCaculators:(void(^)(CaculatorMaker *make))block{
    CaculatorMaker *mgr = [[CaculatorMaker alloc] init];
    if(block){
        block(mgr);
    }
    return mgr.result;
}


@end
