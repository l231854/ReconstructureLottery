//
//  CPBuyLotteryDetailVC.m
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBuyLotteryDetailVC.h"
#import "CookBook_BuyLotterySectionView.h"
#import "CPSelectedOptionsView.h"
#import "CookBook_BuyCustomLotteryConfirmView.h"
#import "CookBook_BuyFastLotteryConfirmView.h"
#import "CookBook_BuyLotteryFastItem.h"
#import "CPBetRecordVC.h"
#import "CookBook_BuyLetterLotterySectionView.h"
#import "CookBook_LotteryResultDetailWebVC.h"
#import "CPRechargeMainViewController.h"

@interface CPBuyLotteryDetailVC ()<CPBuyLotterySectionViewDelegate,CPBuyLetterLotterySectionViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_topView;
    
    NSMutableArray *_sectionViews;
    
    IBOutlet UIView *_sortView;

    IBOutlet UIView *_sortBetTypeView;

    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_openDateLabel;
    IBOutlet UILabel *_countDateLabel;
    IBOutlet UILabel *_numberLabel;
    
    IBOutlet UILabel *_betTypeMarkLabel;
    
    UIButton *_markBetButton;
    IBOutlet UIButton *_fastBetButton;
    IBOutlet UIButton *_customBetButton;

    NSDate *_openDate;
    
    NSTimer *_openDateTimer;
    
    IBOutlet UIView *_titleView;
    IBOutlet UIButton *_titleButton;
    
    NSMutableDictionary *_betResultDic;
    
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UIView *_balanceView;

    NSString *_balance;
    
    NSDictionary *_specailOneFirstPlayInfo;
    NSDictionary *_specailOneSecondPlayInfo;
    NSInteger _specailOneQueryKindIndex;

    NSTimeInterval _beijingTiemDistance;
    
    
    IBOutlet CPVoiceButton *_lianWeiBetButton;
    IBOutlet CPVoiceButton *_lianXiaoBetButton;
    IBOutlet UILabel *_lianXiaoWeiBetTypeMarkLabel;
    IBOutlet UIView *_lianXiaoWeiSortBetTypeView;

    IBOutlet UIView *_topCenterView;
    IBOutlet UIView *_topTitleView;
    
    BOOL _isQueryInfoIng;
    
    CookBook_LotteryShowResultView *_resultView;
    IBOutlet CPVoiceButton *_trendButton;
    
    CookBook_Request *_betRequest;
    CookBook_Request *_playInfoRequest;
}

@property(nonatomic,assign)CPBuyLotteryBetType betType;
@property(nonatomic,assign)NSTimeInterval betEndTimeInterval;

@property(nonatomic,retain)NSDictionary *betNameDic;

@property(nonatomic,retain)NSArray *playKindList;
@property(nonatomic,retain)NSArray *playKindNameList;

@property(nonatomic,assign)NSInteger selectedPlayKindIndex;

@property(nonatomic,strong)NSMutableDictionary *heXiaoLotteryInfo;


/**
 bonus: 5.8
 playName:合肖:猪&牛
 */
//@property(nonatomic,strong)NSMutableDictionary *heXiaoBetLotteryInfo;

@property(nonatomic,strong)NSArray *heXiaoBetLotteryInfos;
@property(nonatomic,strong)NSString *heXiaoBetBonus;
@property(nonatomic,strong)NSString *heXiaoPlayId;


/*
 自选不中
 */
@property(nonatomic,strong)NSDictionary *ziXuanBetInfo;
@property(nonatomic,strong)NSString *ziXuanBetBonus;
@property(nonatomic,strong)NSString *ziXuanBetPlayId;


/*
 连码
 */
@property(nonatomic,strong)NSArray *lianMaLotteryInfos;

/*
 [
     {
         bonus = 100;
         bonus2 = 23;
         maxCount = 7;
         minCount = 3;
         playId = "17-1-17102";
         playId2 = "17-1-17101";
         playName = "\U4e09\U4e2d\U4e8c";
     }
 ]
 */
@property(nonatomic,strong)NSMutableArray *lianMaBetInfos;


@property(nonatomic,strong)NSMutableArray *lianXiaoWeiBetInfos;

@end

@implementation CPBuyLotteryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    //右上角按钮点击事件
    UIImage *rightItemImage = [UIImage imageNamed:@"top_you_anniu"];
    CPVoiceButton *btn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, rightItemImage.size.width, rightItemImage.size.height);
    [btn addTarget:self action:@selector(showSortViewAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    self.navigationItem.rightBarButtonItems = @[offsetItem,[[UIBarButtonItem alloc]initWithCustomView:btn]];
    
    //设置底部的趋势/历史开奖按钮
    NSString *resultTypeString = [_playInfo DWStringForKey:@"type"];
    CPLotteryResultType resultType = CPLotteryResultTypeByTypeString(resultTypeString);
    if (resultType == CPLotteryResultForXGLHC || resultType == CPLotteryResultForPCDD) {
        [_trendButton setTitle:@"历史开奖" forState:UIControlStateNormal];
    }
    
    [CookBook_BuyLotteryManager shareManager].currentBuyLotteryType = resultType;
    
    //初始化下注选择类型的按钮
    
    _lianXiaoWeiBetTypeMarkLabel.width = kScreenWidth/2.0f;
    _betTypeMarkLabel.width = kScreenWidth/2.0f;

    if (resultType == CPLotteryResultForXGLHC) {
        _fastBetButton.selected = NO;
        _betTypeMarkLabel.originX = 0;
        _betType = CPBuyLotteryBetCustom;
        _markBetButton = _customBetButton;
    }else{
        _customBetButton.selected = NO;
        _betTypeMarkLabel.originX = kScreenWidth/2.0f;
        _betType = CPBuyLotteryBetFast;
        _markBetButton = _fastBetButton;
    }
    _markBetButton.selected = YES;

    
    //设置titleView
    self.navigationItem.titleView = _titleView;
    
    
    //初始化玩法选择
    _selectedPlayKindIndex = -1;
    NSString *originPlayName = [_playInfo DWStringForKey:@"playName"];
    for (int i =0; i<self.playKindList.count; i++) {
        NSDictionary *kindInfo = self.playKindList[i];
        NSString *playName = [kindInfo DWStringForKey:@"playName"];
        if ([originPlayName isEqualToString:playName]) {
            self.selectedPlayKindIndex = i;
            break;
        }
    }
    
    //根据num设置lotteryType
    NSInteger num = [[_playInfo DWStringForKey:@"num"]integerValue];
    if (num == 27 || num == 28) {
        _specailOneQueryKindIndex = -1;
        self.lotteryType = CPBuyLotteryTypeSpecailOne;
        if (self.selectedPlayKindIndex == 0) {
            _specailOneFirstPlayInfo = [[NSDictionary alloc]initWithDictionary:self.playInfo];
        }else if (self.selectedPlayKindIndex == 1){
            _specailOneSecondPlayInfo = [[NSDictionary alloc]initWithDictionary:self.playInfo];
        }
    }else if (num == 18 || resultType == CPLotteryResultForXGLHC) {
        self.lotteryType = CPBuyLotteryTypeSpecailTwo;
    }else{
        self.lotteryType = CPBuyLotteryTypeNormal;
    }

    
    //刷新相关界面
    [self reloadTopViewData];
    [self reloadContentView];
    [self reloadOpenDate];
    _openDateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadOpenDate) userInfo:nil repeats:YES];
    
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryBuyLotteryIsOnlyReloadTopView:YES palyKindInfo:nil];
        [self queryBalanceInfo];
    }];
    [self queryBalanceInfo];
    _betResultDic = [NSMutableDictionary new];
    
    
    //监听刷新余额
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryBalanceInfo) name:kNotificationNameForLoginSucceed object:nil];
    
    //获取北京时间
    [self reloadBeiJingTime];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_openDateTimer invalidate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_betRequest) {
        [_betRequest stop];
        _betRequest = nil;
    }
    if (_playInfoRequest) {
        [_playInfoRequest stop];
        _playInfoRequest = nil;
    }
}

