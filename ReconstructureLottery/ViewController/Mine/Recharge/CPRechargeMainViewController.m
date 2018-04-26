//
//  CPRechargeMainViewController.m
//  lottery
//
//  Created by wayne on 2017/9/8.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeMainViewController.h"
#import "CPRechargeHeader.h"
#import "CPRechargeBankCell.h"
#import "CPRechargeNormalCell.h"
#import "CPRechargeNetBankCell.h"
#import "CPRechargeAddFriendCell.h"
#import "CPRechargeBankNextStepVC.h"
#import "CPRechargeThirdQRCodeVC.h"
#import "CPRechargeSelfQRCodeVC.h"
#import "CPRechargeAlipayToBankVC.h"
#import "CPRechargePayTypeButton.h"
#import "CPAddFriendRechargeVC.h"
#import "CPRechargeRightMenuView.h"


@interface CPRechargeMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_tableHeaderView;
    IBOutlet UILabel *_memberNameLabel;
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UITextField *_rechargeAmountTf;
    IBOutlet UILabel *_rechargeTipLabel;
    IBOutlet UILabel *_payTypeMarkLabel;

    IBOutlet UIView *_bankTopView;
    IBOutlet UILabel *_bankRechargeBankName;
    IBOutlet UILabel *_bankRechargeMemberName;
    
    IBOutlet UILabel *_bankRechargeInfo;
    
    
    IBOutlet UIView *_netBankTopView;
    
    IBOutlet UIView *_tableFooterView;
    
    
    IBOutlet UIScrollView *_payTypeScrollView;
    
    CPRechargePayTypeButton *_markSelectedButton;
    
    NSInteger _selectedPayIndex;
    
    /*
     {
     "bankName": "招商银行",
     "bankAddr": "厦门",
     "accountCode": "12143242",
     "accountName": "测试",
     "payMin": 1,--最小充值金额
     "payMax": 1000,--最大充值金额
     "id": 6
     }

     */
    NSDictionary *_bankPayInfo;
    
    
    /*
     {
        addAmount = 0;
        expand =         
        {
            bankList =             
            {
                (显示值)"\U5de5\U5546\U94f6\U884c" = "ICBC|\U5de5\U5546\U94f6\U884c"（提交值）;
            };
        };
        id = 18;
        maxAmount = 100000;
        minAmount = 10;
        name = "\U667a\U4ed8\U7f51\U94f62001240101";
        payType = 4;
        payUrl = "http://pay.hmtnb.top";
        returnType = 2;
        type = 1;
     },

     */
    NSDictionary *_netBankPayInfo;
    
    NSArray *_bankList;
    NSArray *_wechatList;
    NSArray *_alipayList;
    NSArray *_qqPayList;
    NSArray *_netBankList;
    NSArray *_otherPayList;

    /*
     (
         {
             code = bank;
             name = "\U94f6\U884c\U8f6c\U8d26";
         },
         {
             code = wechat;
             name = "\U5fae\U4fe1";
         }
     }
     */
    NSArray *_payTypeList;
    
    
    IBOutlet UIView *_noPayTypeAlertView;
    IBOutlet CPVoiceButton *_nextStepActionButton;
}

@property(nonatomic,assign)CPRechargeType rechargeType;

@property(nonatomic,assign)NSInteger payMax;
@property(nonatomic,assign)NSInteger payMin;

@property(nonatomic,assign)BOOL showNoSetPayType;

@end

@implementation CPRechargeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    
    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeBankCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeBankCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeNormalCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeNetBankCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeNetBankCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeAddFriendCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeAddFriendCell class])];


    //右上角按钮点击事件
    self.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
    
    self.rechargeType = CPRechargeByBank;
    [self queryRechargeInfo];
//    [self queryRbankListIsInit:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removeRightItemView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeRightItemView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)loadDefaultSelectedIndexWithRechargeType:(CPRechargeType)rechargeType
{
    _selectedPayIndex = -1;
    if (rechargeType == CPRechargeByWechat) {
        for (int i = 0; i<_wechatList.count; i++) {
            NSDictionary *info = _wechatList[i];
            if ([[info DWStringForKey:@"payType"]intValue]!=3) {
                _selectedPayIndex = i;
                break;
            }
        }
    }else if (rechargeType == CPRechargeByAlipay){
        
        for (int i = 0; i<_alipayList.count; i++) {
            NSDictionary *info = _alipayList[i];
            if ([[info DWStringForKey:@"payType"]intValue]!=3) {
                _selectedPayIndex = i;
                break;
            }
        }
    }else{
        _selectedPayIndex = 0;
    }
}

