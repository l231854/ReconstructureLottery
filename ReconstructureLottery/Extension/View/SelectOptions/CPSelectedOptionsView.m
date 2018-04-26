//
//  DDChooseShopSizeView.m
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "CPSelectedOptionsView.h"
#import "CPSelectedOptionsCell.h"
#import "CPSelectedOptionsCollectionCell.h"

#define kReusedCellMark @"kReusedCellMark"

#define kHeightCPSelectedOptionsCell 44.0f


@interface CPSelectedOptionsView ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UIButton *_btnOpcity;
    IBOutlet UITableView *_tableView;
    IBOutlet UICollectionView *_collectionView;
}

@property(nonatomic,copy)CPSelectedOptionsBlock selected;
@property(nonatomic,retain)NSArray<NSString *>*options;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,copy)NSString *title;

@property(nonatomic,assign)BOOL isClearBgColor;

@end

@implementation CPSelectedOptionsView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.opacity = 0;
    UINib * nib = [UINib nibWithNibName:@"CPSelectedOptionsCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:kReusedCellMark];
    
    UINib * colNib = [UINib nibWithNibName:@"CPSelectedOptionsCollectionCell" bundle:nil];
    [_collectionView registerNib:colNib forCellWithReuseIdentifier:kReusedCellMark];
    
}

+(CPSelectedOptionsView *)showWithOnView:(UIView *)superView
                                 options:(NSArray<NSString *> *)options
                           selectedIndex:(NSInteger)selectedIndex
                            clearBgColor:(BOOL)isClearBgColor
                                selected:(CPSelectedOptionsBlock)selected
{
    CPSelectedOptionsView *optionsView = [CPSelectedOptionsView createViewFromNib];
    optionsView.frame = CGRectMake(0, 0, superView.width, superView.height);
    optionsView.options = options;
    optionsView.selectedIndex = selectedIndex;
    optionsView.selected = selected;
    optionsView.isClearBgColor = isClearBgColor;
    [optionsView showOnView:superView];
    return optionsView;
}

+(void)showWithOnView:(UIView *)superView
              options:(NSArray<NSString *> *)options
        selectedIndex:(NSInteger)selectedIndex
             selected:(CPSelectedOptionsBlock)selected
{
    [CPSelectedOptionsView showWithOnView:superView options:options selectedIndex:selectedIndex clearBgColor:NO selected:selected];
    
}

-(BOOL)isUsedTableViewWithSupviewHeight:(CGFloat)supviewHeight
                           optionsCount:(NSInteger)optionsCount
                          contentHeight:(CGFloat *)contentHeight
{
    BOOL used = YES;
    CGFloat tableViewHeight = optionsCount *kHeightCPSelectedOptionsCell;
    if (tableViewHeight>= supviewHeight *0.9) {
        used = NO;
        NSInteger row = optionsCount/4;
        row = optionsCount%4>0?row+1:row;
        CGFloat collectionViewHeight = row *kHeightCPSelectedOptionsCell;
        collectionViewHeight = collectionViewHeight>=supviewHeight?supviewHeight:collectionViewHeight;
        *contentHeight = collectionViewHeight;
    }else{
        *contentHeight = tableViewHeight;
    }
//    CGFloat height
    return used;
}


-(void)prepareShow
{
    CGFloat height;
    if (self.isClearBgColor) {
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }
    if ([self isUsedTableViewWithSupviewHeight:self.height
                                  optionsCount:self.options.count
                                 contentHeight:&height]) {
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
        _tableView.height = height;
        [_tableView reloadData];
    }else{
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
        _collectionView.height = height;
        [_collectionView reloadData];
    }
    
    if (self.isClearBgColor) {
        self.height = height;
    }
    _btnOpcity.frame = CGRectMake(0, height, self.width, self.height - height);
    
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

#pragma mark- collctionDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _options.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPSelectedOptionsCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReusedCellMark forIndexPath:indexPath];
    BOOL isSelected = indexPath.row == self.selectedIndex;
    [cell addText:_options[indexPath.row] isSelected:isSelected];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.width/4.0f, kHeightCPSelectedOptionsCell);
    return size;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self confirmAction];
}

#pragma mark- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSelectedOptionsCell * cell = [tableView dequeueReusableCellWithIdentifier:kReusedCellMark];
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
