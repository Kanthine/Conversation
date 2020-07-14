//
//  ConversationEmojiContentView.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#define CellIdentifer @"ConversationEmojiCollectionCell"
#define SectionHeaderIdentifer @"ConversationEmojiCollectionTitleSectionView"


#import "ConversationEmojiContentView.h"




@interface ConversationEmojiCollectionTitleSectionView : UICollectionReusableView
@property (nonatomic ,strong) UILabel *titleLable;
@end
@implementation ConversationEmojiCollectionTitleSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:10];
        _titleLable.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLable];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLable.frame = CGRectMake(2, (CGRectGetHeight(self.bounds) - 16)/2.0, 100, 16);
}
@end

@interface ConversationEmojiCollectionCell : UICollectionViewCell
@property (nonatomic ,strong) UIImageView *imageView;
@end
@implementation ConversationEmojiCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
@end









@interface ConversationEmojiContentView ()
<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NSMutableArray<UIImage *> *recentlyDataArray;
@property (nonatomic ,strong) NSMutableArray<UIImage *> *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end


@implementation ConversationEmojiContentView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:249/255.0 alpha:1];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)showContentSize:(CGSize)contentSize toolsHeight:(CGFloat)toolsHeight{
    self.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    self.collectionView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height - toolsHeight);
    [self.collectionView reloadData];
}

- (void)loadEmojiData:(NSMutableArray *)dataArray{
    self.dataArray = [dataArray mutableCopy];
    [self.collectionView reloadData];
}

- (void)reloadRecentlyData:(NSMutableArray *)recentlyData{
    self.recentlyDataArray = [recentlyData mutableCopy];
    if (self.collectionView.numberOfSections == 2) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }else{
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.recentlyDataArray.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.recentlyDataArray.count > 0 && section == 0) {
        return self.recentlyDataArray.count;
    }
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.recentlyDataArray.count > 0) {
        return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 20);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader && self.recentlyDataArray.count > 0) {
       ConversationEmojiCollectionTitleSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderIdentifer forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLable.text = @"最近使用";
        }else{
            headerView.titleLable.text = @"全部";
        }
        return headerView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConversationEmojiCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    if (self.recentlyDataArray.count > 0 && indexPath.section == 0) {
        cell.imageView.image = self.recentlyDataArray[indexPath.row];
    }else{
        cell.imageView.image = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        UIImage *image = nil;
        if (self.recentlyDataArray.count > 0 && indexPath.section == 0) {
            image = [self.recentlyDataArray[indexPath.row] copy];
        }else{
            image = [self.dataArray[indexPath.row] copy];
        }
        [self.delegate didSelectItem:image];
    }
}

#pragma mark - getter and setter

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30, 30);
        layout.minimumLineSpacing = 12;//上下间距
        layout.minimumInteritemSpacing = 16;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.contentInset = UIEdgeInsetsMake(8, 16, 8, 16);
        collectionView.backgroundColor = UIColor.clearColor;
        [collectionView registerClass:ConversationEmojiCollectionCell.class forCellWithReuseIdentifier:CellIdentifer];
        [collectionView registerClass:ConversationEmojiCollectionTitleSectionView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderIdentifer];
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
