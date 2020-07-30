//
//  NSObject+DMWEasyListView.m
//  VideoDonwload
//
//  Created by FDadmin on 2020/7/29.
//  Copyright © 2020 FDadmin. All rights reserved.
//

#import "NSObject+DMWEasyListView.h"

@implementation NSObject (DMWEasyListView)

- (UIView *)dmw_createViewWithNibName:(NSString *)nibName {
    
    if (![self nibFileExitWihtNibName:nibName]) {
        return nil;
    }
    
    UIView *view;
    @try {
        view = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject];
    } @catch (NSException *exception) {
        view =  nil;
    }
    return view;
}

- (BOOL)nibFileExitWihtNibName:(NSString *)nibName {
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];
    if (nibPath.length) {
        return YES;
    }
    return NO;
}

- (NSString *)dmw_identifierWithModel:(id<DMWEasyListCellDataModelProtocol>)model {
    if (model.cellIdentifier.length) {
        return model.cellIdentifier;
    }
    return model.cellClassName;
}

- (id)addListCellToSystemCell:(id)systemCell model:(id<DMWEasyListCellDataModelProtocol>)model listView:(UIView *)listView {
    
    UITableViewCell *cell = systemCell;
    
    UIView *content = [cell.contentView viewWithTag:95278888];
    if (content == nil)
    {
        content = [self dmw_createViewWithNibName:model.cellClassName];
        if(content == nil)
            content = [[NSClassFromString(model.cellClassName) alloc] init];
        [cell.contentView addSubview:content];
        
        content.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        topConstraint.active    = YES;
        bottomConstraint.active = YES;
        leftConstraint.active   = YES;
        rightConstraint.active  = YES;
        
        content.tag   = 95278888;
    }
    [(id<DMWEasyListCellProtocol>)content bindingModel:model];
    
    
    if ([content respondsToSelector:@selector(setSystemContainerCell:)]) {
        ((id<DMWEasyListCellProtocol>)content).systemContainerCell = cell;
    }
    if ([content respondsToSelector:@selector(setListView:)]) {
        ((id<DMWEasyListCellProtocol>)content).listView = systemCell;
    }
    
    return cell;
}

@end


@implementation UITableView (DMWEasyListView)

- (UITableViewCell *)dmw_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model {
    return [self dmw_cellWithIndexPath:indexPath dataModel:model containerCellClass:[UITableViewCell class]];
}

- (UITableViewCell *)dmw_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model containerCellClass:(Class)containerCellClass {
    if(!model) {
        return nil;
    }
    
    Class viewClass = NSClassFromString(model.cellClassName);
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = indexPath;
    }
    
    if ([viewClass isSubclassOfClass:[UITableViewCell class]]) {
        id cell = [self dequeueReusableCellWithIdentifier:[self dmw_identifierWithModel:model]];
        if (!cell) {
            cell = [self dmw_createViewWithNibName:model.cellClassName];
            if (!cell) {//无法从nib创建
                cell = [((UITableViewCell *)[viewClass alloc]) initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self dmw_identifierWithModel:model]];
            }
        }
        [cell bindingModel:model];
        if ([cell respondsToSelector:@selector(setListView:)]) {
            ((id<DMWEasyListCellProtocol>)cell).listView = self;
        }
        return cell;
    }
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:[self dmw_identifierWithModel:model]];
    if (!cell) {
        cell = [((UITableViewCell *)[containerCellClass alloc]) initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self dmw_identifierWithModel:model]];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    }
    
    return [self addListCellToSystemCell:cell model:model listView:self];
}

- (UITableViewHeaderFooterView *)dmw_headerFooterViewWithSection:(NSInteger)section model:(id<DMWEasyListCellDataModelProtocol>)model {
    return [self dmw_headerFooterViewWithSection:section model:model containerHeaderFooterViewClass:[UITableViewHeaderFooterView class]];
}

- (UITableViewHeaderFooterView *)dmw_headerFooterViewWithSection:(NSInteger)section model:(id<DMWEasyListCellDataModelProtocol>)model containerHeaderFooterViewClass:(Class)containerHeaderFooterViewClass {
    if(!model) {
        return nil;
    }
    Class viewClass = NSClassFromString(model.cellClassName);
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
    }
    
    if ([viewClass isSubclassOfClass:[UITableViewHeaderFooterView class]]) {
        id view = [self dequeueReusableHeaderFooterViewWithIdentifier:[self dmw_identifierWithModel:model]];
        if (!view) {
            view = [self dmw_createViewWithNibName:model.cellClassName];
            if (!view) {
                view = [((UITableViewHeaderFooterView *)[viewClass alloc]) initWithReuseIdentifier:[self dmw_identifierWithModel:model]];
            }
        }
        [(id<DMWEasyListCellProtocol>)view bindingModel:model];
        if ([view respondsToSelector:@selector(setListView:)]) {
            ((id<DMWEasyListCellProtocol>)view).listView = self;
        }
        return view;
    }
    
    UITableViewHeaderFooterView *cell = [self dequeueReusableHeaderFooterViewWithIdentifier:[self dmw_identifierWithModel:model]];
    if (!cell) {
        cell = [((UITableViewHeaderFooterView *)[containerHeaderFooterViewClass alloc]) initWithReuseIdentifier:[self dmw_identifierWithModel:model]];
    }
    
    return [self addListCellToSystemCell:cell model:model listView:self];
}