#pragma mark- busineess


/**
 是否是数字盘
 */
-(BOOL)isNumberPan
{
    BOOL isNumber = NO;
    NSString *name = self.playKindNameList[_selectedPlayKindIndex];
    if ([name rangeOfString:@"数字盘"].length>0) {
        isNumber = YES;
    }
    return isNumber;
}

-(BOOL)checkLianMaVerifyAndIsBet:(BOOL*)isBet
                        errorMsg:(NSString **)errorMsg
{
    BOOL isVefiry = YES;
    *isBet = NO;
    self.lianMaBetInfos = [NSMutableArray new];
    for (CookBook_BuyLetterLotterySectionView *sectionView in _sectionViews) {
        
        if ([sectionView isSelectedLotterys]) {
            *isBet = YES;
            if (![sectionView isVerifySelectedLotterys]) {
                isVefiry = NO;
                if (*errorMsg) {
                    *errorMsg = [NSString stringWithFormat:@"%@下注号码有误！",[sectionView.lotteryInfo DWStringForKey:@"playName"]];
                }
                break;
            }else{
                [self.lianMaBetInfos addObjectsFromArray:[sectionView betValuesInfo]];
            }
        }
    }

    return isVefiry;
}

-(BOOL)checkLianXiaoWeiVerifyAndIsBet:(BOOL*)isBet
                             errorMsg:(NSString **)errorMsg
{
    BOOL isVefiry = YES;
    *isBet = NO;
    self.lianXiaoWeiBetInfos = [NSMutableArray new];
    for (CookBook_BuyLotterySectionView *sectionView in _sectionViews) {
        
        if ([sectionView isSelectedLianXiaoWeiLotterys]) {
            *isBet = YES;
            if (![sectionView isVerifySelectedLianXiaoWeiLotterys]) {
                isVefiry = NO;
                if (*errorMsg) {
                    *errorMsg = [NSString stringWithFormat:@"%@下注号码有误！",[sectionView.buySectionInfo DWStringForKey:@"name"]];
                }
                break;
            }else{
                [self.lianXiaoWeiBetInfos addObjectsFromArray:[sectionView cookBook_betValuesInfo]];
            }
        }
    }
    
    return isVefiry;
}

/*

 */

#pragma mark- setter && getter

-(NSArray *)lianMaLotteryInfos
{
    if (!_lianMaLotteryInfos) {
        _lianMaLotteryInfos = [NSMutableArray new];
        NSMutableDictionary *info = [NSMutableDictionary new];
        [info setObject:@"三中二" forKey:@"playName"];
        [info setObject:@"17-1-17102" forKey:@"playId"];
        [info setObject:@"17-1-17101" forKey:@"playId2"];
        [info setObject:@"100" forKey:@"bonus"];
        [info setObject:@"23" forKey:@"bonus2"];
        [info setObject:@"7" forKey:@"maxCount"];
        [info setObject:@"3" forKey:@"minCount"];

        NSMutableDictionary *info2 = [NSMutableDictionary new];
        [info2 setObject:@"三全中" forKey:@"playName"];
        [info2 setObject:@"17-2-17201" forKey:@"playId"];
        [info2 setObject:@"650" forKey:@"bonus"];
        [info2 setObject:@"10" forKey:@"maxCount"];
        [info2 setObject:@"3" forKey:@"minCount"];
        
        NSMutableDictionary *info3 = [NSMutableDictionary new];
        [info3 setObject:@"二全中" forKey:@"playName"];
        [info3 setObject:@"17-3-17301" forKey:@"playId"];
        [info3 setObject:@"70" forKey:@"bonus"];
        [info3 setObject:@"7" forKey:@"maxCount"];
        [info3 setObject:@"2" forKey:@"minCount"];
        
        NSMutableDictionary *info4 = [NSMutableDictionary new];
        [info4 setObject:@"二中特" forKey:@"playName"];
        [info4 setObject:@"17-4-17402" forKey:@"playId"];
        [info4 setObject:@"17-4-17401" forKey:@"playId2"];
        [info4 setObject:@"52" forKey:@"bonus"];
        [info4 setObject:@"33" forKey:@"bonus2"];
        [info4 setObject:@"7" forKey:@"maxCount"];
        [info4 setObject:@"2" forKey:@"minCount"];
        
        
        NSMutableDictionary *info5 = [NSMutableDictionary new];
        [info5 setObject:@"特串" forKey:@"playName"];
        [info5 setObject:@"17-5-17501" forKey:@"playId"];
        [info5 setObject:@"158" forKey:@"bonus"];
        [info5 setObject:@"7" forKey:@"maxCount"];
        [info5 setObject:@"2" forKey:@"minCount"];
        
        _lianMaLotteryInfos = @[info,info2,info3,info4,info5];
        
    }
    return _lianMaLotteryInfos;
}

-(NSMutableDictionary *)heXiaoLotteryInfo
{
    if (!_heXiaoLotteryInfo) {
        _heXiaoLotteryInfo = [NSMutableDictionary new];
        [_heXiaoLotteryInfo setObject:@"合肖" forKey:@"name"];
        NSMutableArray *infos  =[NSMutableArray new];
        NSDictionary *sxNames = [_playInfo DWDictionaryForKey:@"sxNames"];
        for (int i=0; i<sxNames.allKeys.count; i++) {
            NSString *key = sxNames.allKeys[i];
            NSString *name = [sxNames objectForKey:key];
            name = [name stringByReplacingOccurrencesOfString:@"," withString:@" "];
            NSMutableDictionary *info = [NSMutableDictionary new];
            [info setObject:key forKey:@"playName"];
            [info setObject:name forKey:@"bonus"];
            [infos addObject:info];

        }
        
        [_heXiaoLotteryInfo setObject:infos forKey:@"list"];
    }
    return _heXiaoLotteryInfo;
}

