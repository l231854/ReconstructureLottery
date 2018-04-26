//
//  DDChooseShopSizeView.m
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "CPSelectedOptionsAgoView.h"
#import "CPSelectedOptionsAgoCell.h"

#define kReusedCellMark @"kReusedCellMark"
#define kTopViewHeight      28.0f
#define kBottomViewHeight   58.0f

@interface CPSelectedOptionsAgoView ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UIButton *_btnOpcity;
    IBOutlet UIView *_viewTop;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_viewBottom;
    IBOutlet UILabel *_titleLabel;
}

@property(nonatomic,copy)CPSelectedOptionsAgoBlock selected;
@property(nonatomic,retain)NSArray<NSString *>*options;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,copy)NSString *title;

@end

@implementation CPSelectedOptionsAgoView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    self.layer.opacity = 0;
    UINib * nib = [UINib nibWithNibName:@"CPSelectedOptionsCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:kReusedCellMark];
    
}

+(void)showWithOnView:(UIView *)superView
                title:(NSString *)title
              options:(NSArray<NSString *> *)options
        selectedIndex:(NSInteger)selectedIndex
             selected:(CPSelectedOptionsAgoBlock)selected
{
    CPSelectedOptionsAgoView *optionsView = [CPSelectedOptionsAgoView createViewFromNib];
    optionsView.frame = CGRectMake(0, 0, superView.width, superView.height);
    optionsView.options = options;
    optionsView.selectedIndex = selectedIndex;
    optionsView.selected = selected;
    optionsView.title = title;
    [optionsView showOnView:superView];
    
}

-(void)prepareShow
{
    
    _titleLabel.text = self.title;
    
    CGFloat contentHeight = kTopViewHeight + kBottomViewHeight + 44 * self.options.count;
    contentHeight = contentHeight>=self.height * 0.7 ? self.height * 0.7 : contentHeight;
    _tableView.height = contentHeight - kTopViewHeight - kBottomViewHeight;
    _tableView.originY = _viewBottom.originY - _tableView.height;
    _viewTop.originY = _tableView.originY - _viewTop.height;
    _btnOpcity.height = _viewTop.originY;
    
    [_tableView reloadData];

}

-(void)showOnView:(UIView *)onView
{
    [self prepareShow];
    [onView addSubview:self];
    [self show];
}

//-(void)showWithShopSizes:(NSArray *)shopSizes
//                selected:(DDChooseShopSizeBlock)selected
//{

//}

#pragma mark-

-(void)show
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 1;
    }];

}

-(void)dismiss
{
    
    [UIView animateWithDuration:0.38 animations:^{
        
        self.layer.opacity = 0;
        
    }completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSelectedOptionsAgoCell * cell = [tableView dequeueReusableCellWithIdentifier:kReusedCellMark];
    BOOL isShowLine = (self.options.count == indexPath.row+1)? NO:YES;
    BOOL isSelected = indexPath.row == self.selectedIndex;
    [cell addContentText:self.options[indexPath.row] isShowLine:isShowLine isSeleted:isSelected];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self confirmAction];
}

#pragma mark- actions

- (IBAction)dismissAction:(UIButton *)sender {
    
    [self dismiss];
}

- (void)confirmAction{
    
    if (self.selected) {
        self.selected(self.selectedIndex);
    }
    [self dismiss];
}

@end