-(void)reloadDataAndRefreshDefaultSelectedIndex
{
    [self loadDefaultSelectedIndexWithRechargeType:self.rechargeType];
    [_tableView reloadData];
}

-(BOOL)verifySubmitInfo
{
    BOOL isConfirm = NO;
    
    NSArray *dataList;
    switch (self.rechargeType) {
        case CPRechargeByBank:
        {
            dataList = _bankList;
        }break;
        case CPRechargeByWechat:
        {
            dataList = _wechatList;

        }break;
        case CPRechargeByAlipay:
        {
            dataList = _alipayList;

        }break;
        case CPRechargeByQQPay:
        {
            dataList = _qqPayList;
        }break;
        case CPRechargeByOnline:
        {
            dataList = _netBankList;
        }break;
        case CPRechargeByOther:
        {
            dataList = _otherPayList;
        }break;
        default:
            break;
    }
    
    //过滤加好友的情况
    if (self.rechargeType== CPRechargeByWechat || self.rechargeType== CPRechargeByAlipay) {
        NSDictionary *info = dataList[_selectedPayIndex];
        if ([[info DWStringForKey:@"payType"]intValue]==3) {
            return YES;
        }
    }
    
    CGFloat money = [_rechargeAmountTf.text floatValue];
    if (money<=0) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请输入充值金额"];
        return NO;
    }
    
    if (dataList.count>_selectedPayIndex&&_selectedPayIndex!=-1) {
        
        CGFloat max = 0;
        CGFloat min = 0;
        if (self.rechargeType == CPRechargeByOnline) {
            
            max = [[_netBankPayInfo DWStringForKey:@"maxAmount"]floatValue];
            min = [[_netBankPayInfo DWStringForKey:@"minAmount"]floatValue];
        }else{
            NSDictionary *info = dataList[_selectedPayIndex];
            max = [[info DWStringForKey:@"payMax"]floatValue];
            min = [[info DWStringForKey:@"payMin"]floatValue];
        }
        
        if (money<=max && money>=min) {
            return YES;
        }else{
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:[NSString stringWithFormat:@"最小充值金额%.0f 最大充值金额%.0f",min,max]];
            return NO;
        }
        
    }else{
        if (self.rechargeType == CPRechargeByOnline && _netBankPayInfo.allKeys.count>0) {
            return YES;
        }
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请选择充值方式"];
        return NO;
    }

    
    return isConfirm;
}

#pragma mark- creat UI

