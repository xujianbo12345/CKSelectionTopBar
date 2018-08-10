//
//  CKSelectionTopBarItem.h
//  CommonKit
//
//  Created by 徐建波 on 2017/10/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CKSelectionTopBarItem : NSObject

@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIFont * font;   //字体大小

@property (nonatomic, strong) UIColor * normalColor;  //正常状态颜色

@property (nonatomic, strong) UIColor * nightColor;  //夜间状态颜色

@property (nonatomic, strong) UIColor * selectedColor;//选中状态字体颜色

@property (nonatomic, strong) UIColor * selectedNightColor;//选中状态夜间模式颜色

@property (nonatomic, strong) UIColor * backgroundColor; //背景颜色

@property (nonatomic, strong) UIColor * selectedBorderColor; //选中状态边款颜色

@property (nonatomic, assign) BOOL isNight;//是否是夜间模式

@property (nonatomic, assign) BOOL isNotScale; //选中是否放大

@property (nonatomic, assign) BOOL showBottomLine; //显示底部跟踪线条

@end
