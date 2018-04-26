//
//  CPMyRecommendVC.m
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPMyRecommendVC.h"
#import "CPMyRecommendRecordVC.h"

@interface CPMyRecommendVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *_myRecommendIdLabel;
    IBOutlet UITextView *_myRecommendAddressTv;
    
    IBOutlet UILabel *_monthCollectionLabel;
    
    IBOutlet UILabel *_rateLabel;
    IBOutlet UILabel *_myRecommendMenberLabel;
    
    IBOutlet UIView *_headerView;
    
    IBOutlet UITableView *_tableView;
    
    NSDictionary *_info;
    NSDictionary *_myInfo;
    NSArray *_memberList;
}

@end

@implementation CPMyRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推荐";
    
    CPVoiceButton *finishedButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    finishedButton.frame = CGRectMake(0, 0, 65, 65);
    [finishedButton addTarget:self action:@selector(collectionRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [finishedButton setTitle:@"收益记录" forState:UIControlStateNormal];
    [finishedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishedButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    self.navigationItem.rightBarButtonItems =@[offsetItem ,[[UIBarButtonItem alloc] initWithCustomView:finishedButton]];
    

    
    [self queryMyRecommendInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fillInfo
{
    
    _myInfo = [_info DWDictionaryForKey:@"mySpread"];
    _memberList = [_myInfo DWArrayForKey:@"spreadMember"];
/*
    NSMutableArray *mList = [[NSMutableArray alloc]initWithArray:_memberList];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    [mList addObjectsFromArray:[_myInfo DWArrayForKey:@"spreadMember"]];
    _memberList = mList;
    */

    NSInteger memberId = [[CookBook_User shareUser].tokenInfo.memberId integerValue];
    memberId = memberId+100000;
    _myRecommendIdLabel.text = [NSString stringWithFormat:@"%ld",memberId];
    _myRecommendAddressTv.text = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[NSString stringWithFormat:@"/common/register?tjr=%ld",memberId]];

    _monthCollectionLabel.text = [_myInfo DWStringForKey:@"spreadIn"];
    _rateLabel.text = [NSString stringWithFormat:@"说明：每天的7点更新收益，如3号7点，会计算2号0点-24点之间所有数据，然后增加您的收益。您的收益=推荐会员的有效投注额度总和÷100 x %@(转换率),小数部分四舍五入！",[_info DWStringForKey:@"spread"]];
    
    _myRecommendMenberLabel.text = [NSString stringWithFormat:@"我的推荐会员(%lu)：",(unsigned long)_memberList.count];
    
    
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
}

-(void)collectionRecordAction
{
    CPMyRecommendRecordVC *vc = [[CPMyRecommendRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _memberList.count%3>0?_memberList.count/3+1:_memberList.count/3;
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *markReused = @"markReused";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReused];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:markReused];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = kCOLOR_R_G_B_A(169, 169, 169, 1);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.textColor = [UIColor redColor];
        
        cell.imageView.image = [UIImage imageNamed:@""];

    }

    NSMutableAttributedString * mAtt = [NSMutableAttributedString new];
    NSInteger startIndex = indexPath.row*3;
    for (NSInteger i = startIndex; i<startIndex+3; i++) {
        if (_memberList.count>i) {
            
            NSDictionary *info = _memberList[i];
            NSString *name = [info DWStringForKey:@"code"];
            [mAtt appendAttributedString: [[NSAttributedString alloc]initWithString:name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(169, 169, 169, 1)}]];
            if ([[info DWStringForKey:@"isDanger"]intValue] == 1) {
                [mAtt appendAttributedString: [[NSAttributedString alloc]initWithString:@"(风险)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor redColor]}]];
            }
            [mAtt appendAttributedString: [[NSAttributedString alloc]initWithString:@"  " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}]];

        }
    }
    
    cell.textLabel.attributedText = mAtt;
    return cell;
}

#pragma mark- network

-(void)queryMyRecommendInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserSpread
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   _info = [request.resultInfo DWDictionaryForKey:@"data"];
                   if (_info) {
                       [self fillInfo];
                   }
                   
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               [self.navigationController popViewControllerAnimated:YES];
               
           }];

}

@end
