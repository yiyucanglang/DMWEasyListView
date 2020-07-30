//
//  DMWEmbeddedCollectionView.m
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import "DMWEmbeddedCollectionView.h"

@implementation DMWEmbeddedCollectionView
@synthesize dataModel = _dataModel;
@synthesize cellIdentifier = _cellIdentifier;

#pragma mark - System Method
- (void)layoutSubviews {
    
    if (self.frame.size.width == self.listView.frame.size.width) {
        [self.collectionView reloadData];
    }
    [super layoutSubviews];
}

#pragma mark - Public Method
- (void)bindingModel:(id<DMWEasyListEmbeddedDataModelProtocol>)dataModel {
    _dataModel = dataModel;
    self.delegate = dataModel.delegate;
    
    self.backgroundColor = dataModel.backgroundColor;
    [self configCollectionViewWithModel:dataModel];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.collectionView.sourceArr = dataModel.sourceArray;
    
    if (self.frame.size.width == self.listView.frame.size.width) {
        [self.collectionView reloadData];
    }

    if(CGPointEqualToPoint(dataModel.contentOffset, CGPointZero)) {
        self.collectionView.contentOffset = CGPointMake(-dataModel.contentInset.left, -dataModel.contentInset.top);
    }
    else {
        self.collectionView.contentOffset = dataModel.contentOffset;
    }
    
}

#pragma mark - Private Method
- (void)configCollectionViewWithModel:(id<DMWEasyListEmbeddedDataModelProtocol>)dataModel {
    if (!self.collectionView) {
        
        UICollectionViewFlowLayout *layout = [[dataModel.customLayoutClass alloc] init];
        self.collectionView = [[DMWEasyCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        self.collectionView.delegate = (id<UICollectionViewDelegateFlowLayout>)self;
        self.collectionView.dataSource = (id<UICollectionViewDataSource>)self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        topConstraint.active    = YES;
        bottomConstraint.active = YES;
        leftConstraint.active   = YES;
        rightConstraint.active  = YES;
    }
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection         = dataModel.scrollDirection;
    layout.minimumLineSpacing      = dataModel.minimumLineSpacing;
    layout.minimumInteritemSpacing = dataModel.minimumInteritemSpacing;
    self.collectionView.showsHorizontalScrollIndicator = dataModel.showsHorizontalScrollIndicator;
    self.collectionView.showsVerticalScrollIndicator = dataModel.showsVerticalScrollIndicator;
    self.collectionView.pagingEnabled = dataModel.pagingEnabled;
    self.collectionView.scrollEnabled = dataModel.scrollEnabled;
    self.collectionView.contentInset = dataModel.contentInset;
}

- (UIView *)listView {
    UIView *listView = self.superview;
    while (listView && ![listView isKindOfClass:[UITableView class]] && ![listView isKindOfClass:[UICollectionView class]]) {
        listView = listView.superview;
    }
    return listView;
}

#pragma mark - Delegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ((id<DMWEasyListEmbeddedDataModelProtocol>)self.dataModel).contentOffset = scrollView.contentOffset;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        ((id<DMWEasyListEmbeddedDataModelProtocol> )self.dataModel).contentOffset = scrollView.contentOffset;
    }
}
@end
