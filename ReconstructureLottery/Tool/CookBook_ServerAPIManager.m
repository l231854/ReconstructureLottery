//
//  CookBook_SerVerAPIManager.m
//  lottery
//
//  Created by wayne on 2017/8/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_ServerAPIManager.h"

NSString * const CookBook_SerVerAPINameForAPIMain              = @"https://api.9595055.com/ios2";
//NSString * const CookBook_SerVerAPINameForAPIMain              = @"https://cp89.c-p-a-p-p.net/ios2";
//NSString * const CookBook_SerVerAPINameForAPIMain              = @"https://api.00CP55.COM/ios2";
//NSString * const CookBook_SerVerAPINameForAPIMain              = @"https://api.9595055.com/ios2";
//NSString * const CookBook_SerVerAPINameForAPIMain              = @"http://192.168.1.23:8080/lottery_admin/ios2";


NSString * const CookBook_SerVerAPINameForAPIHall              = @"/api/hall";
NSString * const CookBook_SerVerAPINameForAPIIndex             = @"/api/index";
NSString * const CookBook_SerVerAPINameForAPILoginSubmit       = @"/api/login/submit";

NSString * const CookBook_SerVerAPINameForAPINoticeNoTip       = @"/api/notice/noTip";


NSString * const CookBook_SerVerAPINameForAPIDraw              = @"/api/draw";
NSString * const CookBook_SerVerAPINameForAPIRegistPreInfo     = @"/api/reg/pre";
NSString * const CookBook_SerVerAPINameForAPIKefu              = @"/api/kefu";
NSString * const CookBook_SerVerAPINameForAPIRegLaw            = @"/api/reg/law";
NSString * const CookBook_SerVerAPINameForAPIRegist            = @"/api/reg/submit";
NSString * const CookBook_SerVerAPINameForAPIFreeUserCode      = @"/api/free/userCode";
NSString * const CookBook_SerVerAPINameForAPIFreeUserSubmit    = @"/api/free/submit";
NSString * const CookBook_SerVerAPINameForAPIPasswordVerify    = @"/api/password/verify";
NSString * const CookBook_SerVerAPINameForAPIPasswordReset     = @"/api/password/reset";

//type:0余额+未读消息数 1余额
NSString * const CookBook_SerVerAPINameForAPIUserAmount        = @"/api/user/amount";
NSString * const CookBook_SerVerAPINameForAPIUserSpread        = @"/api/user/spread";
NSString * const CookBook_SerVerAPINameForAPIUserSpreadList    = @"/api/user/spreadList";


NSString * const CookBook_SerVerAPINameForAPIUserCheckin       = @"/api/user/checkin";
NSString * const CookBook_SerVerAPINameForAPIUserCheckinList   = @"/api/user/checkinList";
NSString * const CookBook_SerVerAPINameForAPIUsercheckinSubmit       = @"/api/user/checkinSubmit";

NSString * const CookBook_SerVerAPINameForAPIUserMsg       = @"/api/user/msg";
NSString * const CookBook_SerVerAPINameForAPIUserMsgDetail       = @"/api/user/msgDetail";


NSString * const CookBook_SerVerAPINameForAPIUserBetList       = @"/api/user/betList";
NSString * const CookBook_SerVerAPINameForAPIUserBetDetail       = @"/api/user/betDetail";

NSString * const CookBook_SerVerAPINameForAPIUserAccountList       = @"/api/user/accountList";

NSString * const CookBook_SerVerAPINameForAPIUserRechargeList      = @"/api/user/rechargeList";
NSString * const CookBook_SerVerAPINameForAPIUserRechargeDetail      = @"/api/user/rechargeDetail";


NSString * const CookBook_SerVerAPINameForAPIUserWithdrawList      = @"/api/user/withdrawList";
NSString * const CookBook_SerVerAPINameForAPIUserWithdrawDetail     = @"/api/user/withdrawDetail";

NSString * const CookBook_SerVerAPINameForAPISetting     = @"/api/setting";


NSString * const CookBook_SerVerAPINameForAPISettingLoginPasswd     = @"/api/setting/loginPasswd";

NSString * const CookBook_SerVerAPINameForAPISettingAboutUs     = @"/api/setting/aboutUs";

