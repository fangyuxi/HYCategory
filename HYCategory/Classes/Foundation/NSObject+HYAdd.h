//
//  NSObject+HYKVOAdd.h
//  Pods
//
//  Created by fangyuxi on 16/9/8.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (HYKVOAdd)

#pragma mark addOberverBlock

- (void)addOberverBlockForKeyPath:(NSString *)keyPath
                            block:(void(^)(NSString *keyPath, __weak id object, NSDictionary *change, void *context))block
                          options:(NSKeyValueObservingOptions)options;

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)removeObserverBlocks;

#pragma hook methods

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel
                         with:(SEL)newSel;

+ (BOOL)swizzleClassMethod:(SEL)originalSel
                      with:(SEL)newSel;

#pragma mark - Associate value

- (void)setAssociateValue:(id)value
                  withKey:(id)key;


- (void)setAssociateWeakValue:(id)value
                      withKey:(id)key;


- (id)getAssociatedValueForKey:(id)key;

- (void)removeAssociatedValues;

#pragma mark copy

- (id)deepCopy;

@end
