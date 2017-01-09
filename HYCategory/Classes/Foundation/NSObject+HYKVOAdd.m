//
//  NSObject+HYKVOAdd.m
//  Pods
//
//  Created by fangyuxi on 16/9/8.
//
//

#import "NSObject+HYKVOAdd.h"
#import <objc/objc.h>
#import <objc/runtime.h>

static NSString *blockKey = @"hy";

@interface HYObseverBlockTarget : NSObject

@property (nonatomic, copy)void(^block)(NSString *keyPath, __weak id object, NSDictionary *change, void *context);

- (instancetype)initWithBlock:(void(^)(NSString *keyPath, __weak id object, NSDictionary *change, void *context))block;

@end

@implementation HYObseverBlockTarget

- (instancetype)initWithBlock:(void(^)(NSString *keyPath, __weak id object, NSDictionary *change, void *context))block
{
    self = [super init];
    self.block = block;
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                        context:(void *)context
{
    if (!self.block) {
        return;
    }
    
    self.block(keyPath, object, change, context);
}

@end

@implementation NSObject (HYKVOAdd)

- (void)addOberverBlockForKeyPath:(NSString *)keyPath
                            block:(void(^)(NSString *keyPath, __weak id object, NSDictionary *change, void *context))block
                            options:(NSKeyValueObservingOptions)options;  
{
    if (!keyPath || !block){
        return;
    }
    HYObseverBlockTarget *target = [[HYObseverBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &blockKey);
    if (!dic) {
        dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &blockKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableArray *blocks = dic[keyPath];
    if (!blocks) {
        blocks = [NSMutableArray new];
        dic[keyPath] = blocks;
    }
    [blocks addObject:target];
    [self addObserver:target forKeyPath:keyPath options:options context:NULL];
}


- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    
    if (!keyPath) {
        return;
    }
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &blockKey);
    if (!dic) {
        dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &blockKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    [dic removeObjectForKey:keyPath];
}

- (void)removeObserverBlocks {
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &blockKey);
    if (!dic) {
        dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &blockKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}



@end
