//
//  SliderViewController.h
//  Live
//
//  Created by 高彬 on 16/11/28.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "HBBaseViewController.h"

@interface SliderViewController : HBBaseViewController

@property (nonatomic,strong) UIViewController * mainViewController;

@property (nonatomic,strong) UIViewController * leftViewController;

@property (nonatomic,strong) UIViewController * rightViewController;

@property (nonatomic,strong) UINavigationController * sliderNavigation;


-(instancetype)initWithMainViewController:(UIViewController *)mainVC
                       leftViewController:(UIViewController *)leftVC
                      rightViewController:(UIViewController *)rightVC;

-(void)showLeft;

-(void)hideLeft;

-(void)showRight;

-(void)hideRight;

@end
