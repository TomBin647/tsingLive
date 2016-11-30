//
//  UIViewController+SliderViewController.m
//  Live
//
//  Created by 高彬 on 16/11/28.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "UIViewController+SliderViewController.h"
#import "SliderViewController.h"

@implementation UIViewController (SliderViewController)

-(SliderViewController *) sliderViewController {
    UIViewController *viewcontroller = (UIViewController *)self.parentViewController;
    while (viewcontroller) {
        if ([viewcontroller isKindOfClass:[SliderViewController class]]) {
            return (SliderViewController *)viewcontroller;
        }else if (viewcontroller.parentViewController && viewcontroller.parentViewController!=viewcontroller){
            viewcontroller = (UIViewController *)viewcontroller.parentViewController;
        }else{
            return nil;
        }
    }
    return nil;
}

@end
