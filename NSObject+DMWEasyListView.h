//
//  NSObject+DMWEasyListView.h
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMWEasyListViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DMWEasyListView)

/// 通过创建视图对象
/// @param nibName 视图nib名字
- (UIView *)dmw_createViewWithNibName:(NSString *)nibName;
@end


@interface UITableView (DMWEasyListView)

/// 创建UITableViewCell
/// @param indexPath 位置
/// @param model 视图模型数据
- (UITableViewCell *)dmw_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model;

/// 创建UITableViewHeaderFooterView
/// @param section 位置
/// @param model 视图模型数据
- (UITableViewHeaderFooterView *)dmw_headerFooterViewWithSection:(NSInteger)section model: (id<DMWEasyListCellDataModelProtocol>)model;


@end


@interface UICollectionView (DMWEasyListView)

/// 创建UICollectionViewCell
/// @param indexPath 位置
/// @param model 视图模型数据
- (UICollectionViewCell *)dmw_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model;

/// 创建UICollectionReusableView
/// @param kind 类型
/// @param indexPath 位置
/// @param model 视图模型数据
- (UICollectionReusableView *)dmw_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model;


@end

NS_ASSUME_NONNULL_END
