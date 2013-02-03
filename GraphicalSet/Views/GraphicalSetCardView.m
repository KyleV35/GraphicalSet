//
//  GraphicalSetCardView.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GraphicalSetCardView.h"

#define CORNER_RADIUS 10
#define NUM_WIDTH_SUBDIVISIONS 6
#define NUM_HEIGHT_SUBDIVISIONS 10

@implementation GraphicalSetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setUp];
}

- (void) setUp
{
    // Do initialization here
}

- (UIColor*)cardColor
{
    switch (self.color) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor greenColor];
        case 2:
            return [UIColor purpleColor];
        default:
            NSLog(@"Unknown Color");
            return [UIColor blackColor];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat widthSubdivisionSize = self.bounds.size.width/(float)NUM_WIDTH_SUBDIVISIONS;
    CGFloat heightSubdivisionSize = self.bounds.size.height/(float)NUM_HEIGHT_SUBDIVISIONS;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    [[UIColor whiteColor] setFill];
    [path fill];
    [path addClip];
    [self drawDiamond:context inRect:CGRectMake(self.bounds.origin.x + widthSubdivisionSize, self.bounds.origin.y + heightSubdivisionSize * 4.0f, widthSubdivisionSize*4, heightSubdivisionSize*2)];
}

- (void)drawDiamond:(CGContextRef)context inRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGPoint middle = CGPointMake(rect.origin.x + size.width/2, rect.origin.y + size.height/2);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint topPoint = CGPointMake(middle.x, middle.y - size.height/2);
    CGPoint rightPoint = CGPointMake(middle.x + size.width/2, middle.y);
    CGPoint bottomPoint = CGPointMake(middle.x, middle.y + size.height/2);
    CGPoint leftPoint = CGPointMake(middle.x - size.width/2, middle.y);
    [path moveToPoint:topPoint];
    [path addLineToPoint:rightPoint];
    [path addLineToPoint:bottomPoint];
    [path addLineToPoint:leftPoint];
    [path closePath];
    
    CGContextSaveGState(context);
    CGFloat array[2] = {5.0, 5.0};
    [path setLineDash:array count:2 phase:5.0];
    [[self cardColor] setFill];
    [path fill];
    CGContextRestoreGState(context);
}

@end
