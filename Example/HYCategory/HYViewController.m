//
//  HYViewController.m
//  HYCategory
//
//  Created by fangyuxi on 08/19/2016.
//  Copyright (c) 2016 fangyuxi. All rights reserved.
//

#import "HYViewController.h"
#import "NSThread+Runloop.h"

@interface HYViewController ()
{
    NSThread *thread;
}
@end

@implementation HYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(enter) object:nil];
    [thread start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self performSelector:@selector(inc) onThread:thread withObject:nil waitUntilDone:YES];
        });
    });
}

- (void)inc
{
    
}

- (void)enter{
    [NSThread addAutoReleasePoolToRunloop];
    
    [[NSThread currentThread] setName:@"com.fangyuxi.hy.webimage.request"];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
