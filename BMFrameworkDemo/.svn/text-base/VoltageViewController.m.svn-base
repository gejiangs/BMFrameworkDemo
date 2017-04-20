//
//  VoltageViewController.m
//  BMFrameworkDemo
//
//  Created by 郭江 on 2017/4/18.
//  Copyright © 2017年 郭江. All rights reserved.
//

#import "VoltageViewController.h"
#import "FYChartView.h"
#import "BluetoothManager.h"

@interface VoltageViewController ()<FYChartViewDelegate, FYChartViewDataSource, BMManagerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong)   BluetoothManager *blueManager;
@property (weak, nonatomic) IBOutlet UILabel *lenLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong)   FYChartView *lineChartView;
@property (nonatomic, strong)   NSMutableArray *contentList;


@end

@implementation VoltageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI
{
    self.blueManager = [BluetoothManager shareManager];
    self.navigationItem.title = @"Voltage";
    [BMManager sharedManager].delegate = self;
    [self addRightBarTitle:@"UnConnect" target:self action:@selector(rightAction)];
    
    self.lineChartView = [[FYChartView alloc] init];
    _lineChartView.backgroundColor = [UIColor clearColor];
    _lineChartView.rectangleLineColor = RGB(134, 134, 134);
    _lineChartView.maxVerticalValue = 15.f;
    _lineChartView.lineColor = RGB(244, 93, 17);
    _lineChartView.lineWidth = 2.f;
    _lineChartView.dataSource = self;
    _lineChartView.minValueCount = 300;
    _lineChartView.customVerticalScale = YES;
    [self.view addSubview:_lineChartView];
    [_lineChartView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.height.offset(180);
        make.left.offset(10);
        make.right.offset(-10);
    }];
}


-(void)rightAction
{
    [self.view showActivityView:@"Search..."];
    [self.blueManager startScanBlock:^(NSArray *peripheralArray) {
        
    } finally:^{
        if ([self.blueManager.peripheralArray count] == 0) {
            [self.view hiddenActivityView];
            [self.view showToastText:@"Not Find"];
        }else{
            [self.view showActivityView:@"Connect..."];
            [self.blueManager connect:[self.blueManager.peripheralArray firstObject] block:^(BOOL success) {
                [self.view hiddenActivityView];
                if (success) {
                    [self.view showToastText:@"Connected"];
                    NSLog(@"连接成功");
                    [self addRightBarTitle:@"Connected" target:self action:@selector(disConnectAction)];
                }
            }];
        }
    }];
}
- (IBAction)readLenAction:(UIButton *)sender
{
    if (self.blueManager.state != ConnectStateConnect) {
        [self.view showToastText:@"UnConnected"];return;
    }
    
    [self.view showActivityView:@"Loading..."];
    [[BMManager sharedManager] readHistoryLength:^(int len) {
        [self.view hiddenActivityView];
        self.lenLabel.text = [NSString stringWithFormat:@"History len:%d", len];
    }];
}
- (IBAction)readHistoryAction:(UIButton *)sender
{
    UITextView *textView = [self.view viewWithTag:999];
    [self.view showActivityView:@"Loading..."];
    textView.text = @"";
    NSMutableArray *vols = [NSMutableArray array];
    [[BMManager sharedManager] readVoltageWithDate:[NSDate date] completeBlock:^(BOOL isEnd, NSArray *voltageArray) {
        [vols addObjectsFromArray:voltageArray];
        if (isEnd) {
            [self.view hiddenActivityView];
        }
        NSMutableString *t = [NSMutableString string];
        for (NSDictionary *item in vols) {
            [t appendFormat:@"voltage:%@==status:%@\n", item[@"voltage"], item[@"status"]];
        }
        
        
        textView.text = t;
        
        NSLog(@"vols:%@", voltageArray);
    }];
}

-(void)disConnectAction
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Disconnecting Bluetooth ?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Bluetooth Disconnected" otherButtonTitles:nil, nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.blueManager cancelCurrentPeripheralConnection];
        [self addRightBarTitle:@"UnConnect" target:self action:@selector(rightAction)];
    }
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveStartupData" object:dict];
}


-(void)BMManagerRealtimeData:(NSDictionary *)dict
{
    if (self.contentList == nil) {
        self.contentList = [NSMutableArray array];
    }
    [self.contentList addObject:dict];
    
    //最多只存储5分钟的数据（1秒钟一条数据，5分钟300条数据）
    if ([self.contentList count] >= 300) {
        [self.contentList removeObjectsInRange:NSMakeRange(0, 60)];
    }
    [self.lineChartView reloadData];
    
//    NSLog(@"realtimeData:%@", dict);
}

-(void)BMManagerDeviceFirmwareVersion:(int)version
{
    NSLog(@"current firmware version:%d", version);
}

#pragma mark FYChartView DataSource
//number of value count
- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;
{
    return [self.contentList count];
}

//value at index
- (float)chartView:(FYChartView *)chartView valueAtIndex:(NSInteger)index
{
    NSDictionary *item = [self.contentList objectAtIndex:index];
    return MIN([[item objectForKey:@"voltage"] floatValue], 15.f);
}

-(NSInteger)numberOfVerticalItemCountInChartView:(FYChartView *)chartView
{
    return 5;
}

-(NSString *)chartView:(FYChartView *)chartView verticalTitleAtIndex:(NSInteger)index
{
    NSArray *v = @[@"9.0V", @"11.0V", @"12.0V", @"13.0V", @"15.0V"];
    return v[index];
}

-(NSInteger)numberOfHorizontalItemCountInChartView:(FYChartView *)chartView
{
    return 6;
}

//horizontal title at index
- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index
{
    return @"";
    
}

- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    if (index == 0) {
        return HorizontalTitleAlignmentLeft;
    }
    if (index == 5) {
        return HorizontalTitleAlignmentRight;
    }
    return HorizontalTitleAlignmentCenter;
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
