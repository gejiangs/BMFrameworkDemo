//
//  StartViewController.m
//  BMFrameworkDemo
//
//  Created by 郭江 on 2017/4/18.
//  Copyright © 2017年 郭江. All rights reserved.
//

#import "StartViewController.h"
#import "FYChartView.h"
#import "BluetoothManager.h"

@interface StartViewController ()<FYChartViewDataSource, FYChartViewDelegate>

@property (nonatomic, strong)   FYChartView *lineChartView;             //曲线图
@property (nonatomic, strong)   NSMutableArray *contentList;            //曲线图数据
@property (nonatomic, strong)   UILabel *resultLabel;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Startup";
    [self initUI];
}

-(void)initUI
{
    self.resultLabel = [self.view addLabelWithText:@"" color:[UIColor blackColor]];
    _resultLabel.numberOfLines = 0;
    [_resultLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.right.offset(-10);
    }];
    
    
    self.lineChartView = [[FYChartView alloc] init];
    _lineChartView.backgroundColor = [UIColor clearColor];
    _lineChartView.rectangleLineColor = RGB(134, 134, 134);
    _lineChartView.lineColor = RGB(244, 93, 17);
    _lineChartView.lineWidth = 2.f;
    _lineChartView.maxVerticalValue = 18.f;
    _lineChartView.customVerticalScale = NO;
    _lineChartView.dataSource = self;
    [self.view addSubview:_lineChartView];
    [_lineChartView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(200);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveStartupData:) name:@"ReceiveStartupData" object:nil];
}

-(void)receiveStartupData:(NSNotification *)noti
{
    NSDictionary *item = noti.object;
    self.resultLabel.text = [NSString stringWithFormat:@"Date:%@\nStatus:%d\nVol:%@", item[@"date"], [item[@"status"] intValue], item[@"voltage"]];
    
    self.contentList = [NSMutableArray arrayWithArray:item[@"voltages"]];
    [self.lineChartView reloadData];
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
    NSString *value = [self.contentList objectAtIndex:index];
    return [value floatValue];
}

-(NSInteger)numberOfVerticalItemCountInChartView:(FYChartView *)chartView
{
    return 7;
}

-(NSString *)chartView:(FYChartView *)chartView verticalTitleAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%d.0V", ((int)index) * 3];
}

-(NSInteger)numberOfHorizontalItemCountInChartView:(FYChartView *)chartView
{
    return 7;
}

//horizontal title at index
- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ds", (int)index];
}

- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index
{
    if (index == 0) {
        return HorizontalTitleAlignmentLeft;
    }
    if (index == 6) {
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
