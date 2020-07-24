//
//  UserHomePageViewController.m
//  FM
//
//  Created by 苏沫离 on 2020/3/3.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define SubscribeCellIdentifer @"UserHomeTableSubscribeCell"

#import "UserHomePageViewController.h"
#import "GlobalTools.h"
#import "UserHomeView.h"
#import "UserHomeCell.h"



@interface UserHomePageViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) FMNavbarView *navBarView;
@property (nonatomic ,strong) UserHomeTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UserManager *userModel;
@property (nonatomic ,strong) NSMutableArray<NSString *> *booksArray;
@property (nonatomic ,strong) NSMutableArray<NSString *> *userArray;

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
    [self loadNetWorkRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

-(void)moreAction:(UIButton *)button{
    
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
    return 1 + self.userArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        if (self.booksArray.count) {
            return 52 + 72 * self.booksArray.count + 12;
        }
        return 0.1;
    }else{
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UserHomeTableBookCell *cell = [tableView dequeueReusableCellWithIdentifier:SubscribeCellIdentifer];
        cell.dataArray = self.booksArray;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    }
    return _tableHeaderView;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(UIScreen.mainScreen.bounds)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:UserHomeTableBookCell.class forCellReuseIdentifier:SubscribeCellIdentifer];
//        [tableView registerClass:DubListCell.class forCellReuseIdentifier:kDubCell_UserHome_Identifier];
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
