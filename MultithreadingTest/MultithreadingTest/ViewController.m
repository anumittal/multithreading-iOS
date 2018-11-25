//
//  ViewController.m
//  MultithreadingTest
//
//  Created by Anu Mittal on 10/11/18.
//  Copyright © 2018 Anu Mittal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self threadingSyncFunction];
//    [self customQueueFunction];
//    [self shortestDeadlockLoop];
}

- (void)threadingSyncFunction {
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0); // this queue creation happens on main thread
    /* void dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
        Submits a block to a dispatch queue for synchronous execution.
        Unlike dispatch_async, this function does not return until the block has finished.
        Calling this function and targeting the current queue results in deadlock.
        Unlike with dispatch_async, no retain is performed on the target queue.
        Because calls to this function are synchronous, it "borrows" the reference of the caller.
        Moreover, no Block_copy is performed on the block. */
    
        dispatch_sync(queue, ^{
            // entered first task in the concurrent
            NSLog(@"1");
            NSLog(@"01");
            NSLog(@"001");
            dispatch_sync(queue, ^{
                // enter second task added in the concurrent but for synchronous execution
                NSLog(@"2");
                NSLog(@"3");
                NSLog(@"4");
                NSLog(@"5");
            });
            NSLog(@"6");
            NSLog(@"7");
            NSLog(@"8");
            NSLog(@"9");
            NSLog(@"10");
        });
    NSLog(@"anumittal1");
    NSLog(@"anumittal2");
    NSLog(@"anumittal3");
    NSLog(@"anumittal4");
}
    
    
-(void)customQueueFunction {
    dispatch_queue_t queue = dispatch_queue_create("new.concurrent.queue.label", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1");
        dispatch_sync(queue, ^{
            NSLog(@"2");
            NSLog(@"3");
            NSLog(@"4");
            NSLog(@"5");
            // outer block is waiting for this inner block to complete,
            // inner block won't start before outer block finishes
            // => deadlock
        });
//
        NSLog(@"6");
        NSLog(@"7");
        NSLog(@"8");
        NSLog(@"9");
        NSLog(@"10");
//         this will never be reached
    });
}

- (void)shortestDeadlockLoop {
    /* dispatch_queue_main_t dispatch_get_main_queue(void);
        - Returns the serial dispatch queue associated with the application’s main thread. */
    
    dispatch_sync(dispatch_get_main_queue(), ^{});
}
@end
