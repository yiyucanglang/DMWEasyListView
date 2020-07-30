//
//  DMWEasyListViewProtocol.h
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if 0

#define DMWLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#define DMWLog(...)

#endif

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ConvenientKey
static NSString * const kDMWNumKey                  = @"kDMWNumKey";
static NSString * const kDMWURLKey                  = @"kDMWURLKey";
static NSString * const kDMWNameKey                 = @"kDMWNameKey";
static NSString * const kDMWDescKey                 = @"kDMWDescKey";
static NSString * const kDMWNoteKey                 = @"kDMWNoteKey";
static NSString * const kDMWTimeKey                 = @"kDMWTimeKey";
static NSString * const kDMWFileKey                 = @"kDMWFileKey";
static NSString * const kDMWDataKey                 = @"kDMWDataKey";
static NSString * const kDMWImageKey                = @"kDMWImageKey";
static NSString * const kDMWTitleKey                = @"kDMWTitleKey";
static NSString * const kDMWModelKey                = @"kDMWModelKey";
static NSString * const kDMWReplyKey                = @"kDMWReplyKey";
static NSString * const kDMWCustomKey               = @"kDMWCustomKey";
static NSString * const kDMWAvatarKey               = @"kDMWAvatarKey";
static NSString * const kDMWContentKey              = @"kDMWContentKey";
static NSString * const kDMWMessageKey              = @"kDMWMessageKey";
static NSString * const kDMWCommentKey              = @"kDMWCommentKey";
static NSString * const kDMWUserInfoKey             = @"kDMWUserInfoKey";
static NSString * const kDMWSignatureKey            = @"kDMWSignatureKey";
static NSString * const kDMWBackgroundColorKey      = @"BackgroundColorKey";
static NSString * const kDMWEventTypeNSNumberKey    = @"kDMWEventTypeNSNumberKey";

#pragma mark -
@protocol DMWEasyListCellProtocol <NSObject>

/// cell标识符
@property(nonatomic, strong) NSString   *cellIdentifier;

/// 视图数据
@property(nonatomic, readonly, strong) id dataModel;


/// 绑定显示数据
/// @param dataModel 视图数据模型
- (void)bindingModel:(id)dataModel;


@optional

/// 系统cell对象(UITableViewCell、UICollectionViewCell、UITableViewHeaderFooterView、UICollectionReusableView、nil)
@property(nullable, nonatomic, weak) UIView *systemContainerCell;

/// 系统列表对象(UITableView、UICollectionView)
@property(nonatomic, weak) UIView *listView;

@end


#pragma mark -
@protocol DMWEasyListCellDataModelProtocol <NSObject>

/// 视图对象类名
@property(nonatomic, copy) NSString     *cellClassName;

/// 视图宽度
@property(nonatomic, assign) CGFloat     cellWidth;

/// 视图高度
@property(nonatomic, assign) CGFloat     cellHeight;

/// 视图标识符
@property(nonatomic, copy) NSString     *cellIdentifier;

/// 创建模型对象
+ (instancetype)model;


@optional

/// 视委托对象
@property(nonatomic, weak) id delegate;

/// 用户信息，可以用来承载额外信息
@property(nonatomic, strong) NSDictionary *userInfo;

/// 额外信息，可以用来关联更多的信息
@property(nonatomic, strong) id additionalData;

/// 关联cell位置
@property(nonatomic, strong) NSIndexPath    *indexPath;

@end


#pragma mark -
@protocol DMWEasyListCellSectionDataModelProtocol <NSObject>

/// 头部视图模型
@property(nullable, nonatomic, strong) id<DMWEasyListCellDataModelProtocol>        headModel;

/// 底部视图模型
@property(nullable, nonatomic, strong) id<DMWEasyListCellDataModelProtocol>        footModel;

/// cell模型数组
@property(nonatomic, strong) NSMutableArray<id<DMWEasyListCellDataModelProtocol>>    *rowsArr;

@end

#pragma mark -
@protocol DMWEasyListEmbeddedDataModelProtocol <DMWEasyListCellDataModelProtocol>

/// 数据源
@property (nonatomic, strong) NSMutableArray *sourceArray;

/// 参考UICollectionView同属性
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/// 参考UICollectionView同属性
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

/// 参考UICollectionView同属性
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// 参考UICollectionView同属性
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/// 参考UICollectionView同属性
@property (nonatomic, assign) CGPoint  contentOffset;

/// 参考UICollectionView同属性
@property (nonatomic, assign) BOOL     pagingEnabled;

/// 参考UICollectionView同属性
@property (nonatomic, assign) BOOL     showsHorizontalScrollIndicator;

/// 参考UICollectionView同属性
@property (nonatomic, assign) BOOL     showsVerticalScrollIndicator;

/// 参考UICollectionView同属性
@property (nonatomic, assign) BOOL     scrollEnabled;

/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

/// 自定义collectionview布局类
@property (nonatomic, strong) Class    customLayoutClass;


@end

NS_ASSUME_NONNULL_END
