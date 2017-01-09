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

/**
 addOberverBlock

 @param keyPath keyPath
 @param block callback block
 @param options NSKeyValueObservingOptions
 */
- (void)addOberverBlockForKeyPath:(NSString *)keyPath
                            block:(void(^)(NSString *keyPath, __weak id object, NSDictionary *change, void *context))block
                          options:(NSKeyValueObservingOptions)options;

/**
 remove oberver

 @param keyPath keyPath
 */
- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;


/**
 removeObserverBlocks
 */
- (void)removeObserverBlocks;

#pragma hook methods


/**
 swizzleInstanceMethod

 @param originalSel originalSel
 @param newSel newSel
 @return result
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel
                         with:(SEL)newSel;


/**
 swizzleClassMethod

 @param originalSel originalSel
 @param newSel newSel
 @return result
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel
                      with:(SEL)newSel;

#pragma mark - Associate value


/**
 setAssociateValue

 @param value no nil value, retained value
 @param key no nil key
 */
- (void)setAssociateValue:(id)value
                  withKey:(id)key;

/**
 setAssociateWeakValue
 
 @param value no nil value, no retained value
 @param key no nil key
 */
- (void)setAssociateWeakValue:(id)value
                      withKey:(id)key;


/**
 getAssociatedValueForKey

 @param key key
 @return value
 */
- (id)getAssociatedValueForKey:(id)key;


/**
 removeAssociatedValues
 */
- (void)removeAssociatedValues;

#pragma mark copy


/**
 deepCopy

 @return deepCopy use archive
 */
- (id)deepCopy;

@end