@end


@implementation UICollectionView (DMWEasyListView)
- (UICollectionViewCell *)dmw_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model {
    return [self dmw_cellForItemAtIndexPath:indexPath dataModel:model containerCellClass:[UICollectionViewCell class]];
}

- (UICollectionViewCell *)dmw_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model containerCellClass:(Class)containerCellClass {
    
    if(!model) {
        return nil;
    }
    
    Class viewClass = NSClassFromString(model.cellClassName);
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = indexPath;
    }
    
    [self registerCellWithModel:model containerCellClass:containerCellClass];
    
    UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:[self dmw_identifierWithModel:model] forIndexPath:indexPath];
    
    if ([viewClass isSubclassOfClass:[UICollectionViewCell class]]) {
        
        [(id<DMWEasyListCellProtocol>)cell bindingModel:model];
        
        if ([cell respondsToSelector:@selector(setListView:)]) {
            ((id<DMWEasyListCellProtocol>)cell).listView = self;
        }
        return cell;
    }
    
    return [self addListCellToSystemCell:cell model:model listView:self];
}

- (UICollectionReusableView *)dmw_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(id<DMWEasyListCellDataModelProtocol>)model {
    return [self dmw_viewForSupplementaryElementOfKind:kind atIndexPath:indexPath dataModel:model containerReusableViewClass:[UICollectionReusableView class]];
}

- (UICollectionReusableView *)dmw_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(nonnull id<DMWEasyListCellDataModelProtocol>)model containerReusableViewClass:(nonnull Class)containerReusableViewClass {
    
    if(!model) {
        return nil;
    }
    
    Class viewClass = NSClassFromString(model.cellClassName);
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = indexPath;
    }
    
    [self registerReusableViewWithModel:model kind:kind containerReusableViewClass:containerReusableViewClass];
    
    UICollectionReusableView *cell = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self dmw_identifierWithModel:model] forIndexPath:indexPath];
    
    if ([viewClass isSubclassOfClass:[UICollectionReusableView class]]) {
        
        [(id<DMWEasyListCellProtocol>)cell bindingModel:model];
        
        if ([cell respondsToSelector:@selector(setListView:)]) {
            ((id<DMWEasyListCellProtocol>)cell).listView = self;
        }
        return cell;
    }
    
    return [self addListCellToSystemCell:cell model:model listView:self];
}

#pragma mark -Private
- (void)registerCellWithModel:(id<DMWEasyListCellDataModelProtocol>)model
               containerCellClass:(Class)containerCellClass {
    
    Class viewClass = NSClassFromString(model.cellClassName);
    
    if ([viewClass isSubclassOfClass:[UICollectionViewCell class]]) {
        
        if ([self nibFileExitWihtNibName:model.cellClassName]) {
            [self registerNib:[UINib nibWithNibName:model.cellClassName bundle:nil] forCellWithReuseIdentifier:[self dmw_identifierWithModel:model]];
        }
        else {
            [self registerClass:viewClass forCellWithReuseIdentifier:[self dmw_identifierWithModel:model]];
        }
    }
    else {
        [self registerClass:containerCellClass forCellWithReuseIdentifier:[self dmw_identifierWithModel:model]];
    }
    
}

- (void)registerReusableViewWithModel:(id<DMWEasyListCellDataModelProtocol>)model
                                     kind:(NSString *)kind
               containerReusableViewClass:(Class)reusableViewClass {
    
    Class viewClass = NSClassFromString(model.cellClassName);
    
    if ([viewClass isSubclassOfClass:[UICollectionReusableView class]]) {
        
        if ([self nibFileExitWihtNibName:model.cellClassName]) {
            [self registerNib:[UINib nibWithNibName:model.cellClassName bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:[self dmw_identifierWithModel:model]];
        }
        else {
            [self registerClass:viewClass forSupplementaryViewOfKind:kind withReuseIdentifier:[self dmw_identifierWithModel:model]];
        }
    }
    else {
        [self registerClass:reusableViewClass forSupplementaryViewOfKind:kind withReuseIdentifier:[self dmw_identifierWithModel:model]];
    }
    
}

@end

