//
//  CPLotteryModel.m
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_LotteryModel.h"

@implementation CookBook_LotteryModel

-(NSString *)fullPicUrlString
{
    if (!_fullPicUrlString) {
        _fullPicUrlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:self.pic];
    }
    return _fullPicUrlString;
}

-(int)mainResultCellStyle
{
    if (!(_mainResultCellStyle>0 && _mainResultCellStyle<=8)) {
        
        NSInteger num = [self.num integerValue];
        if (self.content.length == 0) {
            _mainResultCellStyle = 8;
        }else if (num == 51 || num == 5 ||num == 4 ||num == 7 ||num == 12 ||num == 13 ||num == 14 ||num == 15 ||num == 53) {
            _mainResultCellStyle = 1;
        }else if (num ==9 || num == 34 || num == 52){
            _mainResultCellStyle = 4;
        }else if (num ==41 || num == 42){
            _mainResultCellStyle = 5;
        }else if (num ==18){
            _mainResultCellStyle = 6;
        }else if (num ==27 || num == 28){
            _mainResultCellStyle = 3;
        }else if (num ==3 || num ==1 || num ==2){
            _mainResultCellStyle = 2;
        }else if (num == 11 || num == 10 ||num == 17) {
            _mainResultCellStyle = 7;
        }
    }
    
    return _mainResultCellStyle;
}

-(NSArray *)resultArray
{
    if (!_resultArray) {
        
        _resultArray = [_content componentsSeparatedByString:@","];
    }
    return _resultArray;
}

-(NSString *)noteDes
{
    if (!_noteDes) {
        _noteDes = [NSString stringWithFormat:@"第%@期 %@",self.period,self.openTime];
    }
    return _noteDes;
}


@end
