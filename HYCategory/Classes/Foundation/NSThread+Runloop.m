//
//  NSThread+Runloop.m
//  Pods
//
//  Created by fangyuxi on 2017/1/9.
//
//

#import "NSThread+Runloop.h"

static NSString *const HYNSThreadAutoleasePoolAlreadyAddKey = @"HYNSThreadAutoleasePoolAlreadyAddKey";
static NSString *const HYNSThreadAutoleasePoolStackKey = @"HYNSThreadAutoleasePoolStackKey";

@implementation NSThread (RunloopFetch)

+ (void)addAutoReleasePoolToRunloop
{
    if ([[NSThread currentThread] isMainThread]) {
        return;
    }
    
    NSThread *thread = [self currentThread];
    if (!thread) {
        return;
    }
    
    if ([[thread.threadDictionary objectForKey:HYNSThreadAutoleasePoolAlreadyAddKey] boolValue]) {
        return;
    }
    [NSThread setup];
    [thread.threadDictionary setObject:@(YES) forKey:HYNSThreadAutoleasePoolAlreadyAddKey];
}

+ (void)setup
{
    //获取和创建当前runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //创建一个用于创建自动释放池的runloop观察者
    CFRunLoopObserverRef pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                                kCFRunLoopEntry,
                                                                YES,
                                                                -0x7FFFFFFF, //在所有通知之前
                                                                HYRunLoopAutoreleasePoolObserverCallBack,
                                                                NULL);
    CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
    
    //创建一个用于释放自动释放池的runloop观察者
    CFRunLoopObserverRef popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                               kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                                               YES,
                                                               0x7FFFFFFF,//在所有通知之后
                                                               HYRunLoopAutoreleasePoolObserverCallBack,
                                                               NULL);
    CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
}

static const void *PoolStackRetainCallBack(CFAllocatorRef allocator, const void *value) {
    return value;
}

static void PoolStackReleaseCallBack(CFAllocatorRef allocator, const void *value) {
    CFRelease((CFTypeRef)value);
}

static void HYRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            AutoreleasePoolPush();
        } break;
        case kCFRunLoopBeforeWaiting: {
            AutoreleasePoolPop();
            AutoreleasePoolPush();
        } break;
        case kCFRunLoopExit: {
            AutoreleasePoolPop();
        } break;
        default: break;
    }
}

static void AutoreleasePoolPush()
{
    NSLog(@"push");
    NSMutableDictionary *dic = [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = [dic objectForKey:HYNSThreadAutoleasePoolStackKey];
    
    if (!poolStack) {
        
        //autoreleasepool 不能被retain和autorelease
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        dic[HYNSThreadAutoleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [poolStack addObject:pool];
}

static void AutoreleasePoolPop()
{
    NSLog(@"pop");
    NSMutableDictionary *dic = [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = [dic objectForKey:HYNSThreadAutoleasePoolStackKey];
    [poolStack removeLastObject];
}

@end

