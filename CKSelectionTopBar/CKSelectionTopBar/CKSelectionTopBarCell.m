//
//  CKSelectionTopBarCell.m
//  CommonKit
//
//  Created by 徐建波 on 2017/10/17.
//

#import "CKSelectionTopBarCell.h"
#import "UIColor+CKSelectionAssist.h"
#import "Masonry.h"

@interface CKSelectionTopBarCell()

@property (nonatomic, strong) UIButton * button;
@property (nonatomic, strong) UIView * bottomLine;

@end

@implementation CKSelectionTopBarCell

- (void)setItem:(CKSelectionTopBarItem *)item {
    _item = item;
    [self.button setTitle:item.title forState:UIControlStateNormal];
    UIColor * titleColor = _item.normalColor;
    UIColor * titleSelectedColor = _item.selectedColor;
    if (_item.isNight) {
        titleColor = _item.nightColor ?:_item.normalColor;
        titleSelectedColor = _item.selectedNightColor ?: _item.selectedColor;
    }
    [self.button setTitleColor:titleColor forState:UIControlStateNormal];
    [self.button setTitleColor:titleSelectedColor forState:UIControlStateSelected];

    self.button.titleLabel.font = item.font;
    [self setSelected:self.selected];
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!_item) {
        return;
    }
    if (selected) {
        if (_item.showBottomLine) {
            self.bottomLine.backgroundColor = _item.selectedColor;
            self.bottomLine.hidden = NO;
        }
    } else {
        if (_item.showBottomLine) {
            self.bottomLine.hidden = YES;
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (selected) {
            self.button.selected = YES;
            
            if (self.item.selectedBorderColor) {
                UIColor * borderColor = self.item.selectedBorderColor;
                UIColor * backgroundColor = [UIColor whiteColor];
                if (self.item.isNight) {
                    borderColor = [UIColor clearColor];
                    backgroundColor = [UIColor colorWithHexString:@"#2c2c2c"];
                }
                self.button.backgroundColor = backgroundColor;
                self.button.layer.borderColor = borderColor.CGColor;
                
            } else {
                self.button.layer.borderColor = [UIColor clearColor].CGColor;
            }
            //没有显示边框的情况下才要选中变大
            if (!self.item.isNotScale) {
                self.button.transform = CGAffineTransformMakeScale(1.15, 1.15);
            } else {
                self.button.transform = CGAffineTransformIdentity;
            }
        } else {
            self.button.transform = CGAffineTransformIdentity;
            self.button.selected = NO;
            self.button.layer.borderColor = [UIColor clearColor].CGColor;
            self.button.backgroundColor = [UIColor clearColor];
        }
    }];
    
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];
        _button.layer.borderWidth = 0.5;
        _button.layer.cornerRadius = 12;
        _button.userInteractionEnabled = NO;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.right.mas_equalTo(-8);
        }];
    }
    return _button;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        [self.contentView addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.button.titleLabel.mas_left);
            make.right.mas_equalTo(self.button.titleLabel.mas_right);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
    }
    return _bottomLine;
}

@end

