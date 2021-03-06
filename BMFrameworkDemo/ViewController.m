//
//  ViewController.m
//  BMFrameworkDemo
//
//  Created by 郭江 on 2017/4/14.
//  Copyright © 2017年 郭江. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothManager.h"

@interface ViewController ()<BMManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索蓝牙";
    
    [BMManager sharedManager].delegate = self;
    [self addRightBarTitle:@"搜索" target:self action:@selector(searchBlue)];
}

-(void)addRightBarTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:action];
    self.navigationItem.rightBarButtonItem = button;
}

-(void)searchBlue
{
    [[BluetoothManager shareManager] startScanBlueBlock:^(CBPeripheral *peripheral) {
        NSLog(@"搜索到蓝牙,开始连接");
       [[BluetoothManager shareManager] connect:peripheral block:^(BOOL success) {
           NSLog(@"连接成功");
       }];
    }];
}

#pragma mark - BMManager Delegate
-(void)BMManagerDeviceMAC:(NSString *)mac
{
    NSLog(@"mac:%@", mac);
}


-(void)BMManagerDeviceIsGenuine:(BOOL)isGenuine
{
    NSLog(@"isGenuine:%d", isGenuine);
}


-(void)BMManagerReceiveStartupData:(NSDictionary *)dict
{
    NSLog(@"StartupData:%@", dict);
}


-(void)BMManagerRealtimeData:(NSDictionary *)dict
{
    NSLog(@"realtimeData:%@", dict);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
