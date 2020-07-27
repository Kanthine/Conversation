//
//  ConversationViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationModel.h"
#import "UIScrollView+RefreshManager.h"
#import "ConversationTableTextCell.h"
#import "ConversationTableImageCell.h"
#import "ConversationInputBar.h"
#import "WebSocketClient.h"
#import "UIBarButtonItem+LeftBarItem.h"
#import "UserHomePageViewController.h"
#import "AFNetAPIClient.h"
#import "ConversationUserModel.h"

@interface ConversationViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) int currentPage;
@property (nonatomic ,strong) NSMutableArray<ConversationModel *> *dataArray;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) ConversationInputBar *inputBar;//输入框
@property (nonatomic ,strong) ConversationUserModel *targetUser;

@end

@implementation ConversationViewController


- (instancetype)initWithTargetUser:(ConversationUserModel *)target{
    self = [super init];
    if (self) {
        self.targetUser = target;
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftBackItemWithTarget:self action:@selector(leftBarButtonItemClick)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputBar];
    
    self.navigationItem.title = self.targetUser.nickName;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(socketReceiveMessageNotification:) name:kSocketReceiveMessageNotification object:nil];
    
    [ConversationModel getModelsWithTarget:self.targetUser complete:^(NSMutableArray<ConversationModel *> * _Nonnull modelsArray) {
        self.dataArray = modelsArray;
         [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self loadNetWorkRequest];
}

- (void)socketReceiveMessageNotification:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    [self insertConversationMessage:dict];
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
    ConversationTableBaseCell *cell = [ConversationTableBaseCell tableView:tableView cellAtIndexPath:indexPath cellForModel:model];
    cell.tapPortraitClick = ^{
        UserHomePageViewController *userVC = [[UserHomePageViewController alloc] initWithUserId:model.fromID];
        [self.navigationController pushViewController:userVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel *model = self.dataArray[indexPath.row];
    if (model.type == ConversationType_TEXT) {
        
    }
    

}

#pragma mark - private methods

- (void)loadNetWorkRequest{
//    NSString *lastMsgDate = self.dataArray.firstObject.sendDate;
//    if (lastMsgDate == nil || self.currentPage == 1) {
//        lastMsgDate = @"";
//    }

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

//{"content":"收得到？","fromHeaderPath":"/pic/1594721397551-939/1594721397551-939.jpg","fromID":"1594721397551-939","fromName":"Alan","group":false,"msgType":"Text","toHeaderPath":"/pic/1594972271962-364/1594972271962-364.jpg","toID":"1594972271962-364","toName":"774792381@qq.com"}

- (void)sendMessageWithText:(NSString *)text msgType:(ConversationType)type{
    NSDictionary *dict = @{@"msgType":  type == ConversationType_TEXT ? @"Text" : @"Image",
                            @"group": @(self.targetUser.isGroup),
                            @"content":text,
                            @"fromID":UserManager.shareUser.userId,
                            @"toID":self.targetUser.userId};
     [WebSocketClient.shareClient sendData:dict];
     [self insertConversationMessage:dict];
}

- (void)insertConversationMessage:(NSDictionary *)dict{
    ConversationModel *model = [ConversationModel modelObjectWithDictionary:dict];
    [ConversationModel insertModel:model];
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
        tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//        __weak typeof(self) weakSelf = self;
//        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakSelf.currentPage ++;
//            [weakSelf loadNetWorkRequest];
//        }];
        [ConversationTableBaseCell regisCellForTableView:tableView];
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
            [weakSelf sendMessageWithText:text msgType:ConversationType_TEXT];
        };
        
        _inputBar.sendImageHandle = ^(UIImage * _Nonnull image) {
            [AFNetAPIClient uploadImage:image success:^(NSString * _Nonnull url) {
                
                [weakSelf sendMessageWithText:url msgType:ConversationType_IMAGE];
            } error:^(NSString * _Nonnull error) {
                
            }];
        };
    }
    return _inputBar;
}

@end