-(void)setSelectedPlayKindIndex:(NSInteger)selectedPlayKindIndex
{
    if (_selectedPlayKindIndex == selectedPlayKindIndex) {
        return;
    }
    _selectedPlayKindIndex = selectedPlayKindIndex;
    [_titleButton setTitle:[NSString stringWithFormat:@"玩法选择：%@",self.playKindNameList[_selectedPlayKindIndex]] forState:UIControlStateNormal];
    [CookBook_BuyLotteryManager shareManager].currentPlayKindDes = self.playKindNameList[_selectedPlayKindIndex];
}

-(NSArray *)playKindList
{
    if (!_playKindList) {
     
        _playKindList = [_playInfo DWArrayForKey:@"playList"];
        
    }
    return _playKindList;
}

-(NSArray *)playKindNameList
{
    if (!_playKindNameList) {
        NSMutableArray *mArray = [NSMutableArray new];
        for (int i=0; i<self.playKindList.count; i++) {
            NSDictionary *info = self.playKindList[i];
            [mArray addObject:[info DWStringForKey:@"playName"]];
        }
        _playKindNameList = mArray;
    }
    return _playKindNameList;
}

-(NSDictionary *)betNameDic
{
    if (!_betNameDic) {
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        NSDictionary *seName = [_playInfo DWDictionaryForKey:@"sxNames"];
        for (NSString *key in seName.allKeys) {
            NSString *value = [seName objectForKey:key];
            if ([value rangeOfString:@","].length>0) {
                NSArray *numbers = [value componentsSeparatedByString:@","];
                for (NSString *number in numbers) {
                    [mDic setObject:key forKey:[NSNumber numberWithInteger:[number integerValue]]];
                }
            }
        }
        _betNameDic = mDic;
    }
    return _betNameDic;
}


#pragma mark- scrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark- action

-(void)showSortViewAction
{
    _sortView.hidden = _sortView.hidden?NO:YES;

}

