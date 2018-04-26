//
//  CPVoiceButton.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPVoiceButton.h"

@interface CPVoiceButton ()
@end

@implementation CPVoiceButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    
}

@end
