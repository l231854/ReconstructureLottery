//
//  CPWebViewController.h
//  lottery
//
//  Created by wayne on 2017/6/14.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <TOWebViewController/TOWebViewController.h>

#define kTransformSafariWebView @"#_WEBVIEW_#"

@interface CookBook_WebViewController : TOWebViewController

@property(nonatomic,assign)int showHongBaoList;

-(instancetype)cookBook_WebWithURLString:(NSString *)urlString;

@end
