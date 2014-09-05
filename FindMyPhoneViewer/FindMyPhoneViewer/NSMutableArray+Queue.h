//
//  NSMutableArray+Queue.h
//  FindMyPhoneViewer
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)
- (void)push:(id)object;
- (id)pop;
@end
