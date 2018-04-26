//
//  UIViewController+CPViewControllerExtension.m
//  lottery
//
//  Created by wayne on 2017/9/15.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "UIViewController+CPViewControllerExtension.h"

@implementation UIViewController (CPViewControllerExtension)

-(void)removeSelfFromNavigationControllerViewControllers
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableIndexSet * mindexSet = [NSMutableIndexSet new];
        for (int i =0; i<self.navigationController.viewControllers.count; i++ ) {
            
            UIViewController * vc = self.navigationController.viewControllers[i];
            if ( vc == self) {
                
                [mindexSet addIndex:(NSInteger)i];
            }
        }
        
        NSMutableArray * aryViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [aryViewControllers removeObjectsAtIndexes:mindexSet];
        self.navigationController.viewControllers = aryViewControllers;
    });
}

#pragma mark- long press

-(void)cp_AddLongPressShotScreenAction
{
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cp_LongPressSaveShotScreenImageToAblum:)];
    [self.view addGestureRecognizer:longPress];
    //判定为长按手势 需要的时间
    longPress.minimumPressDuration = 0.5;
    //判定时间,允许用户移动的距离
    longPress.allowableMovement = 100;
}

- (void)cp_LongPressSaveShotScreenImageToAblum:(UILongPressGestureRecognizer *)longPress{
    
    //长按手势
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet  *actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片到相册",nil];
        actionSheet.tag = 106;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}

-(void)cp_ScreenShotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(cp_ImageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)cp_ImageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    if (!error) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"保存图片成功"];
    }else{
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"保存图片失败"];
    }
}

#pragma mark- action delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片到相册"]) {
        [self cp_ScreenShotWithView:self.view];
    }
}


@end
