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
                                                                YYRunLoopAutoreleasePoolObserverCallBack,
                                                                NULL);
    CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
    CFRelease(pushObserver);
    
    //创建一个用于释放自动释放池的runloop观察者
    CFRunLoopObserverRef popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                               kCFRunLoopEntry,
                                                               YES,
                                                               0x7FFFFFFF,//在所有通知之后
                                                               YYRunLoopAutoreleasePoolObserverCallBack,
                                                               NULL);
    CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
    CFRelease(pushObserver);
}

static void YYRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
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
    NSMutableDictionary *dic = [NSThread currentThread].threadDictionary;
    NSPointerArray *poolStack = [dic objectForKey:HYNSThreadAutoleasePoolStackKey];
    
    if (!poolStack) {
        NSPointerArray *stack = [NSPointerArray weakObjectsPointerArray];
        [dic setObject:stack forKey:HYNSThreadAutoleasePoolStackKey];
        poolStack = stack;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [poolStack addPointer:pool];
}

static void AutoreleasePoolPop()
{
    NSMutableDictionary *dic = [NSThread currentThread].threadDictionary;
    NSPointerArray *poolStack = [dic objectForKey:HYNSThreadAutoleasePoolStackKey];
    NSAutoreleasePool *pool = [poolStack pointerAtIndex:[poolStack count] - 1];
    [poolStack removePointerAtIndex:[poolStack count] - 1];
    [pool release];
}

@end

