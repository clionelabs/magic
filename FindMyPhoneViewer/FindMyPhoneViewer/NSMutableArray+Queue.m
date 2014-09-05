//
//  NSMutableArray+Queue.m
//  FindMyPhoneViewer
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

- (void)push:(id)object
{
    [self addObject:object];
    [self trim];
}

- (id)pop
{
    id headObject = [self firstObject];
    [self removeObjectAtIndex:0];
    return headObject;
}

- (void)trim
{
    int max = 20;
    int diff = (int)self.count - max;
    if (diff > 20) {
        for (int i=0; i<diff; i++) {
            [self pop];
        }
    }
}

@end
