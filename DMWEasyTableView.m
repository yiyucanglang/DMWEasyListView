//
//  DMWEasyTableView.m
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import "DMWEasyTableView.h"

@class DMWEasyTableView;
@interface DMWEasyTableViewInterceptor : NSObject
@property (nonatomic, weak) id originalReceiver;
@property (nonatomic, weak) DMWEasyTableView *middleMan;
@end

@implementation DMWEasyTableViewInterceptor

#pragma mark - System Method
- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([NSStringFromSelector(aSelector) containsString:@"heightForRow"] && self.middleMan.openEstimatedCellHeight) {
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
    NSMethodSignature *signature = [DMWEasyTableViewInterceptor instanceMethodSignatureForSelector:@selector(crashProtectCollectCrashMessages:)];
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

@interface DMWEasyTableView()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (nonatomic, strong) DMWEasyTableViewInterceptor *delegateInterceptor;

@property (nonatomic, strong) DMWEasyTableViewInterceptor *datasourceInterceptor;
@property(nonatomic, assign) BOOL multiSection;
@end

@implementation DMWEasyTableView

#pragma mark - System Method
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.datasourceInterceptor.originalReceiver = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.datasourceInterceptor];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.delegateInterceptor.originalReceiver = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self.delegateInterceptor];
}

#pragma mark - Public Method


#pragma mark - Private Method

#pragma mark Assist Method
- (id<DMWEasyListCellDataModelProtocol>)_rowModelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.multiSection) {
        return ((id<DMWEasyListCellSectionDataModelProtocol>)self.sourceArr[indexPath.section]).rowsArr[indexPath.row];
    }
    return self.sourceArr[indexPath.row];
    
}

- (id<DMWEasyListCellDataModelProtocol>)_sectionModelAtSection:(NSInteger)section head:(BOOL)head {
    if (self.multiSection) {
        if (self.sourceArr.count <= section) {
            return nil;
        }
        id<DMWEasyListCellSectionDataModelProtocol> model = self.sourceArr[section];
        
        if (head) {
            return model.headModel;
        }
        return model.footModel;
    }
    return nil;
}



#pragma mark - Delegate
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sourceArr.count && [self.sourceArr[0] conformsToProtocol:@protocol(DMWEasyListCellSectionDataModelProtocol)]) {
        self.multiSection = YES;
        return self.sourceArr.count;
    }
    self.multiSection = NO;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.multiSection) {
        return self.sourceArr.count;
    }
    
    id<DMWEasyListCellSectionDataModelProtocol> model = self.sourceArr[section];
    
    return model.rowsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self dmw_cellWithIndexPath:indexPath dataModel:[self _rowModelAtIndexPath:indexPath]];
}

#pragma UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self dmw_headerFooterViewWithSection:section model:[self _sectionModelAtSection:section head:YES]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self dmw_headerFooterViewWithSection:section model:[self _sectionModelAtSection:section head:NO]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [self _rowModelAtIndexPath:indexPath].cellHeight;
    if (height <= 0) {
        return self.rowHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = [self _sectionModelAtSection:section head:YES].cellHeight;
    
    if (height <= 0 && self.sectionHeaderHeight > 0) {
        return self.sectionHeaderHeight;
    }
    return MAX(height, 0.01);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = [self _sectionModelAtSection:section head:NO].cellHeight;
    
    if (height <= 0 && self.sectionFooterHeight > 0) {
        return self.sectionFooterHeight;
    }
    return MAX(height, 0.01);
}

#pragma mark - Setter And Getter
- (DMWEasyTableViewInterceptor *)delegateInterceptor {
    if (!_delegateInterceptor) {
        _delegateInterceptor = [[DMWEasyTableViewInterceptor alloc] init];
        _delegateInterceptor.middleMan = self;
    }
    return _delegateInterceptor;
}

- (DMWEasyTableViewInterceptor *)datasourceInterceptor {
    if (!_datasourceInterceptor) {
        _datasourceInterceptor = [[DMWEasyTableViewInterceptor alloc] init];
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
