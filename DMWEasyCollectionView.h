//
//  DMWEasyCollectionView.h
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+DMWEasyListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMWEasyCollectionView : UICollectionView

/// 视图数据源数组
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

NS_ASSUME_NONNULL_END