- (IBAction)bottomButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    switch (sender.tag) {
        case 11:
        {
            //清空选项
            [self reloadContentView];
            _betResultDic = [NSMutableDictionary new];
        }break;
        case 22:
        {
            //趋势
            NSString *resultTypeString = [_playInfo DWStringForKey:@"type"];
            CPLotteryResultType resultType = CPLotteryResultTypeByTypeString(resultTypeString);
            if (resultType == CPLotteryResultForXGLHC || resultType == CPLotteryResultForPCDD) {
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSString *gid = [_playInfo DWStringForKey:@"num"];
                [app.maiTabBarController cookBook_goToDetailResultViewControllerWithGid:gid];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSString *gid = [_playInfo DWStringForKey:@"num"];
                [app.maiTabBarController cookBook_goToTrendViewControllerWithGid:gid];
            }
            
        }break;
        case 33:
        {
            //投注
            if (![CookBook_User shareUser].isLogin) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForPushToLoginViewController object:nil];
                return ;
            }
            
            NSDictionary *playKindInfo = _playKindList[_selectedPlayKindIndex];
            NSString *playKindName = [playKindInfo DWStringForKey:@"playName"];
            if ([playKindName isEqualToString:@"合肖"]) {
                if (self.heXiaoBetLotteryInfos.count<=1) {
                    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"下注内容有误请检查！"];
                    return;
                }
                NSMutableDictionary *betInfo = [NSMutableDictionary new];
                NSMutableString *title = [[NSMutableString alloc]initWithString:@"合肖:"];
                for (CookBook_BuyLotteryFastItem *item in self.heXiaoBetLotteryInfos) {
                    [title appendFormat:@"%@&",[item.buyInfo DWStringForKey:@"playName"]];
                }
                [betInfo setObject:[title substringToIndex:title.length-1] forKey:@"playName"];
                [betInfo setObject:self.heXiaoBetBonus forKey:@"bonus"];
                NSString *playName = [title substringFromIndex:3];
                playName = [playName substringToIndex:playName.length-1];
                
                [CookBook_BuyLotteryManager shareManager].currentBetPeriod = [self.playInfo DWStringForKey:@"period"];
                [CookBook_BuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:@[betInfo] numberPeriods:[CookBook_BuyLotteryManager shareManager].currentBetPeriod specailType:1 comfirm:^(BOOL isConfirm, NSString *value) {
                    if (isConfirm) {
                        
                        NSString *betString = [NSString stringWithFormat:@"%@|%@|%@;",playName,self.heXiaoPlayId,value];
                        [self queryBetWithBetList:betString];
                    }
                }];
                return;
            }else if ([playKindName isEqualToString:@"自选不中"]){
                
                CookBook_BuyLetterLotterySectionView *sectionView = _sectionViews[0];
                NSArray *resultLetters = [NSArray new];
                NSString *sectionName;
                if ([sectionView isSelectedResult:&resultLetters sectionName:&sectionName]) {
                    if (resultLetters.count>=6) {
                     
                        NSArray *playDetailList = [_playInfo DWArrayForKey:@"playDetailList"];
                        NSDictionary *info = playDetailList[0];
                        NSArray *list = [info DWArrayForKey:@"list"];
                        NSInteger index = resultLetters.count-6;
                        if (list.count>index) {
                            NSDictionary *originBetInfo = list[index];
                            self.ziXuanBetInfo = originBetInfo;
                            NSString *originPlayName = [originBetInfo DWStringForKey:@"playName"];
                            NSMutableDictionary *betInfo = [NSMutableDictionary new];
                            NSMutableString *title = [[NSMutableString alloc]initWithFormat:@"%@:",originPlayName];
                            for (NSString *letter in resultLetters) {
                                [title appendFormat:@"%@&",letter];
                            }
                            [betInfo setObject:[title substringToIndex:title.length-1] forKey:@"playName"];
                            [betInfo setObject:[originBetInfo DWStringForKey:@"bonus"] forKey:@"bonus"];
                            NSString *playName = [title substringFromIndex:[NSString stringWithFormat:@"%@:",originPlayName].length];
                            playName = [playName substringToIndex:playName.length-1];
                            [CookBook_BuyLotteryManager shareManager].currentBetPeriod = [self.playInfo DWStringForKey:@"period"];
                            [CookBook_BuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:@[betInfo] numberPeriods:[CookBook_BuyLotteryManager shareManager].currentBetPeriod specailType:1 comfirm:^(BOOL isConfirm, NSString *value) {
                                if (isConfirm) {
                                    
                                    NSString *betString = [NSString stringWithFormat:@"%@|%@|%@;",playName,[self.ziXuanBetInfo DWStringForKey:@"playId"],value];
                                    [self queryBetWithBetList:betString];
                                }
                            }];

                        }
                        return;
                    }
                    
                    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"下注内容有误请检查！"];
                    
                }
                
                return;
            }else if ([playKindName isEqualToString:@"连码"]){
                
                BOOL isBet;
                NSString *errorMsg = [NSString new];
                if ([self checkLianMaVerifyAndIsBet:&isBet errorMsg:&errorMsg]) {
                    if (isBet) {
                        if (self.lianMaBetInfos.count>0) {
                            [CookBook_BuyLotteryManager shareManager].currentBetPeriod = [self.playInfo DWStringForKey:@"period"];
                            [CookBook_BuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:self.lianMaBetInfos numberPeriods:[CookBook_BuyLotteryManager shareManager].currentBetPeriod specailType:2 comfirm:^(BOOL isConfirm, NSString *value) {
                                if (isConfirm) {
                                    
                                    NSMutableString *betList = [NSMutableString new];
                                    for (NSDictionary *info in self.lianMaBetInfos) {
                                        NSString *playName = [info DWStringForKey:@"playNameValue"];
                                        NSString *playId = [info DWStringForKey:@"playId"];
                                        
                                        NSString *betString = [NSString stringWithFormat:@"%@|%@|%@;",playName,playId,value];
                                        [betList appendString:betString];
                                        
                                    }
                                    [self queryBetWithBetList:betList];
                                }
                            }];

                        }
                    }
                }else{
                    if (isBet && errorMsg.length>0) {
                        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:errorMsg];
                    }
                }
                
                if (!isBet && self.lianMaBetInfos.count == 0) {
                    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请选择下注的内容"];
                }
                return;
            }else if ([playKindName isEqualToString:@"连肖连尾"]){
                
                
                BOOL isBet;
                NSString *errorMsg = [NSString new];
                if ([self checkLianXiaoWeiVerifyAndIsBet:&isBet errorMsg:&errorMsg]) {
                    if (isBet) {
                        if (self.lianXiaoWeiBetInfos.count>0) {
                            [CookBook_BuyLotteryManager shareManager].currentBetPeriod = [self.playInfo DWStringForKey:@"period"];
                            [CookBook_BuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:self.lianXiaoWeiBetInfos numberPeriods:[CookBook_BuyLotteryManager shareManager].currentBetPeriod specailType:2 comfirm:^(BOOL isConfirm, NSString *value) {
                                if (isConfirm) {
                                    
                                    NSMutableString *betList = [NSMutableString new];
                                    for (NSDictionary *info in self.lianXiaoWeiBetInfos) {
                                        NSString *playName = [info DWStringForKey:@"playNameValue"];
                                        NSString *playId = [info DWStringForKey:@"playId"];
                                        
                                        NSString *betString = [NSString stringWithFormat:@"%@|%@|%@;",playName,playId,value];
                                        [betList appendString:betString];
                                        
                                    }
                                    [self queryBetWithBetList:betList];
                                }
                            }];
                            
                        }
                    }
                }else{
                    if (isBet && errorMsg.length>0) {
                        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:errorMsg];
                    }
                }
                
                if (!isBet && self.lianMaBetInfos.count == 0) {
                    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请选择下注的内容"];
                }
                return;
            }
            
            if (_betResultDic.allKeys.count == 0) {
                [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请选择下注的内容"];
                return;
            }
            
            
            
            if (self.betType == CPBuyLotteryBetFast) {
                
                [CookBook_BuyLotteryManager shareManager].currentBetPeriod = [self.playInfo DWStringForKey:@"period"];
                [CookBook_BuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:_betResultDic.allValues numberPeriods:[CookBook_BuyLotteryManager shareManager].currentBetPeriod comfirm:^(BOOL isConfirm, NSString *value) {
                    if (isConfirm) {
                        
                        NSMutableString *betList = [NSMutableString new];
                        for (NSDictionary *info in _betResultDic.allValues) {
                            NSString *playName = [info DWStringForKey:@"playName"];
                            NSString *playId = [info DWStringForKey:@"playId"];
                            
                            NSString *betString = [NSString stringWithFormat:@"%@|%@|%@;",playName,playId,value];
                            [betList appendString:betString];
                            
                        }
                        [self queryBetWithBetList:betList];
                    }
                }];
                
            }else{
                [CookBook_BuyLotteryManager shareManager].currentBetPeriod = [self.playInfo DWStringForKey:@"period"];
                [CookBook_BuyCustomLotteryConfirmView cookBook_showCustomLotteryConfirmViewOnView:self.navigationController.view lotterys:_betResultDic.allValues numberPeriods:[CookBook_BuyLotteryManager shareManager].currentBetPeriod comfirm:^(BOOL isConfirm) {
                   
                    if (isConfirm) {
                        NSMutableString *betList = [NSMutableString new];
                        for (NSDictionary *info in _betResultDic.allValues) {
                            NSString *playName = [info DWStringForKey:@"playName"];
                            NSString *playId = [info DWStringForKey:@"playId"];
                            NSString *betValue = [info DWStringForKey:@"betValue"];
                            NSString *betString = [NSString stringWithFormat:@"%@|%@|%@;",playName,playId,betValue];
                            [betList appendString:betString];
                            
                        }
                        [self queryBetWithBetList:betList];
                    }
                }];
            }
            NSLog(@"%@",_betResultDic);
            
        }break;
            
        default:
            break;
    }
}

- (IBAction)reloadBalanceAction:(UIButton *)sender {
    [self queryBalanceInfo];
}

- (IBAction)_titleButtonAction:(UIButton *)sender {
    
    NSInteger tag = 909;
    CPSelectedOptionsView *originOptionView = [self.view viewWithTag:tag];
    if (originOptionView) {
        [originOptionView dismiss];
        return;
    }
    
    CPSelectedOptionsView *optionView = [CPSelectedOptionsView showWithOnView:self.view
                                  options:self.playKindNameList
                            selectedIndex:_selectedPlayKindIndex
                             clearBgColor:YES
                                 selected:^(NSInteger index) {
        
        if (index != self.selectedPlayKindIndex) {
            self.selectedPlayKindIndex = index;
            _betResultDic = [NSMutableDictionary new];

            NSDictionary *playKindInfo = _playKindList[_selectedPlayKindIndex];
            NSString *playKindName = [playKindInfo DWStringForKey:@"playName"];
            if ([playKindName isEqualToString:@"连肖连尾"]){
                [self reloadLianXiaoWeiBetTypeView];
                _lianXiaoWeiSortBetTypeView.hidden = NO;
            }else{
                _lianXiaoWeiSortBetTypeView.hidden = YES;
            }
            self.heXiaoBetLotteryInfos = [NSArray new];
            self.heXiaoBetBonus = @"";
            if (self.lotteryType == CPBuyLotteryTypeSpecailOne) {
                
                if (!_specailOneFirstPlayInfo) {
                    _specailOneQueryKindIndex = 0;
                    NSDictionary *playKindInfo = _playKindList[_specailOneQueryKindIndex];
                    [self queryBuyLotteryIsOnlyReloadTopView:NO palyKindInfo:playKindInfo];

                }else if (!_specailOneSecondPlayInfo){
                    _specailOneQueryKindIndex = 1;
                    NSDictionary *playKindInfo = _playKindList[_specailOneQueryKindIndex];
                    [self queryBuyLotteryIsOnlyReloadTopView:NO palyKindInfo:playKindInfo];
                    
                }else{
                    
                    if (self.selectedPlayKindIndex == 0) {
                        self.playInfo = [[NSDictionary alloc]initWithDictionary:_specailOneFirstPlayInfo];
                    }else if (self.selectedPlayKindIndex == 1){
                        self.playInfo = [[NSDictionary alloc]initWithDictionary:_specailOneSecondPlayInfo];
                    }
                    [self reloadContentView];
                }
                
            }else{
                
                [self queryBuyLotteryIsOnlyReloadTopView:NO palyKindInfo:nil];
            }
            
        }
    }];
    
    optionView.tag = tag;
}

