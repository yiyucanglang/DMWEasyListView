//
//  DMWEasyCollectionView.m
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import "DMWEasyCollectionView.h"

@interface HXCollectionViewInterceptor : NSObject
@property (nonatomic, weak) id originalReceiver;
@property (nonatomic, weak) DMWEasyCollectionView *middleMan;
@end


@interface DMWEasyCollectionView()
<
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) HXCollectionViewInterceptor *delegateInterceptor;
@property (nonatomic, strong) HXCollectionViewInterceptor *datasourceInterceptor;
@property (nonatomic, assign) BOOL useItemSizeOfFlowlayout;
@property (nonatomic, assign) BOOL useHeaderReferenceSizeOfFlowlayout;
@property (nonatomic, assign) BOOL useFooterReferenceSizeOfFlowlayout;
@property(nonatomic, assign) BOOL multiSection;
@end

@implementation HXCollectionViewInterceptor

#pragma mark - System Method
- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([NSStringFromSelector(aSelector) hasPrefix:@"collectionView:layout:sizeForItemAtIndexPath:"] && self.middleMan.useItemSizeOfFlowlayout) {
        return [super respondsToSelector:aSelector];
    }
    
    if ([NSStringFromSelector(aSelector) hasPrefix:@"collectionView:layout:referenceSizeForHeaderInSection:"] && self.middleMan.useHeaderReferenceSizeOfFlowlayout) {
        return [super respondsToSelector:aSelector];
    }
    
    if ([NSStringFromSelector(aSelector) hasPrefix:@"collectionView:layout:referenceSizeForFooterInSection:"] && self.middleMan.useFooterReferenceSizeOfFlowlayout) {
        return [super respondsToSelector:aSelector];
    }
    
    if ([self.originalReceiver respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.middleMan respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
    
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if ([self.originalReceiver respondsToSelector:aSelector]) {
        return self.originalReceiver;
    }
    if ([self.middleMan respondsToSelector:aSelector]) {
        return self.middleMan;
    }
    return self.originalReceiver;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSString *methodName =NSStringFromSelector(aSelector);
    if ([methodName hasPrefix:@"_"]) {//对私有方法不进行crash日志采集操作
        return nil;
    }
    NSString *crashMessages = [NSString stringWithFormat:@"crashProtect: [%@ %@]: unrecognized selector sent to instance",self,NSStringFromSelector(aSelector)];
    NSMethodSignature *signature = [HXCollectionViewInterceptor instanceMethodSignatureForSelector:@selector(crashProtectCollectCrashMessages:)];
    [self crashProtectCollectCrashMessages:crashMessages];
    return signature;//对methodSignatureForSelector 进行重写，不然不会调用forwardInvocation方法
    
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //将此方法进行重写，在里这不进行任何操作，屏蔽会产生crash的方法调用
}


#pragma mark - Private
- (void)crashProtectCollectCrashMessages:(NSString *)crashMessage{
    
    DMWLog(@"%@",crashMessage);
    
}

@end


@implementation DMWEasyCollectionView


#pragma mark - System Method
- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    self.datasourceInterceptor.originalReceiver = dataSource;
    [super setDataSource:(id<UICollectionViewDataSource>)self.datasourceInterceptor];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    UICollectionViewFlowLayout *referenceLayout = [UICollectionViewFlowLayout new];
    
    UICollectionViewFlowLayout *flowlayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if ([flowlayout respondsToSelector:@selector(itemSize)] && !CGSizeEqualToSize(flowlayout.itemSize, referenceLayout.itemSize)) {
        self.useItemSizeOfFlowlayout = YES;
    }
    if ([flowlayout respondsToSelector:@selector(headerReferenceSize)] && !CGSizeEqualToSize(flowlayout.headerReferenceSize, referenceLayout.headerReferenceSize)) {
        self.useHeaderReferenceSizeOfFlowlayout = YES;
    }
    if ([flowlayout respondsToSelector:@selector(footerReferenceSize)] && !CGSizeEqualToSize(flowlayout.footerReferenceSize, referenceLayout.footerReferenceSize)) {
        self.useHeaderReferenceSizeOfFlowlayout = YES;
    }
    
    
    self.delegateInterceptor.originalReceiver = delegate;
    [super setDelegate:(id<UICollectionViewDelegate>)self.delegateInterceptor];
}


#pragma mark Assist Method
- (NSInteger)rowNumAtIndex:(NSInteger)index {
    if (self.multiSection) {
        id<DMWEasyListCellSectionDataModelProtocol> model = self.sourceArr[index];
        return model.rowsArr.count;
    }
    return self.sourceArr.count;
}

- (id<DMWEasyListCellDataModelProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath {
    if (self.multiSection) {
        id<DMWEasyListCellSectionDataModelProtocol> model = self.sourceArr[indexPath.section];
        return  model.rowsArr[indexPath.item];
    }
    return self.sourceArr[indexPath.item];
}

- (id<DMWEasyListCellDataModelProtocol>)sectionModelAtSection:(NSInteger)section kind:(NSString *)kind {
    if (self.multiSection) {
        if (self.sourceArr.count > section) {
            id<DMWEasyListCellSectionDataModelProtocol> model = self.sourceArr[section];
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                return model.headModel;
            }
            return model.footModel;
        }
    }
    return nil;
}



#pragma mark - Delegate
#pragma UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.sourceArr.count && [self.sourceArr[0] conformsToProtocol:@protocol(DMWEasyListCellSectionDataModelProtocol)]) {
        self.multiSection = YES;
        return self.sourceArr.count;
    }
    self.multiSection = NO;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self rowNumAtIndex:section];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self dmw_cellForItemAtIndexPath:indexPath dataModel:[self rowModelAtIndexPath:indexPath]];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [self dmw_viewForSupplementaryElementOfKind:kind atIndexPath:indexPath dataModel:[self sectionModelAtSection:indexPath.section kind:kind]];
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    id<DMWEasyListCellDataModelProtocol> model = [self rowModelAtIndexPath:indexPath];
    if (model.cellHeight <= 0) {
        return ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    }
    return CGSizeMake(model.cellWidth, model.cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    id<DMWEasyListCellDataModelProtocol> model = [self sectionModelAtSection:section kind:UICollectionElementKindSectionHeader];
    return CGSizeMake(model.cellWidth, model.cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<DMWEasyListCellDataModelProtocol> model = [self sectionModelAtSection:section kind:UICollectionElementKindSectionFooter];
    return CGSizeMake(model.cellWidth, model.cellHeight);
}

#pragma mark - Setter And Getter
- (HXCollectionViewInterceptor *)delegateInterceptor {
    if (!_delegateInterceptor) {
        _delegateInterceptor = [[HXCollectionViewInterceptor alloc] init];
        _delegateInterceptor.middleMan = self;
    }
    return _delegateInterceptor;
}

- (HXCollectionViewInterceptor *)datasourceInterceptor {
    if (!_datasourceInterceptor) {
        _datasourceInterceptor = [[HXCollectionViewInterceptor alloc] init];
        _datasourceInterceptor.middleMan = self;
    }
    return _datasourceInterceptor;
}

- (NSMutableArray *)sourceArr {
    if (!_sourceArr) {
        _sourceArr = [[NSMutableArray alloc] init];
    }
    return _sourceArr;
}

@end
