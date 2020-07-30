//
//  DMWEmbeddedCollectionView.h
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMWEasyCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DMWEmbeddedCollectionView : UIView<DMWEasyListCellProtocol>
@property (nonatomic, strong) DMWEasyCollectionView *collectionView;
@property(nonatomic, weak) id delegate;
@end

NS_ASSUME_NONNULL_END
