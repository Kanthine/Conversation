//
//  ConversationViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//
#define Cell_Text_Identifer @"ConversationTableTextCell"
#define Cell_Seats_Identifer @"ConversationTableSeatsCell"

#import "ConversationViewController.h"
#import "ConversationModel.h"
#import "UIScrollView+RefreshManager.h"
#import "ConversationTableTextCell.h"
#import "ConversationInputBar.h"
#import "WebSocketClient.h"
#import "UIBarButtonItem+LeftBarItem.h"
#import "GlobalTools.h"
#import "UserManager.h"
#import <UIImageView+WebCache.h>
#import "UserHomePageViewController.h"


@interface ConversationViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) int currentPage;
@property (nonatomic ,strong) NSMutableArray<ConversationModel *> *dataArray;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) ConversationInputBar *inputBar;//输入框
@property (nonatomic ,strong) WebSocketClient *socketClient;

@property (nonatomic ,strong) NSString *targetID;

@end

@implementation ConversationViewController

- (instancetype)init{
    return [self initWithTargetID:@"happy_group"];
}

- (instancetype)initWithTargetID:(NSString *)targetID{
    self = [super init];
    if (self) {
        if ([targetID isEqualToString:@"happy_group"]) {
            self.isGroup = YES;
        }
        self.targetID = targetID;
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    _isGroup = YES;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftBackItemWithTarget:self action:@selector(leftBarButtonItemClick)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputBar];
    [self socketClient];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self loadNetWorkRequest];
}

#pragma mark - response click

- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataArray[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel *model = self.dataArray[indexPath.row];
    if (model.type == ConversationType_TEXT) {
        ConversationTableTextCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Text_Identifer forIndexPath:indexPath];
        if (model.direction == ConversationDirection_SEND) {
            [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:UserManager.shareUser.headPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
        }else{
            [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:UserManager.shareUser.headPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
        }
        cell.model = model;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel *model = self.dataArray[indexPath.row];
    if (model.type == ConversationType_TEXT) {
        
    }
    
    UserHomePageViewController *userVC = [[UserHomePageViewController alloc] initWithUserId:self.targetID];
    [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark - private methods

- (void)loadNetWorkRequest{
//    NSString *lastMsgDate = self.dataArray.firstObject.sendDate;
//    if (lastMsgDate == nil || self.currentPage == 1) {
//        lastMsgDate = @"";
//    }
//
//    [HttpManagerTool postWithPath:message_privateInfo params:@{@"pageSize":@(20),@"pageNo":@(self.currentPage),@"shopNo":self.shopModel.shopNo, @"lastMsgDate":lastMsgDate} success:^(id JSON) {
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
//        NSMutableArray *resultArray;
//        if ([responseDict[@"code"] isEqualToString:@"SUCCESS"]){
//            [self.shopModel parserObjectWithDictionary:responseDict[@"data"]];
//            NSArray *priList = responseDict[@"data"][@"twoMsg"];
//
//            if (priList && [priList isKindOfClass:[NSArray class]]) {
//                resultArray = [NSMutableArray arrayWithCapacity:priList.count];
//                [priList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    ConversationModel *model = [ConversationModel modelObjectWithDictionary:obj];
//                    [resultArray insertObject:model atIndex:0];
//                }];
//
//                if (self.currentPage > 1) {
//                    [resultArray addObjectsFromArray:self.dataArray];
//                }
//                self.dataArray = resultArray;
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.navigationItem.title = self.shopModel.shopName;
//                    [self.tableView reloadData];
//                    if (self.currentPage == 1) {
//                        [self tableViewScrollToBottom:0.0];
//                    }
//                });
//            }
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
////                kPE(responseDict[@"message"]);
//            });
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (resultArray && resultArray.count < 20 * self.currentPage) {
//                self.tableView.mj_header = nil;
//                self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
//            }
//        });
//
//    } failure:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//    }];
}

- (void)insertConversationMessage:(NSDictionary *)dict{
    ConversationModel *model = [[ConversationModel alloc] init];
    model.sendDate = dict[@"sendDate"];
    model.sendUserId = dict[@"fromID"];
    model.receUserId = dict[@"toID"];
    model.content = dict[@"content"];
    model.msgId = dict[@"msgId"];
    model.isGroup = [dict[@"isGroup"] boolValue];
    model.messageType = dict[@"msgType"];
    [model parserExtraInfo];
    NSLog(@"model ==== %@",model);
    [self.dataArray addObject:model];
    [self.tableView reloadData];
    if (model.direction == ConversationDirection_RECEIVE) {
        [self tableViewScrollToBottom:0.0];
    }
}

- (void)tableViewScrollToBottom:(CGFloat)duration{
    if (self.dataArray.count < 1) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    if (duration == 0.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }else{
        [UIView animateWithDuration:duration animations:^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - setter and getters

- (NSMutableArray<ConversationModel *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WebSocketClient *)socketClient{
    if (_socketClient == nil) {        
        _socketClient = [[WebSocketClient alloc] init];
        [_socketClient openSocketWithURL:getSocketLink() heartBeat:@{}];
        __weak typeof(self) weakSelf = self;
        _socketClient.receivedMessage = ^(NSDictionary * _Nonnull dict) {
//            [weakSelf insertConversationMessage:dict];
        };
    }
    return _socketClient;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), getPageSafeAreaHeight(YES) - CGRectGetHeight(self.inputBar.frame)) style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 70.0f;
        tableView.sectionFooterHeight = 0.1f;
        [tableView registerClass:ConversationTableTextCell.class forCellReuseIdentifier:Cell_Text_Identifer];
        tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        __weak typeof(self) weakSelf = self;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage ++;
            [weakSelf loadNetWorkRequest];
        }];
        tableView.autoHiddenFooter = YES;
        _tableView = tableView;
    }
    return _tableView;
}

//页面底部键盘输入框
- (ConversationInputBar *)inputBar{
    if (_inputBar == nil) {
        _inputBar = [[ConversationInputBar alloc]init];
        __weak typeof(self) weakSelf = self;
        _inputBar.frameChangeHandle = ^(CGRect frame, CGFloat duration) {
            weakSelf.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),frame.origin.y);
            [weakSelf tableViewScrollToBottom:duration];
        };

        _inputBar.sendCommentHandle = ^(NSString * _Nonnull text) {
            NSDictionary *dict = @{@"msgType": @"Text",
                                   @"isGroup": @(weakSelf.isGroup),
                                   @"content":text,
                                   @"fromID":UserManager.shareUser.userId,
                                   @"toID":weakSelf.targetID};
            [weakSelf.socketClient sendString:text];
            [weakSelf insertConversationMessage:dict];
        };
    }
    return _inputBar;
}

@end
