//
//  NSObject+HYKVOAdd.h
//  Pods
//
//  Created by fangyuxi on 16/9/8.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (HYKVOAdd)

- (void)addOberverBlockForKeyPath:(NSString *)keyPath
                            block:(void(^)(NSString *keyPath, __weak id object, NSDictionary *change, void *context))block
                          options:(NSKeyValueObservingOptions)options;

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)removeObserverBlocks;

@end