- (IBAction)betTypeAction:(UIButton *)sender {
    if (sender == _markBetButton) {
        return;
    }
    if (_markBetButton) {
        _markBetButton.selected = NO;
    }
    _markBetButton = sender;
    _markBetButton.selected = YES;
    [UIView animateWithDuration:0.38 animations:^{
        _betTypeMarkLabel.originX = _markBetButton.originX;
    }];
    if (sender.tag == 11) {
        //自选下注
        _betType = CPBuyLotteryBetCustom;
    }else{
        //快捷下注
        _betType = CPBuyLotteryBetFast;
    }
    [self reloadContentView];
    _betResultDic = [NSMutableDictionary new];
}

- (IBAction)lianXiaoLianWeiBetTypeAction:(UIButton *)sender {
    
    BOOL isReloadContent = NO;
    CGFloat originX = 0;
    if (sender == _lianXiaoBetButton) {
        
        if (_lianWeiBetButton.isSelected) {
            _lianWeiBetButton.selected = NO;
        }
        if (_lianXiaoBetButton.isSelected == NO) {
            _lianXiaoBetButton.selected = YES;
            originX = _lianXiaoBetButton.originX;
            isReloadContent = YES;

        }
        
    }else if (sender == _lianWeiBetButton){
        
        if (_lianXiaoBetButton.isSelected) {
            _lianXiaoBetButton.selected = NO;
        }
        if (_lianWeiBetButton.isSelected == NO) {
            _lianWeiBetButton.selected = YES;
            originX = _lianWeiBetButton.originX;
            isReloadContent = YES;

        }
    }
    
    if (isReloadContent) {
        [self reloadContentView];
        if (originX != _lianXiaoWeiBetTypeMarkLabel.originX) {
            [UIView animateWithDuration:0.38 animations:^{
                _lianXiaoWeiBetTypeMarkLabel.originX = originX;
            }];
        }
    }
    
}



- (IBAction)sortAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            //首页
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.maiTabBarController cookBook_goToHomepageViewController];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }break;
        case 102:
        {
            //投注记录
            if (![CookBook_User shareUser].isLogin) {
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.maiTabBarController cookBook_goToLoginViewController];
            }else{
                CPBetRecordVC *vc = [CPBetRecordVC new];
                vc.onlyShowWinRecord = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }break;
        case 103:
        {
            //最新开奖
            NSString *gid = [_playInfo DWStringForKey:@"num"];
            NSString *urlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent: [NSString stringWithFormat:@"/api/draw/single?gid=%@",gid]];
            CookBook_LotteryResultDetailWebVC *vc = [[CookBook_LotteryResultDetailWebVC alloc]init];
            vc.urlString = urlString;
            vc.dayType = 99;
            [self.navigationController pushViewController:vc animated:YES];
            
            /*
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *gid = [_playInfo DWStringForKey:@"num"];
            [app.maiTabBarController goToDetailResultViewControllerWithGid:gid];
            [self.navigationController popToRootViewControllerAnimated:YES];
             */

        }break;
        case 104:
        {
            //玩法说明
            NSString *gid = [_playInfo DWStringForKey:@"num"];
            NSString *urlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[NSString stringWithFormat:@"/api/help?gid=%@",gid]];
            CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:urlString];
            toWebVC.title = @"玩法说明";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            toWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];
            
        }break;
            
        default:
            break;
    }
    if (_sortView.hidden == NO) {
        _sortView.hidden = YES;
    }
}

#pragma mark- 特殊处理

-(BOOL)isSpecailTypeOneContainPlayKindResultPlayInfo:(NSDictionary **)playInfo
{
    BOOL isContain = NO;
    NSDictionary *playKindInfo = _playKindList[_selectedPlayKindIndex];
    NSString *playKindName = [playKindInfo DWStringForKey:@"playName"];
    NSDictionary *firstPlayInfo = nil;
    NSDictionary *secondPlayInfo = nil;

    if (_specailOneFirstPlayInfo) {
        NSArray *playDetailList = [_specailOneFirstPlayInfo DWArrayForKey:@"playDetailList"];
        firstPlayInfo = [self sortPlayInfoWithPlayKindName:playKindName playDetailList:playDetailList];
    }
    
    if (_specailOneSecondPlayInfo) {
        NSArray *playDetailList = [_specailOneSecondPlayInfo DWArrayForKey:@"playDetailList"];
        secondPlayInfo = [self sortPlayInfoWithPlayKindName:playKindName playDetailList:playDetailList];
    }
    NSMutableArray *mList = [NSMutableArray new];
    if (firstPlayInfo) {
        NSArray *list = [firstPlayInfo DWArrayForKey:@"list"];
        if (list.count>0) {
            [mList addObjectsFromArray:list];
        }
    }
    
    if (secondPlayInfo) {
        NSArray *list = [secondPlayInfo DWArrayForKey:@"list"];
        if (list.count>0) {
            [mList addObjectsFromArray:list];
        }
    }
    
    if (mList.count>0) {
        isContain = YES;
        NSMutableDictionary *allPlayInfo = [NSMutableDictionary new];
        [allPlayInfo setObject:mList forKey:@"list"];
        [allPlayInfo setObject:playKindName forKey:@"name"];
        if (*playInfo) {
            *playInfo = allPlayInfo;
        }
    }
    
    return isContain;
}

-(NSDictionary *)sortPlayInfoWithPlayKindName:(NSString *)playKindName
                               playDetailList:(NSArray *)playDetailList
{
    NSDictionary *playInfo = nil;
    for (int i = 0; i<playDetailList.count; i++) {
        NSDictionary *info = playDetailList[i];
        if ([[info DWStringForKey:@"name"] isEqualToString:playKindName]) {
            playInfo = info;
            break;
        }
    }

    return playInfo;
}



#pragma mark- reload

