//
//  ConversationBackSetViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/28.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"ChatBackListCollectionViewCell"



#import "ConversationBackSetViewController.h"
#import "UIBarButtonItem+LeftBarItem.h"

@interface ChatBackListCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,assign) BOOL isCurrentImage;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIImageView *statueImageView;
@end

@implementation ChatBackListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.bottomView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 20, CGRectGetWidth(self.bounds), 20);
    self.statueImageView.center = CGPointMake(CGRectGetWidth(self.bottomView.bounds) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0);
}

- (void)setIsCurrentImage:(BOOL)isCurrentImage{
    _isCurrentImage = isCurrentImage;
    if (isCurrentImage) {
        self.bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:122/255.0 blue:151/255.0 alpha:1.0];
        self.statueImageView.image = [UIImage imageNamed:@"conversation_back_selected"];
    }else{
        self.statueImageView.image = nil;
        self.bottomView.backgroundColor = UIColor.clearColor;
    }
}

#pragma mark - setter and getter

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        [_bottomView addSubview:self.statueImageView];
    }
    return _bottomView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

//conversation_back_selected
//conversation_back_download
- (UIImageView *)statueImageView{
    if (_statueImageView == nil) {
        _statueImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conversation_back_download"]];
        _statueImageView.frame = CGRectMake(0, 0, 12, 12);
    }
    return _statueImageView;
}

@end







NSString * const kChatBackImageKey = @"com.chatBack.imgae";

@interface ConversationBackSetViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSString *selectedName;
@end

@implementation ConversationBackSetViewController
@synthesize selectedName = _selectedName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择背景图";
    [self.view addSubview:self.collectionView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftBackItemWithTarget:self action:@selector(leftBarButtonItemClick)];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - response click

- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatBackListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    NSString *imageName = self.dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.isCurrentImage = [self.selectedName isEqualToString:imageName];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedName = self.dataArray[indexPath.row];
    [collectionView reloadData];
}

#pragma mark - setter and getter

- (void)setSelectedName:(NSString *)selectedName{
    _selectedName = selectedName;
    [NSUserDefaults.standardUserDefaults setValue:selectedName forKey:kChatBackImageKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)selectedName{
    if (_selectedName == nil) {
        _selectedName = [NSUserDefaults.standardUserDefaults objectForKey:kChatBackImageKey];
    }
    return _selectedName;
}


- (NSMutableArray<NSString *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 9; i ++) {
            [_dataArray addObject:[NSString stringWithFormat:@"conversation_back_%d",i]];
        }
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat margin = 12.0f;//外边距
        CGFloat padding = 8.0f;//内边距
        CGFloat itemWidth = (CGRectGetWidth(UIScreen.mainScreen.bounds) - margin * 2 - padding * 2.0) / 3.0f;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumInteritemSpacing = 6.0;
        layout.minimumLineSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(UIScreen.mainScreen.bounds) ,CGRectGetHeight(UIScreen.mainScreen.bounds)) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithRed:246/255.0 green:243/255.0 blue:244/255.0 alpha:1.0];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:ChatBackListCollectionViewCell.class forCellWithReuseIdentifier:CellIdentifer];
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
