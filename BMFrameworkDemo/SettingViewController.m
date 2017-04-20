//
//  SettingViewController.m
//  BMFrameworkDemo
//
//  Created by 郭江 on 2017/4/18.
//  Copyright © 2017年 郭江. All rights reserved.
//

#import "SettingViewController.h"
#import "BluetoothManager.h"

@interface SettingViewController ()

@property (nonatomic, strong)   UIButton *checkButton;
@property (nonatomic, strong)   UITextView *textView;
@property (nonatomic, strong)   UIProgressView *progressView;
@property (nonatomic, strong)   UIButton *startButton;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Setting";
    
    [self initUI];
}

-(void)initUI
{
    self.checkButton = [self.view addButtonWithTitle:@"Check New Firmware" target:self action:@selector(checkAction)];
    [_checkButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_checkButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_checkButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    self.textView = [self.view addTextViewWithDelegate:nil fontSize:17];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkButton.bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(200);
    }];
    _textView.backgroundColor = [UIColor grayColor];
    
    self.progressView = [[UIProgressView alloc] init];
    [self.view addSubview:_progressView];
    [_progressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    self.startButton = [self.view addButtonWithTitle:@"Start Upgrade" target:self action:@selector(startAction)];
    [_startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_startButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressView.bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    self.progressView.hidden = YES;
    self.startButton.hidden = YES;
}

-(void)checkAction
{
    if ([BluetoothManager shareManager].state != ConnectStateConnect) {
        [self.view showToastText:@"UnConnected"];
        return;
    }
    [self.view showActivityView:@"Loading..."];
    [[BMManager sharedManager] checkHardwareUpgradeWithBlock:^(BOOL hasNew, NSDictionary *upgradeData) {
        [self.view hiddenActivityView];
        if (hasNew) {
            self.textView.text = [NSString stringWithFormat:@"version:%@\nlog:%@", upgradeData[@"version"], upgradeData[@"log"]];
            
            self.progressView.hidden = NO;
            self.startButton.hidden = NO;
        }else{
            self.textView.text = @"No new version";
        }
    }];
}

-(void)startAction
{
    if ([BluetoothManager shareManager].state != ConnectStateConnect) {
        [self.view showToastText:@"UnConnected"];
        return;
    }
    self.startButton.enabled = NO;
    [self.view showActivityView:@"Loading..."];
    [[BMManager sharedManager] firmwareUpgradeWithProgress:^(float progress) {
        [self.view hiddenActivityView];
        self.progressView.progress = progress;
        if (progress == 1) {
            self.startButton.enabled = YES;
            [self.view showToastText:@"Upgrade Success"];
        }
    } failure:^{
        [self.view hiddenActivityView];
        self.startButton.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