-(void)reloadLianXiaoWeiBetTypeView
{
    _lianXiaoWeiBetTypeMarkLabel.originX = _lianXiaoBetButton.originX;
    _lianXiaoBetButton.selected = YES;
    _lianWeiBetButton.selected = NO;
}

-(void)reloadBeiJingTime
{
//    _openTimeDistance
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        
        NSDate *beijingDate = [self getInternetDate];
        if (beijingDate) {
            NSDate *nowDate = [NSDate date];
            NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
            NSTimeInterval beiJingTimeInterval = [beijingDate timeIntervalSince1970];
            _beijingTiemDistance =nowTimeInterval - beiJingTimeInterval;
        }

    });
}

-(void)reloadOpenDate
{
    NSTimeInterval distance = [[_playInfo DWStringForKey:@"endTime"]doubleValue]/1000 -([[NSDate date] timeIntervalSince1970]-_beijingTiemDistance);
    NSTimeInterval our = distance/(60*60);
    NSInteger intOur = our;
    NSTimeInterval min = (distance - intOur*60*60)/60;
    NSInteger intMin = min;
    NSTimeInterval second = distance - intOur*60*60 - intMin*60;
    NSInteger intSecond = second;
    
    NSString *ourString = intOur>9?[NSString stringWithFormat:@"%ld",intOur]:[NSString stringWithFormat:@"0%ld",intOur];
    NSString *minString = intMin>9?[NSString stringWithFormat:@"%ld",intMin]:[NSString stringWithFormat:@"0%ld",intMin];
    NSString *secondString = intSecond>9?[NSString stringWithFormat:@"%ld",intSecond]:[NSString stringWithFormat:@"0%ld",intSecond];
    
    if (intOur<=0 && intMin<=0 && intSecond<=0) {
        _countDateLabel.text = @"00:00:00";
        @synchronized (self) {
            if (_isQueryInfoIng == NO) {
                _isQueryInfoIng = YES;
                [self queryBuyLotteryIsOnlyReloadTopView:YES palyKindInfo:nil];
            }
        }
            }else{
        _countDateLabel.text = [NSString stringWithFormat:@"%@:%@:%@",ourString,minString,secondString];
    }

}


-(void)reloadBalanceLabel
{
    if ([CookBook_User shareUser].isLogin) {
        _balanceView.hidden = NO;
        NSString *text = [NSString stringWithFormat:@"余额:￥%.2f",[_balance floatValue]];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
        [att addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[text rangeOfString:@"余额:"]];
        _balanceLabel.attributedText = att;
    }else{
        _balanceView.hidden = YES;
    }
}

-(void)reloadTopViewData
{
    
    [self reloadBalanceLabel];
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@期",self.lotteryName,[self.playInfo DWStringForKey:@"roomName"],[self.playInfo DWStringForKey:@"period"]];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [att addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[title rangeOfString:[self.playInfo DWStringForKey:@"period"]]];
    _titleLabel.attributedText = att;
    
    _openDateLabel.text =[NSString stringWithFormat:@"开奖时间：%@",[self.playInfo DWStringForKey:@"opentime"]];

    _numberLabel.text =[NSString stringWithFormat:@"%@期",[self.playInfo DWStringForKey:@"lastPeriod"]];
    
    
    for (UIView *subView in _topView.subviews) {
        if (subView.tag == 996) {
            [subView removeFromSuperview];
        }
    }
    
    BOOL isNeedReloadContentView = NO;
    
    NSString *lastOpen = [self.playInfo DWStringForKey:@"lastOpen"];
    NSString *resultType = [self.playInfo DWStringForKey:@"type"];
    NSArray *result = [lastOpen componentsSeparatedByString:@","];
    if (_resultView.superview) {
        [_resultView removeFromSuperview];
    }
    _resultView = [[CookBook_LotteryShowResultView alloc]initWithFrame:CGRectMake(5, 30, kScreenWidth - 2*5, 0)];
    CGFloat resultViewHeight = [CookBook_LotteryShowResultView resultViewHeightByResult:result resultType:CPLotteryResultTypeByTypeString(resultType) isWaitOpenResult:lastOpen.length==0?YES:NO maxWidth:_resultView.width isList:NO];
    _resultView.height = resultViewHeight;
    _topCenterView.height = _resultView.bottomY + 5.0f;
    [_resultView showResult:result resultType:CPLotteryResultTypeByTypeString(resultType) isWaitOpen:lastOpen.length==0?YES:NO];
    [_topCenterView addSubview:_resultView];
    
    NSDictionary *playKindInfo = _playKindList[_selectedPlayKindIndex];
    NSString *playKindName = [playKindInfo DWStringForKey:@"playName"];
    
    CGFloat topViewHeight = 55+40+_topCenterView.height;

    if([playKindName isEqualToString:@"合肖"] || [playKindName isEqualToString:@"自选不中"] ||[playKindName isEqualToString:@"连码"] ){
        topViewHeight = 55+_topCenterView.height;
    }
    
    if (topViewHeight!=topViewHeight) {
        isNeedReloadContentView = YES;
    }
    _topView.height = topViewHeight;
    [_topView layoutSubviews];
    
    if (isNeedReloadContentView) {
        [self reloadContentView];
    }
}

