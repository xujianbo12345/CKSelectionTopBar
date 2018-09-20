//
//  CKSelectionTopBar.m
//  CommonKit
//
//  Created by 徐建波 on 2017/10/10.
//

#import "CKSelectionTopBar.h"
#import "UIColor+CKSelectionAssist.h"
#import "Masonry.h"
#import "CKSelectionTopBarCell.h"
#import "NSString+CKSelectionAssist.h"
#import "NSArray+CKSelectionAssist.h"

#define kCKNormalSpace 8

@interface CKSelectionTopBar()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *topBarItems;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *link;

@property (nonatomic, strong) UIButton * selectedBtn;
@property (nonatomic, assign) CGFloat addWidth;//补充宽度（在宽度不够铺满时）

@end

@implementation CKSelectionTopBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
        [self setupLayout];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

- (void)defaultInit {
    
    _font = [UIFont systemFontOfSize:14.0f];
    _selectedFont = [UIFont systemFontOfSize:14.0f];
    _normalColor = [UIColor colorWithHexString:@"#333333"];
    _nightColor = [UIColor colorWithHexString:@"9b9b9b"];
    _selectedColor = [UIColor colorWithHexString:@"#2e9fff"];
    _selectedNightColor = [UIColor colorWithHexString:@"#265f8f"];
    self.backgroundColor = [UIColor whiteColor];
    
    _font = [UIFont systemFontOfSize:14];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_collectionView registerClass:[CKSelectionTopBarCell class] forCellWithReuseIdentifier:kCKSelectionTopBarCell];
    [self addSubview:_collectionView];
    
    _link = [[UIView alloc] init];
    _link.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];

    [self addSubview:_link];
    [_link mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setupLayout {
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        if (_leftView &&
            _leftViewMode == CKSelectionViewModeDefault) {
            make.left.mas_equalTo(_leftView.mas_right);
        } else {
            make.left.mas_equalTo(0);
        }
        if (_rightView &&
            _rightViewMode == CKSelectionViewModeDefault) {
            make.right.mas_equalTo(_rightView.mas_left);
        } else {
            make.right.mas_equalTo(0);
        }
    }];
    if (_leftView) {
        CGFloat leftViewWidth = _leftView.frame.size.width;
        if (leftViewWidth <= 0) {
            leftViewWidth = kCKTopBarHeight;
        }
        [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(leftViewWidth);
        }];
        if (_leftViewMode == CKSelectionViewModeTranslucent) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, leftViewWidth, 0, 0);
        }
    }
    if (_rightView) {
        CGFloat rightViewWidth = _rightView.frame.size.width;
        if (rightViewWidth == 0) {
            rightViewWidth = kCKTopBarHeight;
        }
        [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(rightViewWidth);
        }];
        if (_rightViewMode == CKSelectionViewModeTranslucent) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, rightViewWidth);
        }
    }
}

- (void)calculateWidth {
    _topBarItems = @[].mutableCopy;
    NSUInteger numberOfTitles = _titlesArray.count;
    CGFloat totalWidth = 0;
    
    for (NSInteger i = 0; i < numberOfTitles; i++) {
        CKSelectionTopBarItem * item = [[CKSelectionTopBarItem alloc]init];
        NSString * title = _titlesArray[i];
        item.title = title;
        item.width = ([title sizeForFont:_font size:CGSizeMake(MAXFLOAT, kCKTopBarHeight - 2 * kCKNormalSpace) mode:NSLineBreakByWordWrapping].width + 3.4 * kCKNormalSpace);
        totalWidth += item.width;
        item.font = _font;
        item.selectedFont = _selectedFont;
        item.showBottomLine = _showBottomLine;
        item.selectedColor = _selectedColor;
        item.selectedNightColor = _selectedNightColor;
        item.nightColor = _nightColor;
        item.normalColor = _normalColor;
        item.backgroundColor = [UIColor whiteColor];
        item.isNotScale = _isNotScale;
        if (_selectedBorderColor) {
            item.selectedBorderColor = _selectedBorderColor;
            item.isNotScale = YES;
        }
        [_topBarItems addObject:item];
    }
    if (totalWidth < self.collectionView.frame.size.width) {
        //宽度不够自动填充
        _addWidth = (self.collectionView.frame.size.width - totalWidth) / (CGFloat)numberOfTitles;
    } else {
        _addWidth = 0;
    }
}

#pragma mark - Public API

- (void)reloadData {
    if (!_titlesArray) {
        return;
    }
    [self calculateWidth];
    [self.collectionView reloadData];
    [self setIndex:self.selectedIndex animated:YES];
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray.copy;
    [self reloadData];
}

- (void)setIndex:(NSUInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    @try{
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    @catch (NSException * exception){}
    @finally{};
}

- (NSString *)selectedTitle {
    return [_titlesArray objectOrNilAtIndex:_selectedIndex];
}

- (void)setLeftView:(UIView *)leftView {
    if (_leftView) {
        [_leftView removeFromSuperview];
    }
    _leftView = leftView;
    [self insertSubview:_leftView belowSubview:_link];
    [self setupLayout];
    [self reloadData];
}

- (void)setRightView:(UIView *)rightView {
    if (_rightView) {
        [_rightView removeFromSuperview];
    }
    _rightView = rightView;
    [self insertSubview:_rightView belowSubview:_link];
    [self setupLayout];
    [self reloadData];
}

- (void)setLeftViewMode:(CKSelectionViewMode)leftViewMode {
    _leftViewMode = leftViewMode;
    [self setupLayout];
    [self reloadData];
}

- (void)setRightViewMode:(CKSelectionViewMode)rightViewMode {
    _rightViewMode = rightViewMode;
    [self setupLayout];
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate/DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _topBarItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CKSelectionTopBarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCKSelectionTopBarCell forIndexPath:indexPath];
    cell.item = [_topBarItems objectOrNilAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndex == indexPath.row) {
        cell.selected = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndex != indexPath.row) {
        _selectedIndex = indexPath.row;
        [self setIndex:_selectedIndex animated:YES];
        if ([_delegate respondsToSelector:@selector(selectionTopBar:clickAtIndex:)]) {
            [_delegate selectionTopBar:self clickAtIndex:_selectedIndex];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CKSelectionTopBarItem * item = [_topBarItems objectOrNilAtIndex:indexPath.row];
    return CGSizeMake(item.width + _addWidth, kCKTopBarHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

@end

