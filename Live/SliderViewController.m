//
//  SliderViewController.m
//  Live
//
//  Created by 高彬 on 16/11/28.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "SliderViewController.h"

static NSTimeInterval const kAnimationDuration = 0.3;

#pragma mark ---------- left config -----------
static CGFloat const leftShowWidth = 240.f;
static CGFloat const leftScale = 0.8f;
static CGFloat const leftDragbleWidth = 80.f;
static CGFloat const leftMinDragLength = 100.f;

#pragma mark ---------- right config -----------
static CGFloat const rightShowWidth = 240.f;
static CGFloat const rightScale = 1.f;
static CGFloat const rightDragbleWidth = 80.f;
static CGFloat const rightMinDragLength = 100.f;

typedef NS_ENUM(NSUInteger, ZYDragDirection){
    ZYDragDirectionNone = 0,
    ZYDragDirectionLeft, // 左侧界面相关  show the leftView or hide
    ZYDragDirectionRight,
};

@interface SliderViewController ()<UIGestureRecognizerDelegate> {
    UIView * _mainContainerView;
    UIView * _leftContainerView;
    UIView * _rightContainerView;
    
    UIView * _maskView;
    
    BOOL _canShowLeft;
    BOOL _canShowright;
    BOOL _isLeftShow;
    BOOL _isRightShow;
    
    BOOL _canDrag;
    
    CGPoint _lastDragPoint;
    CGPoint _startDragPoint;
    
    ZYDragDirection _dragDirection;
    
    UIPanGestureRecognizer *_panGesture;
    UITapGestureRecognizer *_tapGesture;
}
@end

@implementation SliderViewController

-(instancetype)initWithMainViewController:(UIViewController *)mainVC leftViewController:(UIViewController *)leftVC rightViewController:(UIViewController *)rightVC {
    self = [super init];
    if (self) {
        
        [self prepare];
        
        self.mainViewController = mainVC;
        self.leftViewController = leftVC;
        self.rightViewController = rightVC;
    }
    return self;
}

-(void)prepare {
    CGRect view_bounds = self.view.bounds;
    
    _mainContainerView = [UIView new];
    _leftContainerView = [UIView new];
    _rightContainerView = [UIView new];
    _maskView = [UIView new];
    _maskView.hidden = YES;
    
    _mainContainerView.frame = view_bounds;
    _leftContainerView.frame = view_bounds;
    _rightContainerView.frame = view_bounds;
    
    _maskView.frame = view_bounds;
    
    [self.view addSubview:_leftContainerView];
    [self.view addSubview:_rightContainerView];
    [self.view addSubview:_mainContainerView];
    
    [_mainContainerView addSubview:_maskView];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    _panGesture.delegate = self;
    [_mainContainerView addGestureRecognizer:_panGesture];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
    [_maskView addGestureRecognizer:_tapGesture];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _leftContainerView.hidden = YES;
    _rightContainerView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _leftContainerView.hidden = YES;
    _rightContainerView.hidden = YES;
}

-(void)setMainViewController:(UIViewController *)mainViewController {
    if (!mainViewController) {
        NSLog(@"mainViewController cannot be nil");
        return;
    }
    _mainViewController = mainViewController;
    [self addChildViewController:mainViewController];
    [_mainContainerView addSubview:mainViewController.view];

}

-(void)setLeftViewController:(UIViewController *)leftViewController {
    if (!leftViewController) {
        return;
    }
    _canShowLeft = YES;
    _leftViewController = leftViewController;
    _leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addChildViewController:leftViewController];
    _leftContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -leftShowWidth, 0);
    
    _leftContainerView.transform = CGAffineTransformScale(_leftContainerView.transform, leftScale, leftScale);
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (!rightViewController) {
        return;
    }
    _canShowright = YES;
    _rightViewController = rightViewController;
    
    [self addChildViewController:rightViewController];
    [_rightContainerView addSubview:rightViewController.view];
    _rightViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addChildViewController:_rightViewController];
    [_rightContainerView addSubview:_rightViewController.view];
    _rightContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, rightShowWidth, 0);
    _rightContainerView.transform = CGAffineTransformScale(_rightContainerView.transform, rightScale, rightScale);
}

