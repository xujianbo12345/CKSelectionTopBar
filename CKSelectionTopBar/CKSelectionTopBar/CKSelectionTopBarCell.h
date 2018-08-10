//
//  CKSelectionTopBarCell.h
//  CommonKit
//
//  Created by 徐建波 on 2017/10/17.
//

#import <UIKit/UIKit.h>
#import "CKSelectionTopBarItem.h"

#define kCKSelectionTopBarCell @"CKSelectionTopBarCell"

@interface CKSelectionTopBarCell : UICollectionViewCell

@property (nonatomic, strong) CKSelectionTopBarItem * item;

@end
