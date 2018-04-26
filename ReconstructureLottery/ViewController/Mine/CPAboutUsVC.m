//
//  CPAboutUsVC.m
//  lottery
//
//  Created by wayne on 2017/9/1.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPAboutUsVC.h"

@interface CPAboutUsVC ()
{
    IBOutlet UITextView *_textView;
}
@end

@implementation CPAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    _textView.text = self.message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-

@end