-(UINavigationController *) sliderNavigationController {
    if (_mainViewController) {
        if ([self.mainViewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)self.mainViewController;
        }
    }else if (self.mainViewController.navigationController) {
        return self.mainViewController.navigationController;
    }
    return nil;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([_mainViewController isKindOfClass:[UINavigationController class]]) {
        if (_mainViewController.childViewControllers.count>1) {
            return NO;
        }
    } else {
        for (UIViewController * controller in _mainViewController.childViewControllers) {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                if (controller.childViewControllers.count>1) {
                    return NO;
                }
            }
        }
    }
    
    if ([gestureRecognizer locationInView:_mainContainerView].x < leftDragbleWidth || [gestureRecognizer locationInView:_mainContainerView].x > KS_SCREEN_WIDTH-rightDragbleWidth) {
        return YES;
    }
    return NO;
    
}

-(void)tapGestureHandler {
    if (_isLeftShow) {
        [self hideLeft];
    }
    if (_isRightShow) {
        [self hideRight];
    }
}

-(void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if (!_isLeftShow && !_isRightShow) {
                if (point.x < leftDragbleWidth || point.x > KS_SCREEN_WIDTH - rightDragbleWidth) {
                    _canDrag = YES;
                } else {
                    _canDrag = NO;
                }
            } else if (_isLeftShow) {
                CGPoint curPoint = [gesture locationInView:_mainContainerView];
                if (curPoint.x > 0 && curPoint.y > 0) {
                    _canDrag = YES;
                } else {
                    _canDrag = NO;
                }
            } else if (_isRightShow) {
                CGPoint curPoint = [gesture locationInView:_mainContainerView];
                if (curPoint.x > 0 && curPoint.y > 0) {
                    _canDrag = YES;
                } else {
                    _canDrag = NO;
                }
            }
            _startDragPoint = point;
            _lastDragPoint = point;
            break;
        case UIGestureRecognizerStateChanged:
            if (!_canDrag) {
                break;
            }
            
            CGFloat main_x = _mainContainerView.frame.origin.x;
            CGFloat move_length = point.x - _lastDragPoint.x;
            CGFloat scale = 1;
            _lastDragPoint = point;
            
            if (!_isLeftShow && !_isRightShow) {
                if (_dragDirection == ZYDragDirectionNone) {
                    if (move_length > 0) {
                        _dragDirection = ZYDragDirectionLeft;
                        _leftContainerView.hidden = NO;
                        _rightContainerView.hidden = YES;
                    } else {
                        _dragDirection = ZYDragDirectionRight;
                        _leftContainerView.hidden = YES;
                        _rightContainerView.hidden = NO;
                    }
                }
                
                switch (_dragDirection) {
                    case ZYDragDirectionLeft:
                        if (!_canShowLeft) {
                            break;
                        }
                        if (_startDragPoint.x > KS_SCREEN_WIDTH-rightDragbleWidth || main_x + move_length < 0) {
                            //防止拖拉左侧区域可以拖出右侧界面
                            break;
                        }
                        
                        CGFloat left_x = _leftContainerView.frame.origin.x;
                        
                        if (move_length > leftShowWidth || left_x >0 || left_x + move_length > 0) {
                            //判断界面变化是否应该停止
                            break;
                        }
                        
                        scale = 1 - (move_length/leftShowWidth) * (1-leftScale);
                        
                        _mainContainerView.transform = CGAffineTransformTranslate(_mainContainerView.transform, move_length, 0);
                        
                        _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, scale, scale);
                        
                        CGFloat left_scale = 1 + (move_length/leftShowWidth) * (1-leftScale);
                        _leftContainerView.transform = CGAffineTransformTranslate(_leftContainerView.transform, move_length, 0);
                        _leftContainerView.transform = CGAffineTransformScale(_leftContainerView.transform, left_scale, left_scale);
                        break;
                        
                    case ZYDragDirectionRight: {
                        if (!_canShowright) {
                            break;
                        }
                        
                        if (_startDragPoint.x<leftDragbleWidth||main_x+move_length>0) {
                            // 防止拖拉右侧区域可以拖出左侧界面
                            break;
                        }
                        
                        CGFloat right_x = _rightContainerView.frame.origin.x;
                        if (fabs(move_length)>rightShowWidth||right_x<0||right_x+move_length<0) {
                            break;
                        }
                        
                        scale = 1+(move_length/rightShowWidth)*(1-rightScale);
                        
                        _mainContainerView.transform = CGAffineTransformTranslate(_mainContainerView.transform, move_length, 0);
                        _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, scale, scale);
                        
                        CGFloat right_scale = 1-(move_length/rightShowWidth)*(1-rightScale);
                        _rightContainerView.transform = CGAffineTransformTranslate(_rightContainerView.transform, move_length, 0);
                        _rightContainerView.transform = CGAffineTransformScale(_rightContainerView.transform, right_scale, right_scale);
                        break;
                    }
                        
                    default:
                        break;
                }
            } else if (_isLeftShow) {
                if (_dragDirection == ZYDragDirectionNone) {
                    _dragDirection = ZYDragDirectionLeft;
                }
                
                CGFloat left_x = _leftContainerView.frame.origin.x;
                
                if (fabs(move_length) > leftShowWidth || left_x > 0 || left_x + move_length > 0 ||point.x > _startDragPoint.x || main_x <= 0) {
                    break;
                }
                
                scale = 1- (move_length/leftShowWidth) * (1-leftScale);
                
                _mainContainerView.transform = CGAffineTransformTranslate(_mainContainerView.transform, move_length, 0);
                _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, scale, scale);
                
                CGFloat left_scale = 1+(move_length/leftShowWidth) * (1-leftScale);
                _leftContainerView.transform = CGAffineTransformTranslate(_leftContainerView.transform, move_length, 0);
                _leftContainerView.transform = CGAffineTransformScale(_leftContainerView.transform, left_scale, left_scale);
                
            } else if (_isRightShow) {
                if (_dragDirection == ZYDragDirectionNone) {
                    _dragDirection = ZYDragDirectionRight;
                }
                
                CGFloat right_x = _rightContainerView.frame.origin.x;
                
                if (move_length>rightShowWidth||right_x<0||right_x+move_length<0||point.x<_startDragPoint.x||main_x>=0) {
                    break;
                }
                
                scale = 1+(move_length/rightShowWidth)*(1-rightScale);
                _mainContainerView.transform = CGAffineTransformTranslate(_mainContainerView.transform, move_length, 0);
                _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, scale, scale);
                
                CGFloat right_scale = 1-(move_length/rightShowWidth)*(1-rightScale);
                _rightContainerView.transform = CGAffineTransformTranslate(_rightContainerView.transform, move_length, 0);
                _rightContainerView.transform = CGAffineTransformScale(_rightContainerView.transform, right_scale, right_scale);
            }
            
            break;
            
        case UIGestureRecognizerStateEnded: {
            if (!_canDrag) {
                break;
            }
            CGFloat move_length = fabs(point.x - _startDragPoint.x);
            
            switch (_dragDirection) {
                case ZYDragDirectionLeft:
                {
                    CGFloat left_x = _leftContainerView.frame.origin.x;
                    if (!_canShowLeft) {
                        break;
                    }
                    if (_isLeftShow && point.x - _startDragPoint.x>0 && left_x == 0) {
                        break;
                    }
                    
                    if (move_length > leftMinDragLength) {
                        if (_isLeftShow) {
                            [self hideLeft];
                        } else {
                            [self showLeft];
                        }
                    } else {
                        if (_isLeftShow) {
                            [self showLeft];
                        } else {
                            [self hideLeft];
                        }
                    }
                    
                    break;
                }
                case ZYDragDirectionRight: {
                    CGFloat right_x = _rightContainerView.frame.origin.x;
                    
                    if (!_canShowLeft) {
                        break;
                    }
                    
                    if (_isRightShow && point.x - _startDragPoint.x < 0 && right_x == 0) {
                        break;
                    }
                    
                    if (move_length > rightMinDragLength) {
                        if (_isRightShow) {
                            [self hideRight];
                        } else {
                            [self showRight];
                        }
                    } else {
                        if (_isRightShow) {
                            [self showRight];
                        } else {
                            [self hideRight];
                        }
                    }
                    
                    break;
                }
                    
                default: {
                    [self hideLeft];
                    [self hideRight];
                    break;
                }
            }
            
            _dragDirection = ZYDragDirectionNone;
            _lastDragPoint = CGPointZero;
            _startDragPoint = CGPointZero;
            _canDrag = NO;
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -------------- calculate duration -----------------------
- (NSTimeInterval)calculateAnimationDurationIsShow:(BOOL)isShow
{
    NSTimeInterval timeInterval;
    
    CGFloat main_x = _mainContainerView.frame.origin.x;
    CGFloat left_x = _leftContainerView.frame.origin.x;
    CGFloat right_x = _rightContainerView.frame.origin.x;
    
    if (main_x==0||left_x==0||right_x==0) {
        return kAnimationDuration;
    }
    
    if (main_x>0) {
        // left
        CGFloat left_scale = _leftContainerView.frame.size.width/KS_SCREEN_WIDTH;
        if (isShow) {
            timeInterval = (1-(left_scale-leftScale)/(1-leftScale))*kAnimationDuration;
        } else {
            timeInterval = ((left_scale-leftScale)/(1-leftScale))*kAnimationDuration;
        }
    } else {
        // right
        CGFloat right_scale = _rightContainerView.frame.size.width/KS_SCREEN_WIDTH;
        if (isShow) {
            timeInterval = (1-(right_scale-rightScale)/(1-rightScale))*kAnimationDuration;
        } else {
            timeInterval = ((right_scale-rightScale)/(1-rightScale))*kAnimationDuration;
        }
    }
    return timeInterval;
}

#pragma mark -------------- public method -----------------------
- (void)showLeft
{
    _leftContainerView.hidden = NO;
    _rightContainerView.hidden = YES;
    [UIView animateWithDuration:[self calculateAnimationDurationIsShow:YES]
                     animations:^{
                         
                         _mainContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, leftShowWidth, 0);
                         _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, leftScale, leftScale);
                         
                         _leftContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                         _leftContainerView.transform = CGAffineTransformScale(_leftContainerView.transform, 1, 1);
                     }
                     completion:^(BOOL finished) {
                         _isLeftShow = YES;
                         _maskView.hidden = NO;
                         [_mainContainerView bringSubviewToFront:_maskView];
                     }];
}

