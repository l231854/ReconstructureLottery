//
//  CPMultiRowTextScrollView.m
//  lottery
//
//  Created by wayne on 2017/6/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPMultiRowTextScrollView.h"
#import "CPMultiRowTextScrollCell.h"

@interface CPMultiRowTextScrollView()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
    
    BOOL _rescroll;
    
    
}
@end

@implementation CPMultiRowTextScrollView

-(instancetype)initWithFrame:(CGRect)frame
                       style:(UITableViewStyle)style
                   dataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        _dataArray = dataArray;
        _rescroll = NO;
        [self registerNib:[UINib nibWithNibName:@"CPMultiRowTextScrollCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPMultiRowTextScrollCell class])];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startRescroll];
        });
        
        CGFloat height = _dataArray.count>=7?[self cellHeight]*7:[self cellHeight]*_dataArray.count;
        self.height = height;
        
    }
    return self;
}

#pragma mark-

-(CGFloat)cellHeight
{
    return 30.0f;
}

#pragma mark-  rescroll animation

-(void)startRescroll
{
    _rescroll = YES;
    [self rescrollAnimation];
}

-(void)pauseRescroll
{
    _rescroll = NO;
}

-(void)rescrollAnimation
{
    if (_rescroll == NO) {
        return;
    }
    if (self.contentOffset.y+self.height >= self.contentSize.height) {
        self.contentOffset = CGPointMake(0, 0);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self rescrollAnimation];
        });
        
    }else{
        
        CGFloat offsetY;
        if (self.contentSize.height - self.height - self.contentOffset.y <30.0f*2) {
        
            offsetY = self.contentSize.height - self.height;
            
        }else {
            
            offsetY = self.contentOffset.y + 30.0f;
            if (offsetY>=self.contentSize.height - self.height) {
                offsetY =self.contentSize.height - self.height;
            }
        }
        
        [UIView animateWithDuration:0.8 animations:^{
            self.contentOffset = CGPointMake(0, offsetY);
            
        } completion:^(BOOL finished) {
            [self rescrollAnimation];
            
        }];
    }
}

#pragma mark- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMultiRowTextScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPMultiRowTextScrollCell class])];
    NSDictionary *info = _dataArray[indexPath.row];
    [cell addName:[info DWStringForKey:@"User"] amount:[NSString stringWithFormat:@"喜中%@元",[info DWStringForKey:@"WinAmount"]] content:[info DWStringForKey:@"gname"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self cellHeight];
}

@end
