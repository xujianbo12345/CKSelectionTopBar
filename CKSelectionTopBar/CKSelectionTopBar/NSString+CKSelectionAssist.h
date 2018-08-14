//
//  NSString+CKSelectionAssist.h
//  CKSelectionTopBar
//
//  Created by 徐建波 on 2018/8/14.
//  Copyright © 2018年 bobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CKSelectionAssist)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end
