//
//  NSArray+CKSelectionAssist.m
//  CKSelectionTopBar
//
//  Created by 徐建波 on 2018/8/14.
//  Copyright © 2018年 bobo. All rights reserved.
//

#import "NSArray+CKSelectionAssist.h"

@implementation NSArray (CKSelectionAssist)

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end
