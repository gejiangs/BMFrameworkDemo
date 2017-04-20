//
//  BaseTabBarController.m
//  ScopeCamera
//
//  Created by gejiangs on 15/11/26.
//  Copyright © 2015年 gejiangs. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titleArray     = @[@"Voltage",@"Startup", @"Chargiong", @"Setting"];
    NSArray *normalArray    = @[@"home_btn_battery_gray",@"home_btn_car_gray",@"home_btn_charging_gray",@"home_btn_setting_pre"];
    NSArray *selectedArray  = @[@"home_btn_battery_blue",@"home_btn_car_blue",@"home_btn_charging_blue",@"home_btn_setting"];
    
    for (int i=0; i<[self.viewControllers count]; i++)
    {
        UIViewController *vc  = [self.viewControllers objectAtIndex:i];
        
        UIImage *selectImage= [[UIImage imageNamed:[selectedArray objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image = [[UIImage imageNamed:[normalArray objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[titleArray objectAtIndex:i] image:image selectedImage:selectImage];
        item.tag = i;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:RGB(134, 134, 134), NSForegroundColorAttributeName, nil];
        [item setTitleTextAttributes:dict forState:UIControlStateNormal];
        
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:RGB(15, 165, 247), NSForegroundColorAttributeName,nil];
        [item setTitleTextAttributes:dict2 forState:UIControlStateSelected];
        
        vc.tabBarItem = item;
    }
}

-(void)addSplitLineView
{
    CGFloat item_width = self.tabBar.frame.size.width/4.f;
    for (int i=1; i<=self.viewControllers.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(item_width*i, 0, 0.5, self.tabBar.frame.size.height)];
        line.backgroundColor = RGB(153, 153, 153);
        [self.tabBar insertSubview:line atIndex:0];
    }}


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
