//
//  BaseViewController.m
//  wook
//
//  Created by guojiang on 5/8/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout= UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        [self resetBackBarButton];
    }
}


- (void)resetBackBarButton
{
    [self addLeftBarImageName:@"back_btn" target:self action:@selector(viewWillBack)];
}

-(void)viewWillBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)pushViewControllerName:(NSString *)VCName
{
    [self pushViewControllerName:VCName animated:YES];
}

-(void)pushHideTabbarViewControllerName:(NSString *)VCName
{
    UIViewController *objClass = [[NSClassFromString(VCName) alloc] init];
    if (objClass == nil) {
        NSLog(@"ViewController:%@ is not exist", VCName);
        return;
    }
    objClass.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:objClass animated:YES];
}

-(void)pushViewControllerName:(NSString *)VCName animated:(BOOL)animated
{
    id objClass = [[NSClassFromString(VCName) alloc] init];
    if (objClass == nil) {
        NSLog(@"ViewController:%@ is not exist", VCName);
        return;
    }
    
    [self.navigationController pushViewController:objClass animated:animated];
}

-(void)addLeftBarTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:action];
    button.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = button;
}

-(void)addRightBarTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:action];
    button.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = button;
}

-(void)addLeftBarImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 40, 40);
    [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    UIBarButtonItem *space_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space_item.width = -10;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space_item, item, nil];
}

-(void)addRightBarImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 40, 40);
    [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    UIBarButtonItem *space_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space_item.width = -10;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space_item,item,  nil];
}


#define mark System
-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