NSString * const CookBook_SerVerAPINameForAPILogout     = @"/api/logout";


NSString * const CookBook_SerVerAPINameForAPISettingGetQa     = @"/api/setting/getQa";
NSString * const CookBook_SerVerAPINameForAPISettingQaSubmit     = @"/api/setting/qaSubmit";


NSString * const CookBook_SerVerAPINameForAPISettingIsWithdrawPasswdSet     = @"/api/setting/isWithdrawPasswdSet";
NSString * const CookBook_SerVerAPINameForAPISettingWithdrawPasswd     = @"/api/setting/withdrawPasswd";


NSString * const CookBook_SerVerAPINameForAPISettingGetBank    = @"/api/setting/getBank";
NSString * const CookBook_SerVerAPINameForAPISettingBindBank     = @"/api/setting/bindBank";


NSString * const CookBook_SerVerAPINameForAPITrendTypeList     = @"/api/trend/typeList";


NSString * const CookBook_SerVerAPINameForAPIUserWithdraw     = @"/api/user/withdraw";
NSString * const CookBook_SerVerAPINameForAPIUserWithdrawSubmit     = @"/api/user/withdrawSubmit";

NSString * const CookBook_SerVerAPINameForAPIUserRecharge     = @"/api/user/recharge";


NSString * const CookBook_SerVerAPINameForAPIUserRbankList     = @"/api/user/rbankList";

NSString * const CookBook_SerVerAPINameForAPIUserRonlineList     = @"/api/user/ronlineList";
NSString * const CookBook_SerVerAPINameForAPIUserRqqpayList     = @"/api/user/rqqpayList";
NSString * const CookBook_SerVerAPINameForAPIUserRotherList     = @"/api/user/rotherList";

NSString * const CookBook_SerVerAPINameForAPIUserRwechatList     = @"/api/user/rwechatList";
NSString * const CookBook_SerVerAPINameForAPIUserRalipayList     = @"/api/user/ralipayList";

NSString * const CookBook_SerVerAPINameForAPIUserRbankNext     = @"/api/user/rbankNext";
NSString * const CookBook_SerVerAPINameForAPIUserRbankSubmit     = @"/api/user/rbankSubmit";

NSString * const CookBook_SerVerAPINameForAPIUserRqqpayNext     = @"/api/user/recharge/qqpayNext";
NSString * const CookBook_SerVerAPINameForAPIUserRotherNext     = @"/api/user/recharge/otherNext";

NSString * const CookBook_SerVerAPINameForAPIUserRwechatScanNext     = @"/api/user/rwechatScanNext";
NSString * const CookBook_SerVerAPINameForAPIUserRalipayScanNext     = @"/api/user/ralipayScanNext";

NSString * const CookBook_SerVerAPINameForAPIUserWechatNext     = @"/api/user/recharge/wechatNext";
NSString * const CookBook_SerVerAPINameForAPIUserAlipayNext     = @"/api/user/recharge/alipayNext";


NSString * const CookBook_SerVerAPINameForAPIUserRalipayBankNext     = @"/api/user/ralipayBankNext";
NSString * const CookBook_SerVerAPINameForAPIUserWechatBankNext     = @"/api/user/rwechatBankNext";

NSString * const CookBook_SerVerAPINameForAPIUserRalipayBankSubmit     = @"/api/user/ralipayBankSubmit";
NSString * const CookBook_SerVerAPINameForAPIUserWechatBankSubmit     = @"/api/user/rwechatBankSubmit";


NSString * const CookBook_SerVerAPINameForAPIUserRwechatScanSubmit     = @"/api/user/rwechatScanSubmit";
NSString * const CookBook_SerVerAPINameForAPIUserRalipayScanSubmit     = @"/api/user/ralipayScanSubmit";


NSString * const CookBook_SerVerAPINameForAPIBuy               = @"/api/buy";

NSString * const CookBook_SerVerAPINameForAPIBetSubmit         = @"/api/bet/submit";

NSString * const CookBook_SerVerAPINameForAPISendMessageCode       = @"/api/send/messageCode";
NSString * const CookBook_SerVerAPINameForAPISendSubmit            = @"/api/send/submit";


//ronlineList
//rqqpayList
//rwechatList
//ralipayList


@implementation CookBook_ServerAPIManager

@end
