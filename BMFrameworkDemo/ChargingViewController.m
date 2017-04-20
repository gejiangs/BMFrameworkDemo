//
//  ChargingViewController.m
//  BMFrameworkDemo
//
//  Created by 郭江 on 2017/4/18.
//  Copyright © 2017年 郭江. All rights reserved.
//

#import "ChargingViewController.h"
#import "BluetoothManager.h"

@interface ChargingViewController ()

@property (nonatomic, strong)   UIButton *startButton;
@property (nonatomic, strong)   UIButton *againButton;
@property (nonatomic, strong)   UILabel *valueLabel;

@end

@implementation ChargingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Charging";
    [self initUI];
}

-(void)initUI
{
    self.startButton = [self.view addButtonWithTitle:@"Start" target:self action:@selector(startAction)];
    [_startButton makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.valueLabel = [self.view addLabelWithText:@"" color:[UIColor blackColor]];
    _valueLabel.numberOfLines = 0;
    [_valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.againButton = [self.view addButtonWithTitle:@"Again" target:self action:@selector(againAction)];
    [_againButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_valueLabel.bottom).offset(30);
    }];
    
    self.valueLabel.hidden = YES;
    self.againButton.hidden = YES;
}

-(void)startAction
{
    if ([BluetoothManager shareManager].state != ConnectStateConnect) {
        [self.view showToastText:@"UnConnected"];
        return;
    }
    [[BMManager sharedManager] sendIdlingVoltageTest:^{
        self.startButton.hidden = YES;
        self.valueLabel.hidden = NO;
        [self stepTimeout:5];
    }];
}

-(void)againAction
{
    self.startButton.hidden = NO;
    self.valueLabel.hidden = YES;
    self.againButton.hidden = YES;
}

-(void)stepTimeout:(NSInteger)count
{
    if (count == 0) {
        self.valueLabel.text = @"Test...";
        [[BMManager sharedManager] sendHighVoltageTest:^(NSDictionary *dict) {
            [self showResult:dict];
        }];
    }else{
        self.valueLabel.text = [NSString stringWithFormat:@"%dS", (int)count];
        
        dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(time_t, dispatch_get_main_queue(), ^{
            
            [self stepTimeout:count-1];
        });
    }
}

-(void)showResult:(NSDictionary *)dict
{
    self.againButton.hidden = NO;
    self.valueLabel.text = [dict description];
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