-(NSArray *)theSameRightBarButtonItems
{
    UIImage *rightItemImage = [UIImage imageNamed:@"top_you_anniu"];
    CPVoiceButton *btn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, rightItemImage.size.width, rightItemImage.size.height);
    [btn addTarget:self action:@selector(showSortViewAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    return @[offsetItem,[[UIBarButtonItem alloc]initWithCustomView:btn]];
}

-(void)buildPayTypeListView
{
    for (UIView *subview in _payTypeScrollView.subviews){
        if ([subview isKindOfClass:[CPRechargePayTypeButton class]]) {
            [subview removeFromSuperview];
        }
    }
    
    NSInteger allNameCount = 0;
    for (NSDictionary *payTpyeInfo in _payTypeList) {
        NSString *name = [payTpyeInfo DWStringForKey:@"name"];
        allNameCount = allNameCount + name.length;
    }
    
    
    CGFloat originX = 0;
    CPRechargePayTypeButton *selectedButton;
    for (int i = 0; i<_payTypeList.count; i++) {
        NSDictionary *payTypeInfo = _payTypeList[i];
        NSString *name = [payTypeInfo DWStringForKey:@"name"];
//        CGFloat scale = (name.length*100.0f) / (allNameCount*100.0f);
        CGRect frame = CGRectMake(originX, 0, _payTypeScrollView.width/_payTypeList.count,_payTypeScrollView.height);
        CPRechargePayTypeButton *button = [CPRechargePayTypeButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.payCode = [payTypeInfo DWStringForKey:@"code"];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:kCOLOR_R_G_B_A(51, 51, 51, 1) forState:UIControlStateNormal];
        [button setTitleColor:kMainColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button addTarget:self action:@selector(selectedPayTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_payTypeScrollView addSubview:button];
        
        originX = button.rightX;
        if (i == 0) {
            selectedButton = button;
        }

    }

    if (selectedButton) {
        _payTypeMarkLabel.hidden = NO;
        [self selectedPayTypeAction:selectedButton];
    }else{
        _payTypeMarkLabel.hidden = YES;
    }
}

#pragma mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _tableHeaderView.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _tableHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.showNoSetPayType?_noPayTypeAlertView.height:_tableFooterView.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.showNoSetPayType?_noPayTypeAlertView:_tableFooterView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.rechargeType) {
        case CPRechargeByQQPay:
            return _qqPayList.count;
            break;
        case CPRechargeByAlipay:
            return _alipayList.count;
            break;
        case CPRechargeByWechat:
            return _wechatList.count;
            break;
        case CPRechargeByBank:
            return _bankList.count;
            break;
        case CPRechargeByOnline:
            return _netBankList.count;
            break;
        case CPRechargeByOther:
            return _otherPayList.count;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isSelected = (_selectedPayIndex == indexPath.row)?YES:NO;
    switch (self.rechargeType) {
        case CPRechargeByQQPay:
        {
            CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
            NSDictionary *info = _qqPayList[indexPath.row];
            [cell addBankName:[info DWStringForKey:@"payName"] detailInfo:[info DWStringForKey:@"payDesc"] selected:isSelected];
            return cell;
        }break;
        case CPRechargeByOther:
        {
            CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
            NSDictionary *info = _otherPayList[indexPath.row];
            [cell addBankName:[info DWStringForKey:@"payName"] detailInfo:[info DWStringForKey:@"payDesc"] selected:isSelected];
            return cell;
        }break;
        case CPRechargeByAlipay:
        {
            NSDictionary *info = _alipayList[indexPath.row];
            int payType = [[info DWStringForKey:@"payType"]intValue];
            
            if (payType == 3) {
                
                CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
                [cell addBankName:[info DWStringForKey:@"payName"] detailInfo:[info DWStringForKey:@"payDesc"] selected:isSelected];
                return cell;
//                CPRechargeAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeAddFriendCell class])];
//                [cell addTitleText:[info DWStringForKey:@"payName"] detailText:[NSString stringWithFormat:@"支付宝账号:%@ 支付宝名称:%@",[info DWStringForKey:@"code"],[info DWStringForKey:@"name"]] imageUrlString:[[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[info DWStringForKey:@"payImg"]]];
//                return cell;
            }else{
                
                CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
                [cell addBankName:[info DWStringForKey:@"payName"] detailInfo:[info DWStringForKey:@"payDesc"] selected:isSelected];

                return cell;
            }
            
            
        }break;
        case CPRechargeByWechat:
        {
            NSDictionary *info = _wechatList[indexPath.row];
            int payType = [[info DWStringForKey:@"payType"]intValue];
            if (payType == 3) {
                
                CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
                [cell addBankName:[info DWStringForKey:@"payName"] detailInfo:[info DWStringForKey:@"payDesc"] selected:isSelected];
                return cell;
                
//                CPRechargeAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeAddFriendCell class])];
//                [cell addTitleText:[info DWStringForKey:@"payName"] detailText:[NSString stringWithFormat:@"微信账号:%@ 微信昵称:%@",[info DWStringForKey:@"code"],[info DWStringForKey:@"name"]] imageUrlString:[[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[info DWStringForKey:@"payImg"]]];
//                return cell;
            }else{
                
                CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
                [cell addBankName:[info DWStringForKey:@"payName"] detailInfo:[info DWStringForKey:@"payDesc"] selected:isSelected];
                return cell;
            }

        }break;
        case CPRechargeByBank:
        {
            CPRechargeBankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeBankCell class])];
            NSDictionary *info = _bankList[indexPath.row];
            [cell addBankName:[info DWStringForKey:@"bankName"] collectionName:[info DWStringForKey:@"accountName"] infoMessage:[NSString stringWithFormat:@"%@ %@",[info DWStringForKey:@"bankAddr"],[info DWStringForKey:@"accountCode"]] selected:isSelected];
            return cell;
            
        }break;
        case CPRechargeByOnline:
        {
            CPRechargeNetBankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNetBankCell class])];
            NSDictionary *info = _netBankList[indexPath.row];
            [cell addBankName:[info DWStringForKey:@"name"] selected:isSelected];
            return cell;
        }break;
        default:
            break;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedPayIndex = indexPath.row;
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.rechargeType) {
        case CPRechargeByQQPay:
        case CPRechargeByOther:
        {
            return 60.0f;
        }break;
        case CPRechargeByAlipay:
        {
            NSDictionary *info = _alipayList[indexPath.row];
            int payType = [[info DWStringForKey:@"payType"]intValue];
            if (payType == 3) {
                return 60.0f;
            }else{
                
                return 60.0f;
            }
            
            
        }break;
        case CPRechargeByWechat:
        {
            NSDictionary *info = _wechatList[indexPath.row];
            int payType = [[info DWStringForKey:@"payType"]intValue];
            if (payType == 3) {
                return 60.0f;
            }else{
                
                return 60.0f;
            }
            
        }break;
        case CPRechargeByBank:
        {
            return 110.0f;
            
        }break;
        case CPRechargeByOnline:
        {
            return 44.0f;
        }break;
        default:
            break;
    }
    
    return 0;
}

