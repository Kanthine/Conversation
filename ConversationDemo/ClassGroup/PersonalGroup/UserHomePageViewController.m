//
//  UserHomePageViewController.m
//  FM
//
//  Created by 苏沫离 on 2020/3/3.
//  Copyright © 2020 苏沫离. All rights reserved.
//


#define HeaderBookIdentifer @"BookTableSectionHeaderView"
#define CellBookIdentifer @"BookTableCell"

#import "UserHomePageViewController.h"
#import "UserHomeView.h"
#import "BookTableCell.h"
#import "ConversationViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD+CustomView.h"
#import "YLReadTextParser.h"
#import "YLReadController.h"


@interface UserHomePageViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) FMNavbarView *navBarView;
@property (nonatomic ,strong) UserHomeTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UserManager *userModel;
@property (nonatomic ,strong) NSMutableArray<BookModel *> *booksArray;

@end

@implementation UserHomePageViewController

#pragma mark - life cycle

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navBarView];
    
    [BookModel getBooks:^(NSMutableArray<BookModel *> *bookArray) {
        self.booksArray = bookArray;
        [self.tableView reloadData];
    }];
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navBarView.backButton.hidden = YES;
        [self.tableHeaderView reloadData:UserManager.shareUser];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetWorkRequest];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - response click

-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nickNameButtonClick{
    if ([self.userId isEqualToString:UserManager.shareUser.userId]) {
        [MySetNickNameAlertView showWithBlock:^(NSString * _Nonnull nickname) {
            
        }];
    }
}

#pragma mark - tableViewDelegate

- (void)scrollViewDidScroll:(UITableView *)tableView{
    if (tableView.contentOffset.y > (CGRectGetHeight(tableView.tableHeaderView.frame) - 170)) {
        self.navBarView.titleLable.hidden = NO;
        self.navBarView.backgroundColor = [UIColor colorWithRed:254/255.0 green:175/255.0 blue:113/255.0 alpha:1.0];
    }else{
        self.navBarView.titleLable.hidden = YES;
        self.navBarView.backgroundColor = [UIColor colorWithRed:254/255.0 green:175/255.0 blue:113/255.0 alpha:0.0];
    }
    [self.tableHeaderView updateLayoutByOffset:tableView.contentOffset.y];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.booksArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BookTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderBookIdentifer];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellBookIdentifer];
    cell.book = self.booksArray[indexPath.row];;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookModel *book = self.booksArray[indexPath.row];
    NSLog(@"path ------------------- %@",book.filePath);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在解析...";
    YLReadModel *readModel = [YLReadTextParser parserWithURL:book.fileUrl];
    [hud hideAnimated:YES];
    
    YLReadController *readVC = [[YLReadController alloc] init];
    readVC.hidesBottomBarWhenPushed = YES;
    readVC.readModel = readModel;
    [self.navigationController pushViewController:readVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"上传头像...";
    [AFNetAPIClient uploadImage:image success:^(NSString * _Nonnull url) {
        UserManager.shareUser.headPath = url;
        [UserManager.shareUser save];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableHeaderView reloadData:UserManager.shareUser];
            [hud hideAnimated:YES];
        });
    } error:^(NSString * _Nonnull error) {
        [hud hideAnimated:YES];
        [self.view makeToast:error duration:3 position:CSToastPositionCenter];
    }];
    
}

//头像
- (void)updateUserHeaderImageClick{
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf photoPickerClick];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf photoAlbumClick];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//拍照
- (void)photoPickerClick{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//相册
- (void)photoAlbumClick{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - network

- (void)loadNetWorkRequest{
    
}

#pragma mark - setter and getters

- (FMNavbarView *)navBarView{
    if (_navBarView == nil) {
        _navBarView = [[FMNavbarView alloc] init];
        _navBarView.backgroundColor = [UIColor colorWithRed:254/255.0 green:175/255.0 blue:113/255.0 alpha:0.0];
        [_navBarView.backButton addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        _navBarView.titleLable.hidden = YES;
    }
    return _navBarView;
}

- (UserHomeTableHeaderView *)tableHeaderView{
    if(_tableHeaderView == nil){
        _tableHeaderView = [[UserHomeTableHeaderView alloc]init];
        [_tableHeaderView.nickNameButton addTarget:self action:@selector(nickNameButtonClick) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        _tableHeaderView.tapPortraitClick = ^{
            if ([weakSelf.userId isEqualToString:UserManager.shareUser.userId]) {
                [weakSelf updateUserHeaderImageClick];
            }
        };
    }
    return _tableHeaderView;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(UIScreen.mainScreen.bounds)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        tableView.sectionHeaderHeight = 50;
        tableView.rowHeight = kBookTableCellHeight;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:BookTableCell.class forCellReuseIdentifier:CellBookIdentifer];
        [tableView registerClass:BookTableSectionHeaderView.class forHeaderFooterViewReuseIdentifier:HeaderBookIdentifer];
        tableView.tableHeaderView = self.tableHeaderView;

        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, isIPhoneNotchScreen() ? 34 : 0, 0);
        }
        
        _tableView = tableView;
    }
    return _tableView;
}

@end