-(void)reloadContentView
{
    @synchronized (self) {
        
        for (UIView *subView in _scrollView.subviews) {
            if ([subView isKindOfClass:[CookBook_BuyLotterySectionView class]] || [subView isKindOfClass:[CookBook_BuyLetterLotterySectionView class]]) {
                [subView removeFromSuperview];
            }
        }
        
        _sortBetTypeView.hidden = NO;
        
        NSInteger specailType = 0;
        
        _sectionViews = [NSMutableArray new];
        NSArray *playDetailList = [self.playInfo DWArrayForKey:@"playDetailList"];
        NSDictionary *sortPlayInfo = [NSDictionary new];
        if (self.lotteryType == CPBuyLotteryTypeSpecailOne &&[self isSpecailTypeOneContainPlayKindResultPlayInfo:&sortPlayInfo]) {
            if (sortPlayInfo.allKeys.count>0) {
                playDetailList = @[sortPlayInfo];
            }
        }else if (self.lotteryType == CPBuyLotteryTypeSpecailTwo){
            NSDictionary *playKindInfo = _playKindList[_selectedPlayKindIndex];
            NSString *playKindName = [playKindInfo DWStringForKey:@"playName"];
            NSMutableArray *mPlayDetailList = [[NSMutableArray alloc]initWithArray:playDetailList];
            if ([playKindName isEqualToString:@"特码B"]) {
                if (mPlayDetailList.count>0) {
                    NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithDictionary:playDetailList[0]];
                    NSArray *list = [info DWArrayForKey:@"list"];
                    if (list.count>=49) {
                        NSArray *subList = [list subarrayWithRange:NSMakeRange(0, 49)];
                        [info setObject:subList forKey:@"list"];
                        [mPlayDetailList removeObjectAtIndex:0];
                        [mPlayDetailList insertObject:info atIndex:0];
                        playDetailList = mPlayDetailList;
                    }
                    
                }
            }else if([playKindName isEqualToString:@"合肖"]){
                _sortBetTypeView.hidden = YES;
                playDetailList = @[self.heXiaoLotteryInfo];
                specailType = 3;
            }else if([playKindName isEqualToString:@"自选不中"]){
//                _sortBetTypeView
                _sortBetTypeView.hidden = YES;
                CookBook_BuyLetterLotterySectionView *sectionView = [[CookBook_BuyLetterLotterySectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) selectMaxCount:11 sectionName:@"自选不中" delegate:self];
                [_scrollView addSubview:sectionView];
                [_sectionViews addObject:sectionView];
                [self reloadSectionViewFrameIsAnimation:NO];
                return;
            }else if([playKindName isEqualToString:@"连码"]){
//                lianMaLotteryInfos
                _sortBetTypeView.hidden = YES;
                UIView *lastView =_topView;
                for (int i = 0; i<self.lianMaLotteryInfos.count; i++) {
                    NSDictionary *info = self.lianMaLotteryInfos[i];
                    NSString *bonus = [info DWStringForKey:@"bonus"];
                    NSString *bonus2 = [info DWStringForKey:@"bonus2"];
                    NSString *name = [info DWStringForKey:@"playName"];
                    if (bonus2.length>0) {
                        name = [NSString stringWithFormat:@"%@ %.1f/%.1f",[info DWStringForKey:@"playName"],[bonus2 floatValue],[bonus floatValue]];
                    }else{
                        name = [NSString stringWithFormat:@"%@ %.1f",[info DWStringForKey:@"playName"],[bonus floatValue]];
                    }
                    NSInteger maxCount = [[info DWStringForKey:@"maxCount"]integerValue];
                    NSInteger minCount = [[info DWStringForKey:@"minCount"]integerValue];

                    CookBook_BuyLetterLotterySectionView *sectionView = [[CookBook_BuyLetterLotterySectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) selectMaxCount:maxCount selectMinCount:minCount sectionName:name delegate:self];
                    sectionView.lotteryInfo = info;
                    [_scrollView addSubview:sectionView];
                    lastView = sectionView;
                    [_sectionViews addObject:sectionView];
                }
                
                [self reloadSectionViewFrameIsAnimation:NO];
                return;

            }else if ([playKindName isEqualToString:@"连肖连尾"]){
                
                _sortBetTypeView.hidden = YES;
//                _topView.height = 160.0f-_sortBetTypeView.height;
                NSMutableArray *mPlayDetailList =[NSMutableArray new];
                NSString *typeText = _lianXiaoBetButton.isSelected?@"连肖":@"连尾";
                for (int i = 0; i<playDetailList.count; i++) {
                    NSDictionary *info = playDetailList[i];
                    NSString *name = [info DWStringForKey:@"name"];
                    if ([name rangeOfString:typeText].length>0) {
                        [mPlayDetailList addObject:info];
                    }
                }
                UIView *lastView =_topView;
                for (int i = 0; i<mPlayDetailList.count; i++) {
                    NSDictionary *info = mPlayDetailList[i];
                    
                    CookBook_BuyLotterySectionView *sectionView = [[CookBook_BuyLotterySectionView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 0) buySectionInfo:info betType:CPBuyLotteryBetForLianXiaoWei delegate:self];
                    [_scrollView addSubview:sectionView];
                    lastView = sectionView;
                    [_sectionViews addObject:sectionView];
                }
                
                [self reloadSectionViewFrameIsAnimation:NO];
                return;
            }
            
            if (([playKindName rangeOfString:@"特码"].length>0 || [playKindName isEqualToString:@"正码"] || ([playKindName rangeOfString:@"正"].length>0&&[playKindName rangeOfString:@"特"].length>0))&& _betType == CPBuyLotteryBetCustom){
                
                for (int i = 0; i<playDetailList.count; i++) {
                    NSDictionary *info = playDetailList[i];
                    
                    CookBook_BuyLotterySectionView *sectionView = [[CookBook_BuyLotterySectionView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 0) buySectionInfo:info betType:CPBuyLotteryBetForLHCHorizontalViewStyle delegate:self];
                    [_scrollView addSubview:sectionView];
                    [_sectionViews addObject:sectionView];
                }
                
                [self reloadSectionViewFrameIsAnimation:NO];
                return;
            }
        }
//        heXiaoLotteryInfo
        [CookBook_User shareUser].buyLotteryDetailHasNumberPan = [self isNumberPan];
        CPBuyLotteryBetType betType = specailType==3?CPBuyLotteryBetForHeXiao:_betType;
        UIView *lastView =_topView;
        for (int i = 0; i<playDetailList.count; i++) {
            NSDictionary *info = playDetailList[i];

            CookBook_BuyLotterySectionView *sectionView = [[CookBook_BuyLotterySectionView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 0) buySectionInfo:info betType:betType delegate:self];
            [_scrollView addSubview:sectionView];
            lastView = sectionView;
            [_sectionViews addObject:sectionView];
        }
        
        [self reloadSectionViewFrameIsAnimation:NO];
    }
}

-(void)reloadSectionViewFrameIsAnimation:(BOOL)animation
{
    UIView *lastView = _topView;
    for (int i= 0; i<_sectionViews.count; i++) {
        UIView *subView =_sectionViews[i];
        if (animation) {
            [UIView animateWithDuration:0.38 animations:^{
                subView.originY = lastView.bottomY;
            }];
        }else{
            subView.originY = lastView.bottomY;
        }
        
        lastView = subView;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, lastView.bottomY);
}

#pragma mark- CPBuyLetterLotterySectionViewDelegate

-(void)cookBook_buyLetterLotteryClickShowDetailAction
{
    [self reloadSectionViewFrameIsAnimation:YES];
}

#pragma mark- CPBuyLotterySectionViewDelegate

-(void)cookBook_buyLotteryBetFastBuyInfo:(NSDictionary *)buyInfo
                    sectionName:(NSString *)sectionName
                          isBuy:(BOOL)isBuy;
{
    NSString *playId = [buyInfo DWStringForKey:@"playId"];
    NSMutableDictionary *oldInfo = [_betResultDic objectForKey:playId];
    if (isBuy) {
        NSMutableDictionary *mInfo = [[NSMutableDictionary alloc]initWithDictionary:buyInfo];
        NSArray *playDetailList = [self.playInfo DWArrayForKey:@"playDetailList"];

        if ([self isNumberPan] || playDetailList.count>1) {
            [mInfo setObject:sectionName forKey:@"sectionName"];
        }
        [_betResultDic setObject:mInfo forKey:playId];
        
    }else if(oldInfo){
        [_betResultDic removeObjectForKey:playId];
    }
}