#pragma mark- network
//\

-(void)queryRbankListIsInit:(BOOL)isInit
{
    if (!isInit) {
        [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    }

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRbankList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSArray *infoList = [request.resultInfo DWArrayForKey:@"data"];
                   if (infoList.count>0) {
                       _bankList = infoList;
                       self.showNoSetPayType = NO;
                   }else{
                       self.showNoSetPayType = YES;
                   }
                   [self reloadDataAndRefreshDefaultSelectedIndex];
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

-(void)queryRonlineList
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRonlineList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   _netBankPayInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSDictionary *expandInfo = [_netBankPayInfo DWDictionaryForKey:@"expand"];
                   _netBankList = [expandInfo DWArrayForKey:@"bankList"];
                   if (_netBankPayInfo.allKeys.count>0) {
                       self.showNoSetPayType = NO;

                   }else{
                       self.showNoSetPayType = YES;
                   }
                   [self reloadDataAndRefreshDefaultSelectedIndex];

               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}



-(void)queryRqqpayList
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRqqpayList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSArray *infoList = [request.resultInfo DWArrayForKey:@"data"];
                   if (infoList.count>0) {
                       _qqPayList = infoList;
                       self.showNoSetPayType = NO;
                   }else{
                       self.showNoSetPayType = YES;
                   }
                   [self reloadDataAndRefreshDefaultSelectedIndex];
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

-(void)queryRotherList
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRotherList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSArray *infoList = [request.resultInfo DWArrayForKey:@"data"];
                   if (infoList.count>0) {
                       _otherPayList = infoList;
                       self.showNoSetPayType = NO;
                   }else{
                       self.showNoSetPayType = YES;
                   }
                   [self reloadDataAndRefreshDefaultSelectedIndex];
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}


-(void)queryRwechatList
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRwechatList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSArray *infoList = [request.resultInfo DWArrayForKey:@"data"];
                   if (infoList.count>0) {
                       _wechatList = infoList;
                       self.showNoSetPayType = NO;
                   }else{
                       self.showNoSetPayType = YES;
                   }
                   [self reloadDataAndRefreshDefaultSelectedIndex];
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}


-(void)queryRalipayList
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRalipayList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSArray *infoList = [request.resultInfo DWArrayForKey:@"data"];
                   if (infoList.count>0) {
                       _alipayList = infoList;
                       self.showNoSetPayType = NO;
                   }else{
                       self.showNoSetPayType = YES;
                   }
                   [self reloadDataAndRefreshDefaultSelectedIndex];
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}


-(void)queryRechargeInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRecharge
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   
                   _memberNameLabel.text = [info DWStringForKey:@"code"];
                   NSString *balanceDes = [NSString stringWithFormat:@"账户余额:%@元",[info DWStringForKey:@"amount"]];
                   NSMutableAttributedString *attDes = [[NSMutableAttributedString alloc] initWithString:balanceDes attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(153, 153, 153, 1)}];
                   
                   [attDes addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[balanceDes rangeOfString:[info DWStringForKey:@"amount"]]];
                   _balanceLabel.attributedText = attDes;
                   _rechargeTipLabel.text = [info DWStringForKey:@"rechargeTip"];
                   if (_payTypeList.count == 0) {
                       _payTypeList = [info DWArrayForKey:@"payTypeList"];
                       [self buildPayTypeListView];
                   }
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}

