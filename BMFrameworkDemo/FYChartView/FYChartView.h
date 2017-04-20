//
//  FYChartView.h
//
//  sina weibo:http://weibo.com/zbflying
//
//  Created by zbflying on 13-11-27.
//  Copyright (c) 2013年 zbflying All rights reserved.
//

#import <UIKit/UIKit.h>

enum HorizontalTitleAlignment
{
    HorizontalTitleAlignmentLeft,
    HorizontalTitleAlignmentCenter,
    HorizontalTitleAlignmentRight
};

typedef enum HorizontalTitleAlignment HorizontalTitleAlignment;

@class FYChartView;
@protocol FYChartViewDataSource <NSObject>
@required

/**
 *  number of item count
 */
- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;

/**
 *  number of horizontal title count
 */
- (NSInteger)numberOfHorizontalItemCountInChartView:(FYChartView *)chartView;

/**
 *  number of vertical title count
 */
- (NSInteger)numberOfVerticalItemCountInChartView:(FYChartView *)chartView;

/**
 *  value at index
 */
- (float)chartView:(FYChartView *)chartView valueAtIndex:(NSInteger)index;

@optional

/**
 *  horizontal title at index
 */
- (NSString *)chartView:(FYChartView *)chartView topTitleAtIndex:(NSInteger)index;

/**
 *  description view at index
 */
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index;

/**
 *  vertical title at index
 */
- (NSString *)chartView:(FYChartView *)chartView verticalTitleAtIndex:(NSInteger)index;

/**
 *  horizontal title at index
 */
- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index;

/**
 *  horizontal title alignmentat at index
 *  default is HorizontalTitleAlignmentCenter
 */
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index;

@end


@protocol FYChartViewDelegate <NSObject>
@optional
/**
 *  when touched and did moved to index
 */
- (void)chartView:(FYChartView *)chartView didMovedToIndex:(NSInteger)index;

@end


@interface FYChartView : UIView


/**
 *  custom vertical scale
 *  default is NO
 */
@property (nonatomic, assign)   BOOL customVerticalScale;

/**
 *  max vertical value
 *  default is 0.f
 */
@property (nonatomic, assign) float   maxVerticalValue;

/**
 *  rectangle line color
 *  default is blackColor
 */
@property (nonatomic, retain) UIColor *rectangleLineColor;

/**
 *  horizontal line color
 *  default is whiteColor
 */
@property (nonatomic, retain) UIColor *horizontalTextColor;

/**
 *  vertical line color
 *  default is whiteColor
 */
@property (nonatomic, retain) UIColor *verticalTextColor;

/**
 *  rectangle line width
 *  default is 1.0f
 */
@property (nonatomic, assign) float rectanglelineWidth;

/**
 *  line color
 *  default is blackColor
 */
@property (nonatomic, retain) UIColor *lineColor;

/**
 *  line width
 *  default is 1.0f
 */
@property (nonatomic, assign) float lineWidth;

/**
 *  slideLine color
 *  default is redColor
 */
@property (nonatomic, retain) UIColor *slideLineColor;

/*
 * min value count
 * default 600
 */
@property (nonatomic, assign)   int minValueCount;

/**
 *  hide description view when touches end
 *  default is NO
 */
@property (nonatomic, assign) BOOL hideDescriptionViewWhenTouchesEnd;

/**
 * chart view data source
 */
@property (nonatomic, assign) IBOutlet id<FYChartViewDataSource> dataSource;

/**
 * chart view delegate
 */
@property (nonatomic, assign) IBOutlet id<FYChartViewDelegate> delegate;

/**
 *  reload data source
 */
- (void)reloadData;

@end