-(void)cookBook_buyLotteryBetCustomBuyInfo:(NSDictionary *)buyInfo
                      sectionName:(NSString *)sectionName
                            value:(NSString *)value
{
    NSString *playId = [buyInfo DWStringForKey:@"playId"];
    NSMutableDictionary *oldInfo = [_betResultDic objectForKey:playId];
    NSInteger intValue = [value integerValue];
    if (intValue>0) {
        
        NSMutableDictionary *mBuyInfo = [[NSMutableDictionary alloc] initWithDictionary:buyInfo];
        [mBuyInfo setObject:value forKey:@"betValue"];
        NSArray *playDetailList = [self.playInfo DWArrayForKey:@"playDetailList"];

        if ([self isNumberPan]||playDetailList.count>1) {
            [mBuyInfo setObject:sectionName forKey:@"sectionName"];
        }
        [_betResultDic setObject:mBuyInfo forKey:playId];

    }else if(oldInfo){
        [_betResultDic removeObjectForKey:playId];
    }
    
}

-(void)clickShowDetailBuyInfo
{
    [self reloadSectionViewFrameIsAnimation:YES];
}

-(NSDictionary *)betNameDictionary
{
    return self.betNameDic;
}

-(void)cookBook_buyHeXiaoWithInfos:(NSArray *)infos
                    value:(NSString *)value
                   playId:(NSString *)playId
{
    //合肖
    self.heXiaoBetLotteryInfos = infos;
    self.heXiaoBetBonus = value;
    self.heXiaoPlayId = playId;
}

-(NSArray *)cookBook_heXiaoPlayDetailInfoList;
{
    NSArray *playDetailList = [self.playInfo DWArrayForKey:@"playDetailList"];
    NSDictionary *info = playDetailList[0];

    return [info DWArrayForKey:@"list"];
}

#pragma mark-

-(void)queryBuyLotteryIsOnlyReloadTopView:(BOOL)onlyReloadTopView
                             palyKindInfo:(NSDictionary *)playKindInfo
{
    @synchronized (self) {
        
        if (_playInfoRequest) {
            [_playInfoRequest stop];
            _playInfoRequest = nil;
        }
        
        [self reloadBeiJingTime];

        NSString *gid = [_playInfo DWStringForKey:@"num"];
        NSString *roomId = [_playInfo DWStringForKey:@"roomId"];
        
        NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
        [paramsDic setObject:@"2" forKey:@"deviceType"];
        [paramsDic setObject:gid forKey:@"gid"];
        [paramsDic setObject:roomId forKey:@"roomId"];
        
        NSDictionary *playInfo =playKindInfo?playKindInfo:_playKindList[_selectedPlayKindIndex];
        NSString *playId = [playInfo DWStringForKey:@"playId"];
        NSString *playId1 = [playInfo DWStringForKey:@"playId1"];
        if (playId.length>0) {
            [paramsDic setObject:playId forKey:@"playId"];

        }
        if (playId1.length>0) {
                [paramsDic setObject:playId1 forKey:@"playId1"];
        }
        
        NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
        
        _playInfoRequest = [CookBook_Request cookBook_startRequestWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                                         apiName:CookBook_SerVerAPINameForAPIBuy
                                          params:@{@"data":paramsString}
                                    rquestMethod:YTKRequestMethodGET
                      completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
                   if (_scrollView.mj_header.isRefreshing) {
                       [_scrollView.mj_header endRefreshing];
                   }
                   _isQueryInfoIng = NO;
                   self.playInfo = request.businessData;
                   _openDate = nil;
                   if (self.lotteryType == CPBuyLotteryTypeSpecailOne) {
                       if (_specailOneQueryKindIndex == 0) {
                           _specailOneFirstPlayInfo = [[NSDictionary alloc]initWithDictionary:request.businessData];
                       }else if (_specailOneQueryKindIndex == 1){
                           _specailOneSecondPlayInfo = [[NSDictionary alloc]initWithDictionary:request.businessData];
                       }
                   }
                   if (request.resultIsOk) {
                       [self reloadTopViewData];
                       if (!onlyReloadTopView) {
                           
                            [self reloadContentView];
                       }
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:nil];
                   }else{
                       
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   }
                   
               } failure:^(__kindof CookBook_Request *request) {
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   _isQueryInfoIng = NO;

               }];
    }
}


-(void)queryBetWithBetList:(NSString *)betList
{    
    
    @synchronized (self) {
        
        if (_betRequest) {
            [_betRequest stop];
            _betRequest = nil;
        }
        
        NSString *gid = [_playInfo DWStringForKey:@"num"];
        NSString *roomId = [_playInfo DWStringForKey:@"roomId"];
        NSString *issue = [CookBook_BuyLotteryManager shareManager].currentBetPeriod;

        NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
        [paramsDic setObject:@"2" forKey:@"deviceType"];

        [paramsDic setObject:gid forKey:@"gid"];
        [paramsDic setObject:roomId forKey:@"roomId"];
        [paramsDic setObject:issue forKey:@"issue"];
        [paramsDic setObject:betList forKey:@"betList"];

        
        NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
        _betRequest = [CookBook_Request cookBook_startRequestWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                                         apiName:CookBook_SerVerAPINameForAPIBetSubmit
                                          params:@{@"data":paramsString}
                                    rquestMethod:YTKRequestMethodGET
                      completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
              
               if (request.resultIsOk) {
                   [self queryBalanceInfo];
                   [self reloadContentView];
                   _betResultDic = [NSMutableDictionary new];
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:@"投注成功"];
               }else{
                   

                   if ([request.requestDescription rangeOfString:@"余额不足"].length>0 && ![CookBook_User shareUser].isTryPlay) {
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:@""];
                       UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"余额不足，请先充值" preferredStyle:UIAlertControllerStyleAlert];
                       
                       [alerVC addAction:[UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                           CPRechargeMainViewController *vc = [CPRechargeMainViewController new];
                           vc.hidesBottomBarWhenPushed = YES;
                           [self.navigationController pushViewController:vc animated:YES];
                       }]];
                       
                       [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                       
                       [self presentViewController:alerVC animated:YES completion:^{
                           
                       }];
                       
                   }else{
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   }
               }
                _betRequest = nil;

           } failure:^(__kindof CookBook_Request *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
               _betRequest = nil;

           }];
    }
}

-(void)queryBalanceInfo
{
    if (![CookBook_User shareUser].isLogin) {
        return;
    }
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"0"}];
    
    [paramsDic setObject:[CookBook_User shareUser].token forKey:@"token"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserAmount
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _balance = [dataInfo DWStringForKey:@"balance"];
                   [self reloadBalanceLabel];
               }
           } failure:^(__kindof CookBook_Request *request) {
               
           }];
}

- (NSDate *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 10];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [dMatter dateFromString:date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
}


@end
