//
//  FYChartView.m
//
//  sina weibo:http://weibo.com/zbflying
//
//  Created by zbflying on 13-11-27.
//  Copyright (c) 2013年 zbflying All rights reserved.
//

#import "FYChartView.h"

@interface FYChartView ()

@property (nonatomic, retain) NSMutableArray *valueItemArray;
@property (nonatomic, retain) UIView *descriptionView;
@property (nonatomic, retain) UIView *slideLineView;
@property (nonatomic, retain) UILabel *slideTopLabel;


@end

@implementation FYChartView
{
    @private
    BOOL    isLoaded;                   //is already load
    float   horizontalItemWidth;        //horizontal item width
    float   verticalItemHeight;         //vertical item height
    float   verticalItemRowHeight;      //vertical item row height
    CGSize  verticalTextSize;           //vertical text size
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.customVerticalScale = NO;
        
        //default line width
        self.rectanglelineWidth = 0.5f;
        self.lineWidth = 1.f;
        
        //default line color
        self.rectangleLineColor = [UIColor blackColor];
        self.lineColor = [UIColor blueColor];
        self.slideLineColor = [UIColor redColor];
        self.horizontalTextColor = [UIColor grayColor];
        self.verticalTextColor = [UIColor grayColor];
        
        self.hideDescriptionViewWhenTouchesEnd = NO;
        self.maxVerticalValue = 0.f;
        self.minValueCount = 600;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (isLoaded)   return;
    
    //draw Rectangle
    [self drawRectangle:rect];
    
    //draw HorizontalText and line
    [self drawHorizontalTextAndLine:rect];
    
    //draw VerticalText and line
    [self drawVerticalTextAndLine:rect];
    
    //draw data line
    [self drawValueLine:rect];
    
    isLoaded = YES;
}

- (void)dealloc
{

}


//draw Rectangle
-(void)drawRectangle:(CGRect)rect
{
    if (!self.dataSource)   return;
    
    //item count
    NSInteger numberOfHorizontalItemCount = [self.dataSource numberOfValueItemCountInChartView:self];
    
    NSMutableArray *valueItems = [NSMutableArray array];
    for (int i = 0; i < numberOfHorizontalItemCount; i++)
    {
        float value = [self.dataSource chartView:self valueAtIndex:i];
        [valueItems addObject:[NSNumber numberWithFloat:value]];
        
        //if (value >= maxVerticalValue)  maxVerticalValue = value;
    }
    
    self.valueItemArray = valueItems;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfVerticalItemCountInChartView:)]) {
        NSInteger verticalTitleNumber = [self.dataSource numberOfVerticalItemCountInChartView:self];
        
        for (int i=0; i<verticalTitleNumber; i++) {
            NSString *title = [self.dataSource chartView:self verticalTitleAtIndex:i];
            if (title) {
                CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
                if (titleSize.width > verticalTextSize.width) {
                    verticalTextSize = CGSizeMake(titleSize.width+2, titleSize.height+2);
                }
            }
        }
        
        verticalItemRowHeight = (rect.size.height - verticalTextSize.height * 2) / ((verticalTitleNumber-1)*1.f);
    }
    
    numberOfHorizontalItemCount = MAX(numberOfHorizontalItemCount, self.minValueCount);    //默认最小600个点
    horizontalItemWidth = (rect.size.width - verticalTextSize.width) / (numberOfHorizontalItemCount - 1);
    verticalItemHeight = (rect.size.height - verticalTextSize.height * 2) / self.maxVerticalValue;
    
    rect.origin.x = verticalTextSize.width;
    rect.origin.y = verticalTextSize.height;
    rect.size.width -= rect.origin.x;
    rect.size.height -= (verticalTextSize.height * 2);
    
    //draw rectangle
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContext, path);
    [[UIColor clearColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
    CGContextSetLineWidth(currentContext, self.rectanglelineWidth);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
}

//draw HorizontalText and line
-(void)drawHorizontalTextAndLine:(CGRect)rect
{
    if (!self.dataSource)   return;
    
    //draw horizontal title
    NSInteger horizontalTitleNumber = [self.dataSource numberOfHorizontalItemCountInChartView:self];
    CGFloat item_width = (rect.size.width - verticalTextSize.width)/(horizontalTitleNumber-1);
    
    for (int i = 0; i < horizontalTitleNumber; i++)
    {
        NSString *title = [self.dataSource chartView:self horizontalTitleAtIndex:i];
        if (title)
        {
            CGPoint point = CGPointMake(verticalTextSize.width + item_width*i, rect.size.height);
            
            UIFont *font = [UIFont systemFontOfSize:12.0f];
            NSDictionary *attr = @{NSFontAttributeName:font, NSForegroundColorAttributeName:self.horizontalTextColor};
            CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
            
            HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
            if ([self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAlignmentAtIndex:)]) {
                alignment = [self.dataSource chartView:self horizontalTitleAlignmentAtIndex:i];
            }
            
            if (alignment == HorizontalTitleAlignmentLeft)
            {
                [title drawAtPoint:CGPointMake(point.x, rect.size.height - size.height) withAttributes:attr];
            }
            else if (alignment == HorizontalTitleAlignmentCenter)
            {
                [title drawAtPoint:CGPointMake(point.x - size.width * 0.5f, rect.size.height - size.height) withAttributes:attr];
            }
            else if (alignment == HorizontalTitleAlignmentRight)
            {
                [title drawAtPoint:CGPointMake(point.x - size.width, rect.size.height - size.height) withAttributes:attr];
            }
        }
    }
    
    rect.origin.x = verticalTextSize.width;
    rect.origin.y = verticalTextSize.height;
    rect.size.width -= verticalTextSize.width;
    rect.size.height -= (verticalTextSize.height * 2);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    for (int i = 1; i< horizontalTitleNumber; i++) {
        
        CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
        CGContextMoveToPoint(currentContext, rect.origin.x+item_width * i, rect.origin.y);
        CGContextAddLineToPoint(currentContext, rect.origin.x+item_width * i, rect.size.height + verticalTextSize.height);
        CGContextClosePath(currentContext);
        CGContextStrokePath(currentContext);
    }
}

