//
//  HBPromptBoxView.m
//  HaoBan
//
//  Created by 高彬 on 16/11/22.
//  Copyright © 2016年 tsingda. All rights reserved.
//

#import "HBPromptBoxView.h"

@interface HBPromptBoxView ()

@property (nonatomic,strong) UITextView * messageView;
@property (nonatomic,strong) UIImageView * promptImageView;

@end

@implementation HBPromptBoxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * blackView = [UIView new];
        blackView.backgroundColor = RGBA(0, 0, 0, 0.76);
        [self addSubview:blackView];
        
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _promptImageView = [UIImageView new];
        _promptImageView.image = [UIImage imageNamed:@"tanchuang.png"];
        [blackView addSubview:_promptImageView];
        [_promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(blackView.center);
            make.size.mas_equalTo(CGSizeMake(XT(600), XT(370)));
        }];
        
        UIImageView * guanbiImageView = [UIImageView new];
        guanbiImageView.image = [UIImage imageNamed:@"guanbi.png"];
        [blackView addSubview:guanbiImageView];
        
        [guanbiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_promptImageView.mas_right);
            make.centerY.equalTo(_promptImageView.mas_top);
            make.size.mas_equalTo(CGSizeMake(XT(40), XT(40)));
        }];
        
        _messageView = [UITextView new];
        _messageView.font = FN(26);
        _messageView.textColor = CHEX(0x333333);
        _messageView.textAlignment = NSTextAlignmentCenter;
        _messageView.userInteractionEnabled = YES;
        [_promptImageView addSubview:_messageView];
        
        [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_promptImageView.mas_bottom).offset(XT(-10));
            make.centerX.equalTo(_promptImageView.mas_centerX);
            make.width.equalTo(@(XT(450)));
            make.height.equalTo(@(XT(127)));
        }];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self isInBtnRect:point] == NO) {
        if ([self.delegate respondsToSelector:@selector(removePromptBox)]) {
            [self.delegate removePromptBox];
        }
    }
}

- (BOOL)isInBtnRect:(CGPoint)point
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    return  (x>_promptImageView.frame.origin.x && x<= (_promptImageView.frame.origin.x +_promptImageView.frame.size.width)) && (y>_promptImageView.frame.origin.y && y<= (_promptImageView.frame.origin.y + _promptImageView.frame.size.height));
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _messageView.text = _promptMessage;
}

@end
