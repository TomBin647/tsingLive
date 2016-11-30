//
//  GBLiveCollectionViewController.h
//  Live
//
//  Created by 高彬 on 16/11/30.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "HBBaseViewController.h"

@class ALinLive;
@interface GBLiveCollectionViewController : UICollectionViewController


@property (nonatomic,strong) NSArray * lives;

@property (nonatomic,assign) NSInteger currentIndex;

@end
