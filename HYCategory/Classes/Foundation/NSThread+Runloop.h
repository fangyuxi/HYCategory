//
//  NSThread+Runloop.h
//  Pods
//
//  Created by fangyuxi on 2017/1/9.
//
//

#import <Foundation/Foundation.h>

@interface NSThread (RunloopFetch)


/**
 向当前线程添加一个自动释放池，自动释放池会像主线程中的自动释放池一样
 根据runloop的状态去创建和释放
 */
+ (void)addAutoReleasePoolToRunloop;

@end
