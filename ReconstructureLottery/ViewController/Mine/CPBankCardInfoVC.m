//
//  CPBankCardInfoVC.m
//  lottery
//
//  Created by wayne on 2017/9/1.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBankCardInfoVC.h"
#import "CPSelectedOptionsAgoView.h"

@interface CPBankCardInfoVC ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet UITextField *_bankNameTf;
    IBOutlet UITextField *_bankCardTf;
    IBOutlet UITextField *_nameTf;
    IBOutlet UITextField *_provinceTf;
    IBOutlet UITextField *_cityTf;
    IBOutlet UITextField *_payPasswordTf;
    
    NSMutableArray *_bankNameList;
    
    IBOutlet UILabel *_payPasswordDesLabel;
    
    
    IBOutlet UIView *_otherBankNameView;
    IBOutlet UITextField *_otherBankNameTf;
    IBOutlet UIView *_contentView;
    
}

@property(nonatomic,assign)NSInteger selectedBankNameIndex;


@end

@implementation CPBankCardInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行";
    
    UIImage *img = [UIImage imageNamed:@"arrow_grey-1"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, img.size.width+10, img.size.height)];
    imgView.frame = CGRectMake(5, 0, img.size.width, img.size.height);
    [leftView addSubview:imgView];
    _bankNameTf.rightView = leftView;
    _bankNameTf.rightViewMode = UITextFieldViewModeAlways;
    /*
     
     */
    _bankNameList = [[NSMutableArray alloc]initWithArray:@[@"中国银行",@"中国建设银行",@"中国工商银行",@"招商银行",@"中国农业银行",@"中国邮政储蓄",@"中国民生银行",@"中信银行",@"中国光大银行",@"兴业银行",@"华夏银行",@"北京银行",@"浦发银行",@"广发银行",@"平安银行",@"其他银行"]];
    [self showOtherBankNameView:NO animated:NO];

    if (_bankInfo) {
        _bankNameTf.text = [_bankInfo DWStringForKey:@"bankName"].length>0?[_bankInfo DWStringForKey:@"bankName"]:nil;
        _bankCardTf.text = [_bankInfo DWStringForKey:@"accountCode"].length>0?[_bankInfo DWStringForKey:@"accountCode"]:nil;
        _nameTf.text = [_bankInfo DWStringForKey:@"accountName"].length>0?[_bankInfo DWStringForKey:@"accountName"]:nil;
        _provinceTf.text = [_bankInfo DWStringForKey:@"provice"].length>0?[_bankInfo DWStringForKey:@"provice"]:nil;
        _cityTf.text = [_bankInfo DWStringForKey:@"city"].length>0?[_bankInfo DWStringForKey:@"city"]:nil;
        if ([[_bankInfo DWStringForKey:@"remark"]isEqualToString:@"other"]) {
            _bankNameTf.text = @"其他银行";
            _otherBankNameTf.text = [_bankInfo DWStringForKey:@"bankName"];
            [self showOtherBankNameView:YES animated:NO];
        }

        if (_nameTf.text.length>0) {
            _nameTf.userInteractionEnabled = NO;
        }
        
        if (_bankNameTf.text.length>0) {
            if (![_bankNameList containsObject:_bankNameTf.text]) {
                [_bankNameList insertObject:_bankNameTf.text atIndex:0];
                self.selectedBankNameIndex = 0;
            }else{
                self.selectedBankNameIndex = [_bankNameList indexOfObject:_bankNameTf.text];
            }
            
        }else{
            self.selectedBankNameIndex = 0;
        }
    }
    
    BOOL isSetPayPassword = [[[_bankInfo DWDictionaryForKey:@"expand"]DWStringForKey:@"isWithdrawPasswdSet"]intValue]==1?YES:NO;
    _payPasswordDesLabel.text = isSetPayPassword?@"校验提款密码:":@"设置提款密码:";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)showOtherBankNameView:(BOOL)isShow
                    animated:(BOOL)animated
{
    if (animated) {
        
        CGFloat opacity = isShow?1:0;
        CGFloat originY = isShow?_otherBankNameView.bottomY:_otherBankNameView.originY;
        [UIView animateWithDuration:0.38 animations:^{
            _otherBankNameView.layer.opacity = opacity;
            _contentView.originY = originY;
        }];
        
    }else{
        if (isShow) {
            _otherBankNameView.layer.opacity = 0;
            _contentView.originY = _otherBankNameView.bottomY;
        }else{
            _otherBankNameView.layer.opacity = 0;
            _contentView.originY = _otherBankNameView.originY;
        }
    }
}

#pragma mark- textfieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _bankNameTf) {
        
        [self selectedBankAction:nil];
        return NO;
    }
    return YES;
}

#pragma mark- settter && getter

-(void)setSelectedBankNameIndex:(NSInteger)selectedBankNameIndex
{
    _selectedBankNameIndex = selectedBankNameIndex;
    _bankNameTf.text = _bankNameList[_selectedBankNameIndex];
    if ([_bankNameTf.text isEqualToString:@"其他银行"]) {
        [self showOtherBankNameView:YES animated:YES];
    }else{
        if (_otherBankNameTf.originY != _contentView.originY) {
            [self showOtherBankNameView:NO animated:YES];
        }
    }
}



#pragma mark-

- (IBAction)selectedBankAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [CPSelectedOptionsAgoView showWithOnView:self.navigationController.view title:@"选择开户行" options:_bankNameList selectedIndex:self.selectedBankNameIndex selected:^(NSInteger index) {
        
        self.selectedBankNameIndex = index;
    }];
}
- (IBAction)confirmAction:(UIButton *)sender {
    
    if (_bankNameTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入开户行" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_bankCardTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入银行卡号" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    if (_nameTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入开户人姓名" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_provinceTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入银行卡开户省份" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_cityTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入银行卡开户城市" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_payPasswordTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入提款密码" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if ([_bankNameTf.text isEqualToString:@"其他银行"] && _otherBankNameTf.text.length == 0){
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入其他银行名称" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }

    [self queryBindBankInfo];
   
}

#pragma mark- network

-(void)queryBindBankInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    [paramsDic setObject:_bankNameTf.text forKey:@"bankName"];
    [paramsDic setObject:_bankCardTf.text forKey:@"bankNum"];
    [paramsDic setObject:_nameTf.text forKey:@"accountName"];
    [paramsDic setObject:_provinceTf.text forKey:@"provice"];
    [paramsDic setObject:_cityTf.text forKey:@"city"];
    
    [paramsDic setObject:_payPasswordTf.text forKey:@"password"];
    
    if ([_bankNameTf.text isEqualToString:@"其他银行"]) {
        [paramsDic setObject:@"other" forKey:@"remark"];
        [paramsDic setObject:_otherBankNameTf.text forKey:@"bankName"];

    }
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISettingBindBank
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = @"保存银行信息成功";
                   [self.navigationController popViewControllerAnimated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