//draw VerticalText and line
-(void)drawVerticalTextAndLine:(CGRect)rect
{
    if (!self.dataSource)   return;
    
    //draw vertical title
    NSInteger verticalTitleNumber = [self.dataSource numberOfVerticalItemCountInChartView:self];
    
    CGFloat rect_height = rect.size.height - verticalTextSize.height * 2;
    
    float itemHeight = rect_height / (verticalTitleNumber-1);
    for (int i = 1; i <= verticalTitleNumber; i++)
    {
        UIFont *font = [UIFont systemFontOfSize:12.0f];
        NSString *text = [self.dataSource chartView:self verticalTitleAtIndex:i-1];
        CGFloat text_width = [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        CGPoint point = CGPointMake(verticalTextSize.width-text_width-2, rect_height - itemHeight * (i-1) + verticalTextSize.height - verticalTextSize.height * 0.5f);
        NSDictionary *attr = @{NSFontAttributeName:font, NSForegroundColorAttributeName:self.verticalTextColor};
        [text drawAtPoint:point withAttributes:attr];
    }
    
    rect.origin.x = verticalTextSize.width;
    rect.origin.y = verticalTextSize.height;
    rect.size.width -= verticalTextSize.width;
    rect.size.height -= (verticalTextSize.height * 2);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    for (int i = 1; i < verticalTitleNumber-1; i++)
    {
        CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
        CGContextMoveToPoint(currentContext, rect.origin.x, rect.size.height - itemHeight * i + verticalTextSize.height);
        CGContextAddLineToPoint(currentContext, rect.size.width + verticalTextSize.width, rect.size.height - itemHeight * i +verticalTextSize.height);
        CGContextClosePath(currentContext);
        CGContextStrokePath(currentContext);
    }
}

/**
 *  draw data line
 */
- (void)drawValueLine:(CGRect)rect
{
    //draw line
    NSInteger valueCount = [self.valueItemArray count];
    
    //此处过滤值小于0的情况（从值大于0的位置开始画线）
    int start = 0;
    for (int i = 0; i < valueCount - 1; i++) {
        float value = [(NSNumber *)self.valueItemArray[i] floatValue];
        if (value < 0) {
            start ++;
        }else{
            break;
        }
    }
    
    for (int i = start; i < valueCount - 1; i++)
    {
        float value = [(NSNumber *)self.valueItemArray[i] floatValue];
        CGPoint point = [self valuePoint:value atIndex:i];
        
        float nextValue = [(NSNumber *)self.valueItemArray[i + 1] floatValue];
        CGPoint nextPoint = [self valuePoint:nextValue atIndex:i + 1];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
}

#pragma mark - custom method

/**
 *  value item point at index
 */
- (CGPoint)valuePoint:(float)value atIndex:(int)index
{
    CGPoint retPoint = CGPointZero;
    
    CGFloat y = value * verticalItemHeight;
    if (self.customVerticalScale) {
        if (value < 9) {
            y = 0;
        }else if (value >= 9 && value < 11) {
            y = (value/11.f) * verticalItemRowHeight;
        }else if (value >= 11 && value < 13){
            y = verticalItemRowHeight + (value-11)/2.f * verticalItemRowHeight*2;
        }else if (value >= 13 && value <= 15){
            y = verticalItemRowHeight * 3 + (value-13)/2.f * verticalItemRowHeight;
        }else{
            y = verticalItemRowHeight * 4;
        }
    }
    
    retPoint.x = index * horizontalItemWidth + verticalTextSize.width;
    retPoint.y = self.frame.size.height - verticalTextSize.height - y;
    
    return retPoint;
}

/**
 *  display description view
 */
- (void)descriptionViewPointWithTouches:(NSSet *)touches
{
    CGSize size = self.frame.size;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (location.x >= 0 && location.x <= size.width && location.y >= 0 && location.y <= size.height)
    {
        int intValue = location.x / horizontalItemWidth;
        float remainder = location.x - intValue * horizontalItemWidth;
        
        int index = intValue + (remainder >= horizontalItemWidth * 0.5f ? 1 : 0);
        if (index < self.valueItemArray.count)
        {
            float value = [(NSNumber *)self.valueItemArray[index] floatValue];
            CGPoint point = [self valuePoint:value atIndex:index];
            
            if ([self.dataSource respondsToSelector:@selector(chartView:descriptionViewAtIndex:)])
            {
                UIView *descriptionView = [self.dataSource chartView:self descriptionViewAtIndex:index];
                if (descriptionView == nil) {
                    return;
                }
                CGRect frame = descriptionView.frame;
                if (point.x + frame.size.width > size.width)
                {
                    frame.origin.x = point.x - frame.size.width;
                }
                else
                {
                    frame.origin.x = point.x;
                }
                
                if (frame.size.height + point.y > size.height)
                {
                    frame.origin.y = point.y - frame.size.height;
                }
                else
                {
                    frame.origin.y = point.y;
                }
                
                descriptionView.frame = frame;
                
                if (self.descriptionView)   [self.descriptionView removeFromSuperview];
                
                if (!self.slideLineView)
                {
                    //slide line view
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                                                 verticalTextSize.height,
                                                                                 1.0f,
                                                                                 self.frame.size.height - verticalTextSize.height * 2)];
                    lineView.backgroundColor = self.slideLineColor;
                    lineView.hidden = YES;
                    self.slideLineView = lineView;
                    [self addSubview:self.slideLineView];
                    
                }
                
                //draw line
                CGRect slideLineViewFrame = self.slideLineView.frame;
                slideLineViewFrame.origin.x = point.x;
                self.slideLineView.frame = slideLineViewFrame;
                self.slideLineView.hidden = NO;
                
                [self addSubview:descriptionView];
                self.descriptionView = descriptionView;
                
                if ([self.dataSource respondsToSelector:@selector(chartView:topTitleAtIndex:)]) {
                    NSString *topTitle = [self.dataSource chartView:self topTitleAtIndex:index];
                    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
                    CGSize textSize = [topTitle boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

                    if (!self.slideTopLabel) {
                        self.slideTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width+6, 10)];
                        self.slideTopLabel.textColor = self.slideLineColor;
                        self.slideTopLabel.font = [UIFont systemFontOfSize:13];
                        [self addSubview:self.slideTopLabel];
                    }
                    self.slideTopLabel.text = topTitle;
                    CGRect frame = self.slideTopLabel.frame;
                    frame.origin.x = point.x;
                    
                    CGFloat x = frame.origin.x;
                    if ((self.frame.size.width - point.x) < frame.size.width/2){
                        x = frame.origin.x - frame.size.width;
                    }else if ((point.x - verticalTextSize.width) > frame.size.width/2) {
                        x = frame.origin.x - frame.size.width/2;
                    }
                    frame.origin.x = x+3;
                    self.slideTopLabel.frame = frame;
                }
                
                //delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:didMovedToIndex:)])
                {
                    [self.delegate chartView:self didMovedToIndex:index];
                }
            }
        }
    }
}

- (void)reloadData
{
    isLoaded = NO;
    [self.valueItemArray removeAllObjects];
    horizontalItemWidth = .0f;
    verticalItemHeight = .0f;
    if (self.descriptionView)   [self.descriptionView removeFromSuperview];
    if (self.slideLineView)   self.slideLineView.hidden = YES;
    if (self.slideTopLabel) self.slideTopLabel.text = @"";
    [self setNeedsDisplay];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.valueItemArray || !self.valueItemArray.count || !self.dataSource) return;
    
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.descriptionView && self.hideDescriptionViewWhenTouchesEnd)   [self.descriptionView removeFromSuperview];
}

@end