-(void)queryNextBankInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_bankList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"money"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"id"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRbankNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   CPRechargeBankNextStepVC *vc = [CPRechargeBankNextStepVC new];
                   NSMutableDictionary *mInfo = [[NSMutableDictionary alloc]initWithDictionary:[info DWDictionaryForKey:@"bank"]];
                   [mInfo setObject:[info DWStringForKey:@"money"] forKey:@"money"];
                   [mInfo setObject:[info DWStringForKey:@"orderNo"] forKey:@"orderNo"];
                   [mInfo setObject:[info DWStringForKey:@"saveTime"] forKey:@"saveTime"];

                   vc.bankInfo = mInfo;
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                   [self.navigationController pushViewController:vc animated:YES];

                   /*
                    {
                        accountCode = 6217711112516313;
                        accountName = "\U82d1\U6625\U6885";
                        bankAddr = "\U90d1\U5dde\U4eac\U5e7f\U8def\U652f\U884c";
                        bankName = "\U4e2d\U4fe1\U94f6\U884c";
                        id = 14;
                        payMax = 200000;
                        payMin = 50;
                    }
                    */
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryNextQQPay
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_qqPayList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    [paramsDic setObject:[CookBook_GlobalDataManager shareGlobalData].domainUrlString forKey:@"baseUrl"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRqqpayNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   if ([[info DWStringForKey:@"needDown"]intValue] == 3) {
                       //跳外部
                       NSString *urlString = [info DWStringForKey:@"payUrl"];
                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                   }else{
                       CPRechargeThirdQRCodeVC *vc = [CPRechargeThirdQRCodeVC new];
                       vc.payInfo = info;
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                       });
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryNextOtherPay
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_otherPayList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    [paramsDic setObject:[CookBook_GlobalDataManager shareGlobalData].domainUrlString forKey:@"baseUrl"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRotherNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   if ([[info DWStringForKey:@"needDown"]intValue] == 3) {
                       //跳外部
                       NSString *urlString = [info DWStringForKey:@"payUrl"];
                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                   }else{
                       NSDictionary *chargeInfo = [_otherPayList objectAtIndex:_selectedPayIndex];
                       CPRechargeThirdQRCodeVC *vc = [CPRechargeThirdQRCodeVC new];
                       vc.payInfo = info;
                       vc.title = [chargeInfo DWStringForKey:@"payName"];
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}


-(void)queryWechatScanNext
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_wechatList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRwechatScanNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   CPRechargeSelfQRCodeVC *vc = [CPRechargeSelfQRCodeVC new];
                   vc.rechargeInfo = info;
                   vc.qrCodeType = CPRechargeQRCodeTypeWechatPay;
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                   [self.navigationController pushViewController:vc animated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

//


-(void)queryWechatThirdNext
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_wechatList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
        [paramsDic setObject:[CookBook_GlobalDataManager shareGlobalData].domainUrlString forKey:@"baseUrl"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserWechatNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   if ([[info DWStringForKey:@"needDown"]intValue] == 3 || [[info DWStringForKey:@"page"]rangeOfString:@"xinMa"].length>0) {
                       //直接跳转url
                       /*
                        needDown = 0;
                        orderNo = p2017101618151100238062;
                        page = xinMaWA;
                        */
                       NSString *urlString = [info DWStringForKey:@"payUrl"];
                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                   }else{
                       CPRechargeThirdQRCodeVC *vc = [CPRechargeThirdQRCodeVC new];
                       vc.payInfo = info;
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                   
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryAlipayThirdNext
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_alipayList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    [paramsDic setObject:[CookBook_GlobalDataManager shareGlobalData].domainUrlString forKey:@"baseUrl"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserAlipayNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   if ([[info DWStringForKey:@"needDown"]intValue] == 3) {
                       //跳外部
                       NSString *urlString = [info DWStringForKey:@"payUrl"];
                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                   }else{
                       CPRechargeThirdQRCodeVC *vc = [CPRechargeThirdQRCodeVC new];
                       vc.payInfo = info;
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                   
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

-(void)queryAlipayScanNext
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_alipayList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRalipayScanNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   CPRechargeSelfQRCodeVC *vc = [CPRechargeSelfQRCodeVC new];
                   vc.rechargeInfo = info;
                   vc.qrCodeType = CPRechargeQRCodeTypeAliPay;
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                   [self.navigationController pushViewController:vc animated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}



-(void)queryWechatToBankCardNext
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_wechatList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserWechatBankNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   CPRechargeAlipayToBankVC *vc = [CPRechargeAlipayToBankVC new];
                   vc.type = 1;
                   vc.rechargeInfo = info;
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                   [self.navigationController pushViewController:vc animated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryAlipayToBankCardNext
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSDictionary *info = [_alipayList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRalipayBankNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   CPRechargeAlipayToBankVC *vc = [CPRechargeAlipayToBankVC new];
                   vc.type = 0;
                   vc.rechargeInfo = info;
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                   });
                   [self.navigationController pushViewController:vc animated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryWebChargeOnCPWebViewControllerWithPayUrl:(NSString *)payUrl
                                                type:(NSString *)type
                                               payId:(NSString *)payId
                                              amount:(NSString *)amount
                                            bankName:(NSString *)bankName
{
    NSMutableString *domainString = [[NSMutableString alloc]initWithString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString];
    
    NSString *urlString = [payUrl stringByAppendingString:[NSString stringWithFormat:@"/common/recharge/third?isH5=1&memberId=%@&type=%@&payId=%@&amount=%@%@%@&baseUrl=%@",[CookBook_User shareUser].tokenInfo.memberId,type,payId,amount,bankName.length>0?@"&bankName=":@"",bankName.length>0?bankName:@"",domainString]];
    CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:urlString];
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

-(void)queryWebChargeWithPayUrl:(NSString *)payUrl
                           type:(NSString *)type
                          payId:(NSString *)payId
                         amount:(NSString *)amount
                       bankName:(NSString *)bankName
{
    NSMutableString *domainString = [[NSMutableString alloc]initWithString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString];

    NSString *urlString = [payUrl stringByAppendingString:[NSString stringWithFormat:@"/common/recharge/third?isH5=1&memberId=%@&type=%@&payId=%@&amount=%@%@%@&baseUrl=%@",[CookBook_User shareUser].tokenInfo.memberId,type,payId,amount,bankName.length>0?@"&bankName=":@"",bankName.length>0?bankName:@"",domainString]];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];

    /*
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
    toWebVC.title = @"充值";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
     */
    
    /*
     payUrl + ‘/common/recharge/third?memberId=x&type=x&payId=x&amount=x&bankName=x&baseUrl=x’
     payUrl支付地址memberId会员ID payId支付ID amount充值金额 baseUrl 接口请求到的url
     type支付类型 1微信 2支付宝 7QQ钱包 4网银支付
     bankName银行名称，没有放空

     */
}


#pragma mark- action

-(void)removeRightItemView
{
    for (UIView *subview in self.navigationController.view.subviews) {
        if ([subview isKindOfClass:[CPRechargeRightMenuView class]]) {
            CPRechargeRightMenuView *menuView = (CPRechargeRightMenuView *)subview;
            [menuView dismiss];
        }
    }
}

-(void)showSortViewAction
{
    @synchronized(self){
        
        for (UIView *subview in self.navigationController.view.subviews) {
            if ([subview isKindOfClass:[CPRechargeRightMenuView class]]) {
                CPRechargeRightMenuView *menuView = (CPRechargeRightMenuView *)subview;
                [menuView dismiss];
                return;
            }
        }
        
        [CPRechargeRightMenuView showRightMenuViewOnView:self.navigationController.view actionNavigationController:self.navigationController];
    }
}

-(void)selectedPayTypeAction:(CPRechargePayTypeButton *)button
{
    
    if (_markSelectedButton) {
        _markSelectedButton.selected = NO;
    }
    _markSelectedButton = button;
    _markSelectedButton.selected = YES;
    
    [_nextStepActionButton setTitle:@"下一步" forState:UIControlStateNormal];
    if ([button.payCode isEqualToString:@"bank"]) {
        //银行转账
        self.rechargeType = CPRechargeByBank;
        if (_bankList.count == 0) {
            [self queryRbankListIsInit:NO];
        }else{
            self.showNoSetPayType = NO;
        }
        
    }else if ([button.payCode isEqualToString:@"wechat"]) {
        
        //微信
        self.rechargeType = CPRechargeByWechat;
        if (_wechatList.count == 0) {
            [self queryRwechatList];
        }else{
            self.showNoSetPayType = NO;
        }
        
    }else if ([button.payCode isEqualToString:@"alipay"]) {
        
        //支付宝
        self.rechargeType = CPRechargeByAlipay;
        if (_alipayList.count == 0) {
            [self queryRalipayList];
        }else{
            self.showNoSetPayType = NO;
        }
    }else if ([button.payCode isEqualToString:@"qqpay"]) {
        
        //QQ钱包
        self.rechargeType = CPRechargeByQQPay;
        if (_qqPayList.count == 0) {
            [self queryRqqpayList];
        }else{
            self.showNoSetPayType = NO;
        }
        
    }else if ([button.payCode isEqualToString:@"online"]) {
        
        //网银支付
        self.rechargeType = CPRechargeByOnline;
        if (_netBankList.count == 0) {
            [self queryRonlineList];
        }else{
            self.showNoSetPayType = NO;
        }
        [_nextStepActionButton setTitle:@"立即充值" forState:UIControlStateNormal];


    }else if ([button.payCode isEqualToString:@"other"]) {
        
        //其他支付
        self.rechargeType = CPRechargeByOther;
        if (_otherPayList.count == 0) {
            [self queryRotherList];
        }else{
            self.showNoSetPayType = NO;
        }
    }
    
    [self loadRechargeTypeMarkLabelFrameWithOriginX:button.originX width:button.width];
    [self loadDefaultSelectedIndexWithRechargeType:self.rechargeType];
    [_tableView reloadData];
}

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            //刷新
            [self queryRechargeInfo];
            
        }break;
        case 11:
        {
            //清空充值金额
            _rechargeAmountTf.text = nil;
            
        }break;
        case 12:
        {
            //充值100
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 100;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            
        }break;
        case 13:
        {
            //充值500
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 500;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
        }break;
        case 14:
        {
            //充值一千
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 1000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            
        }break;
        case 15:
        {
            //充值五千
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 5000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            
        }break;
        case 16:
        {
            //充值一万
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 10000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            
        }break;
        case 17:
        {
            //充值五万
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 50000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            
        }break;
        case 23:
        {
            //下一步
            if ([self verifySubmitInfo]) {
                
                switch (self.rechargeType) {
                    case CPRechargeByBank:
                    {
                        [self queryNextBankInfo];
                    }break;
                    case CPRechargeByWechat:
                    {
                        if (_selectedPayIndex<0) {
                            return;
                        }
                        
                        NSDictionary *info = [_wechatList objectAtIndex:_selectedPayIndex];
                        NSString *code = [info DWStringForKey:@"code"];
                        int type = [[info DWStringForKey:@"type"]intValue];
                        int payType = [[info DWStringForKey:@"payType"]intValue];
                        
                        
                        if ([code isEqualToString:@"#scan#"]) {
                            //第三方
                            if (type == 1) {
                                //扫码
                                [self queryWechatThirdNext];
                            }else if (type == 2) {
                                //跳第三方
                                [self queryWebChargeWithPayUrl:[info DWStringForKey:@"payImg"] type:@"1" payId:[info DWStringForKey:@"id"] amount:_rechargeAmountTf.text bankName:@""];
                            }
                            
                        }else{
                            //平台
                            if (payType == 2) {
                                //扫码
                                [self queryWechatScanNext];
                            }else if (payType == 3) {
                                
                                CPAddFriendRechargeVC *vc = [CPAddFriendRechargeVC new];
                                vc.type = 1;
                                [vc addTitleText:[info DWStringForKey:@"payName"] detailText:[NSString stringWithFormat:@"微信账号:%@ 微信昵称:%@",[info DWStringForKey:@"code"],[info DWStringForKey:@"name"]] imageUrlString:[[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[info DWStringForKey:@"payImg"]]];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                                });
                                [self.navigationController pushViewController:vc animated:YES];

                                
                            }else if (payType == 5) {
                                
                                [self queryWechatToBankCardNext];
                            }
                            
                        }

                        
                    }break;
                    case CPRechargeByAlipay:
                    {
                        if (_selectedPayIndex<0) {
                            return;
                        }
                        
                        
                        NSDictionary *info = [_alipayList objectAtIndex:_selectedPayIndex];
                        NSString *code = [info DWStringForKey:@"code"];
                        int type = [[info DWStringForKey:@"type"]intValue];
                        int payType = [[info DWStringForKey:@"payType"]intValue];
                        
                        if ([code isEqualToString:@"#scan#"]) {
                            //第三方
                            if (type == 1) {
                                //扫码
                                [self queryAlipayThirdNext];
                            }else if (type == 2) {
                                //跳第三方
                                [self queryWebChargeWithPayUrl:[info DWStringForKey:@"payImg"] type:@"2" payId:[info DWStringForKey:@"id"] amount:_rechargeAmountTf.text bankName:@""];
                                
                            }
                        }else{
                            //平台
                            if (payType == 2) {
                                //扫码
                                [self queryAlipayScanNext];
                                
                            }else if (payType == 3) {
                                
                                CPAddFriendRechargeVC *vc = [CPAddFriendRechargeVC new];
                                vc.type = 0;
                                [vc addTitleText:[info DWStringForKey:@"payName"] detailText:[NSString stringWithFormat:@"支付宝账号:%@ 支付宝名称:%@",[info DWStringForKey:@"code"],[info DWStringForKey:@"name"]] imageUrlString:[[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[info DWStringForKey:@"payImg"]]];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                                });
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }else if (payType == 5) {
                                
                                [self queryAlipayToBankCardNext];
                            }
                        }
                        
                        

                    }break;
                    case CPRechargeByOther:
                    {
                        NSDictionary *info = [_otherPayList objectAtIndex:_selectedPayIndex];
                        NSString *code = [info DWStringForKey:@"code"];
                        int type = [[info DWStringForKey:@"type"]intValue];
                        if ([code isEqualToString:@"#scan#"]) {
                            //第三方
                            if (type == 1) {
                                //扫码
                                [self queryNextOtherPay];
                                
                                
                            }else if (type == 2) {
                                //跳第三方
                                [self queryWebChargeWithPayUrl:[info DWStringForKey:@"payImg"] type:@"8" payId:[info DWStringForKey:@"id"] amount:_rechargeAmountTf.text bankName:@""];
                                
                            }
                        }
                    }break;
                    case CPRechargeByQQPay:
                    {
                        
                        NSDictionary *info = [_qqPayList objectAtIndex:_selectedPayIndex];
                        NSString *code = [info DWStringForKey:@"code"];
                        int type = [[info DWStringForKey:@"type"]intValue];
                        if ([code isEqualToString:@"#scan#"]) {
                            //第三方
                            if (type == 1) {
                                //扫码
                                [self queryNextQQPay];
                                
                                
                            }else if (type == 2) {
                                //跳第三方
                                 [self queryWebChargeWithPayUrl:[info DWStringForKey:@"payImg"] type:@"7" payId:[info DWStringForKey:@"id"] amount:_rechargeAmountTf.text bankName:@""];
                                
                            }
                        }
                        
                    }break;
                    case CPRechargeByOnline:
                    {
                        NSString *bankName = @"";
                        if (_netBankList.count>0) {
                            NSDictionary *info = [_netBankList objectAtIndex:_selectedPayIndex];
                            bankName = [info DWStringForKey:@"id"];
                            if ([[info DWStringForKey:@"stute"]isEqualToString:@"1"]) {
                                [self queryWebChargeOnCPWebViewControllerWithPayUrl:[_netBankPayInfo DWStringForKey:@"payUrl"] type:@"4" payId:[_netBankPayInfo DWStringForKey:@"id"] amount:_rechargeAmountTf.text bankName:bankName];
                                return;
                            }
                        }
                        
                    
                        [self queryWebChargeWithPayUrl:[_netBankPayInfo DWStringForKey:@"payUrl"] type:@"4" payId:[_netBankPayInfo DWStringForKey:@"id"] amount:_rechargeAmountTf.text bankName:bankName];
                    }break;
                        
                    default:
                        break;
                }
            }
            
        }break;
        default:
            break;
    }
}

-(void)loadRechargeTypeMarkLabelFrameWithOriginX:(CGFloat)originX
                                           width:(CGFloat)width
{
    [UIView animateWithDuration:0.2 animations:^{
        _payTypeMarkLabel.originX = originX;
        _payTypeMarkLabel.width = width;
    }];
}

@end
