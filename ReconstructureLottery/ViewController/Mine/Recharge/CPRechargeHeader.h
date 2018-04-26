//
//  CPRechargeHeader.h
//  lottery
//
//  Created by wayne on 2017/9/8.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#ifndef CPRechargeHeader_h
#define CPRechargeHeader_h

typedef enum : NSUInteger {
    
    CPRechargeTypeNone      =0,
    CPRechargeByBank        =1,
    CPRechargeByWechat      =2,
    CPRechargeByAlipay      =3,
    CPRechargeByQQPay       =4,
    CPRechargeByOnline      =5,
    CPRechargeByOther       =6
    
} CPRechargeType;


#endif /* CPRechargeHeader_h */
