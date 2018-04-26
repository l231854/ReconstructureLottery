//
//  CPRechargeThirdQRCodeVC.m
//  lottery
//
//  Created by wayne on 2017/9/11.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeThirdQRCodeVC.h"
#import "CPRechargeRecordVC.h"

@interface CPRechargeThirdQRCodeVC ()<UIActionSheetDelegate,UIWebViewDelegate>
{
    
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UILabel *_orderLabel;
    IBOutlet UILabel *_amountLabel;
    IBOutlet UIImageView *_qrCodeImageView;
    IBOutlet UILabel *_alertMsgLabel;
    IBOutlet UIWebView *_stepMsgTv;
    
}
@end

@implementation CPRechargeThirdQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.text = self.title.length>0?self.title:@"充值";
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView
    ;
    

    [self cp_AddLongPressShotScreenAction];
    
    _orderLabel.text = [_payInfo DWStringForKey:@"orderNo"];
    _amountLabel.text = [_payInfo DWStringForKey:@"amount"];
    _alertMsgLabel.text = [_payInfo DWStringForKey:@"errorTip"];
    [_stepMsgTv loadHTMLString:[_payInfo DWStringForKey:@"step"] baseURL:nil];
    _stepMsgTv.scrollView.backgroundColor = [UIColor clearColor];
    if ([[_payInfo DWStringForKey:@"needDown"]intValue] == 1) {
        if ([[_payInfo DWStringForKey:@"isSixFour"]intValue] == 1) {
            NSString *base64String = [_payInfo DWStringForKey:@"payUrl"];
            [_qrCodeImageView setImage:[UIImage imageWithData:[base64String base64DecodedData]]];
            
        }else{
            [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:[_payInfo DWStringForKey:@"payUrl"]] placeholderImage:nil options:SDWebImageRetryFailed];
        }
        
    }else{
        
        // 1. 实例化二维码滤镜
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2. 恢复滤镜的默认属性
        [filter setDefaults];
        
        // 3. 将字符串转换成NSData
        NSString *urlStr = [_payInfo DWStringForKey:@"payUrl"];//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
        NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
        // 4. 通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKey:@"inputMessage"];
        
        // 5. 获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        
        // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的
        _qrCodeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:_qrCodeImageView.width];//重绘二维码,使其显示清晰

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark- webViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webView.frame = CGRectMake(webView.originX, webView.originY, webView.width, webView.scrollView.contentSize.height);
        _scrollView.contentSize = CGSizeMake(webView.width,webView.bottomY + 10.0f);
    });
}

#pragma mark-

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 55:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case 66:
        {
            CPRechargeRecordVC *vc = [CPRechargeRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [self removeSelfFromNavigationControllerViewControllers];

        }break;
            
        default:
            break;
    }
}

#pragma mark-

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


@end
