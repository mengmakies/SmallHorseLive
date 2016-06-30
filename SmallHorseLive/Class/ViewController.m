//
//  ViewController.m
//  UCloudDemo
//
//  Created by 江南孤鹜 on 16/6/20.
//  Copyright © 2016年 Martin. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "UserCacheManager.h"
#import "ChatUIHelper.h"
#import "CreateGroupViewController.h"
#import "LiveGroupTableViewCell.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginViewController.h"

NSString *const CellWithIdentifier = @"Cell";

@interface ViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLogin;
    __weak IBOutlet UITableView *_tableView;
    NSArray *_myGroups;
    __weak IBOutlet UIButton *_btnCreateGroup;
    __weak IBOutlet UIButton *_btnLogout;
    __weak IBOutlet UIButton *_btnLogin;
    __weak IBOutlet UIImageView *_imgMain;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _isLogin = [EMClient sharedClient].isLoggedIn;
    
    if (!_isLogin) {
        self.title = @"小马直播间";
        [self showHint:@"请先登录环信~"];
        
        _tableView.hidden = YES;
        _btnCreateGroup.hidden = YES;
        _btnLogout.hidden = YES;
        _btnLogin.hidden = NO;
        _imgMain.hidden = NO;
        
    }else{
        
        self.title = [NSString stringWithFormat:@"小马直播间(%@)", [EMClient sharedClient].currentUsername];
        
        _tableView.hidden = NO;
        _btnCreateGroup.hidden = NO;
        _btnLogout.hidden = NO;
        _btnLogin.hidden = YES;
        _imgMain.hidden = YES;
        
        // 加载与用户相关的群
        [self loadGroupsData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"小马直播间";
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LiveGroupTableViewCell class]) bundle:nil] forCellReuseIdentifier:CellWithIdentifier];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMGroup *group = [_myGroups objectAtIndex:indexPath.row];
    ChatViewController *vc = [[ChatViewController alloc]initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    vc.title = group.subject;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_myGroups) {
        return _myGroups.count;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveGroupTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellWithIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LiveGroupTableViewCell  alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    
    cell.GroupData = [_myGroups objectAtIndex:indexPath.row];
    
    return cell;
}

// 加载直播群数据
-(void)loadGroupsData{
    
    // 从服务器获取与我相关的群组列表
    EMError *error = nil;
    _myGroups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    if (error) {
        NSLog(@"获取失败 -- %@",error.description);
        return;
    }
    
    [_tableView reloadData];
}

// 创建直播群
- (IBAction)onClickCreateGroup:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 预先获取联系人列表，自动保存在内存中，否则创建群组里的【添加成员】页面无法显示联系人
        [[EMClient sharedClient].contactManager getContactsFromServerWithError:nil];
    });
    
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createChatroom animated:YES];
}
- (IBAction)doLogout:(id)sender {
    if (_isLogin) {
        _isLogin = NO;
        
        _tableView.hidden = YES;
        _btnCreateGroup.hidden = YES;
        _btnLogout.hidden = YES;
        _btnLogin.hidden = NO;
        _imgMain.hidden = NO;
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            
            [self showHint:@"已经退出登录~"];
            NSLog(@"退出成功");
            
            [self doLogin:nil];
        }
    }
}
- (IBAction)doLogin:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
