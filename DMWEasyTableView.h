//
//  DMWEasyTableView.h
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+DMWEasyListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMWEasyTableView : UITableView

/// 视图数据源数组
@property (nonatomic, strong) NSMutableArray *sourceArr;

/// 开启系统自动算高，开启必须在设置dataSource和delegate之前，默认关闭
@property (nonatomic, assign) BOOL openEstimatedCellHeight;

@end

NS_ASSUME_NONNULL_END