- (void)hideLeft
{
    [UIView animateWithDuration:[self calculateAnimationDurationIsShow:NO]
                     animations:^{
                         _mainContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                         _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, 1, 1);
                         
                         _leftContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -leftShowWidth, 0);
                         _leftContainerView.transform = CGAffineTransformScale(_leftContainerView.transform, leftScale, leftScale);
                     }
                     completion:^(BOOL finished) {
                         _isLeftShow = NO;
                         _maskView.hidden = YES;
                         _leftContainerView.hidden = YES;
                     }];
}

- (void)showRight
{
    _leftContainerView.hidden = YES;
    _rightContainerView.hidden = NO;
    [UIView animateWithDuration:[self calculateAnimationDurationIsShow:YES]
                     animations:^{
                         
                         _mainContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -rightShowWidth, 0);
                         _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, rightScale, rightScale);
                         
                         _rightContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                         _rightContainerView.transform = CGAffineTransformScale(_rightContainerView.transform, 1, 1);
                     }
                     completion:^(BOOL finished) {
                         _isRightShow = YES;
                         _maskView.hidden = NO;
                         [_mainContainerView bringSubviewToFront:_maskView];
                     }];
    
}

- (void)hideRight
{
    [UIView animateWithDuration:[self calculateAnimationDurationIsShow:NO]
                     animations:^{
                         
                         _mainContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                         _mainContainerView.transform = CGAffineTransformScale(_mainContainerView.transform, 1, 1);
                         
                         _rightContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, rightShowWidth, 0);
                         _rightContainerView.transform = CGAffineTransformScale(_rightContainerView.transform, rightScale, rightScale);
                     }
                     completion:^(BOOL finished) {
                         _isRightShow = NO;
                         _maskView.hidden = YES;
                         _rightContainerView.hidden = YES;
                     }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
