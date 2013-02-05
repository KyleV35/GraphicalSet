//
//  GraphicalSetCardView.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GraphicalSetCardView.h"

#define CARD_CORNER_RADIUS 10
#define NUM_WIDTH_SUBDIVISIONS 10
#define NUM_HEIGHT_SUBDIVISIONS 6
#define LINE_DISTANCE 3.0f
#define PERCENT_HEIGHT_OF_SYMBOLS 2.0f/3.0f
#define PERCENT_WIDTH_OF_CARD_FOR_EACH_SYMBOL 1.0f/5.0f
#define ROUNDED_RECT_SYMBOL_RADIUS 10
#define OFFSET_1 1.0f;
#define OFFSET_2 2.0f;
#define OFFSET_4 4.0f;
#define OFFSET_6 6.0f;
#define OFFSET_7 7.0f

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
    self.contentMode = UIViewContentModeRedraw;
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
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CARD_CORNER_RADIUS];
    CGContextSaveGState(context);
    if (self.unplayable) {
        [[UIColor clearColor] setFill];
    } else if (self.faceUp) {
        [[UIColor yellowColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    [path fill];
    [path addClip];
    float symbolHeight = heightSubdivisionSize*(PERCENT_HEIGHT_OF_SYMBOLS * NUM_HEIGHT_SUBDIVISIONS);
    float symbolWidth = widthSubdivisionSize*(PERCENT_WIDTH_OF_CARD_FOR_EACH_SYMBOL*NUM_WIDTH_SUBDIVISIONS);
    float startingY = self.bounds.origin.y + heightSubdivisionSize;
    if (self.number == 0) {
        float startingX = self.bounds.origin.x + widthSubdivisionSize*OFFSET_4;
        [self drawShape:context inRect:CGRectMake(startingX, startingY, symbolWidth, symbolHeight)];
    } else if (self.number==1) {
        float startingX = self.bounds.origin.x + widthSubdivisionSize*OFFSET_2;
        [self drawShape:context inRect:CGRectMake(startingX, startingY, symbolWidth, symbolHeight)];
        float secondX = self.bounds.origin.x + widthSubdivisionSize*OFFSET_6;
        [self drawShape:context inRect:CGRectMake(secondX, startingY, symbolWidth, symbolHeight)];
    } else if (self.number==2) {
        float startingX = self.bounds.origin.x + widthSubdivisionSize * OFFSET_1;
        [self drawShape:context inRect:CGRectMake(startingX, startingY, symbolWidth, symbolHeight)];
        float secondX = self.bounds.origin.x + widthSubdivisionSize * OFFSET_4;
        [self drawShape:context inRect:CGRectMake(secondX, startingY, symbolWidth, symbolHeight)];
        float thirdX = self.bounds.origin.x + widthSubdivisionSize * OFFSET_7;
        [self drawShape:context inRect:CGRectMake(thirdX, startingY, symbolWidth, symbolHeight)];
    } else {
        NSLog(@"Unknown Number: %u",self.number);
        exit(1);
    }
    CGContextRestoreGState(context);
}

- (void)drawShape:(CGContextRef)context inRect:(CGRect)rect
{
    if (self.shape == 0) {
        [self drawDiamond:context inRect:rect];
    } else if (self.shape == 1) {
        [self drawRoundedRect:context inRect:rect];
    } else if (self.shape ==2) {
        [self drawSquiggle:context inRect:rect];
    } else {
        NSLog(@"Unknown Shape: %u",self.shape);
        exit(1);
    }
}

- (void)drawDiamond:(CGContextRef)context inRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGPoint middle = CGPointMake(rect.origin.x + size.width/2, rect.origin.y + size.height/2);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint topPoint = CGPointMake(middle.x, middle.y - size.height/2.0);
    CGPoint rightPoint = CGPointMake(middle.x + size.width/2.0, middle.y);
    CGPoint bottomPoint = CGPointMake(middle.x, middle.y + size.height/2.0);
    CGPoint leftPoint = CGPointMake(middle.x - size.width/2.0, middle.y);
    [path moveToPoint:topPoint];
    [path addLineToPoint:rightPoint];
    [path addLineToPoint:bottomPoint];
    [path addLineToPoint:leftPoint];
    [path closePath];
    CGContextSaveGState(context);
    [[self cardColor] setStroke];
    [path stroke];
    [path addClip];
    [self applyShadingToPath:path inRect:rect withContext:context];
    CGContextRestoreGState(context);
}

- (void) drawRoundedRect:(CGContextRef)context inRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:ROUNDED_RECT_SYMBOL_RADIUS];
    CGContextSaveGState(context);
    [[self cardColor] setStroke];
    [path stroke];
    [path addClip];
    [self applyShadingToPath:path inRect:rect withContext:context];
    CGContextRestoreGState(context);
}

- (void) drawSquiggle:(CGContextRef)context inRect:(CGRect)rect
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:rect.origin];
    float quarterY = rect.origin.y + rect.size.height/4.0f;
    float bottomY = rect.origin.y + rect.size.height;
    float eightY = rect.origin.y + rect.size.height/8.0f;
    float thirtySecondY = rect.origin.y + rect.size.height/32.0f;
    float fiveEightsY =rect.origin.y + rect.size.height*5.0f/8.0f;
    float threeFourthsY =rect.origin.y + rect.size.height*3.0f/4.0f;
    float rightX = rect.origin.x + rect.size.width;
    float leftX = rect.origin.x;
    float halfX = rect.origin.x + rect.size.width/2.0f;
    float fiveEigthsX = rect.origin.x +rect.size.width*5.0f/8.0f;
    [path addQuadCurveToPoint:CGPointMake(halfX,fiveEightsY) controlPoint:CGPointMake(rightX,thirtySecondY)];
    [path addQuadCurveToPoint:CGPointMake(fiveEigthsX,threeFourthsY) controlPoint:CGPointMake(halfX, threeFourthsY)];
    [path addQuadCurveToPoint:CGPointMake(halfX, bottomY) controlPoint:CGPointMake(rightX,bottomY)];
    [path addQuadCurveToPoint:CGPointMake(leftX,threeFourthsY) controlPoint:CGPointMake(leftX, bottomY)];
    [path addQuadCurveToPoint:CGPointMake(leftX, eightY) controlPoint:CGPointMake(halfX, quarterY)];
    [path addQuadCurveToPoint:rect.origin controlPoint:CGPointMake(leftX, eightY)];
    CGContextSaveGState(context);
    [[self cardColor] setStroke];
    [path stroke];
    [path addClip];
    [self applyShadingToPath:path inRect:rect withContext:context];
    CGContextRestoreGState(context);
}


- (void)drawLinesThroughRect:(CGRect)rect withPath:(UIBezierPath*)path WithContext:(CGContextRef)context
{
    float topY= rect.origin.y;
    float bottomY = rect.origin.y + rect.size.height;
    float rightX = rect.origin.x + rect.size.width;
    for (float y=topY; y < bottomY; y+=LINE_DISTANCE) {
        [path moveToPoint:CGPointMake(0, y)];
        [path addLineToPoint:CGPointMake(rightX, y)];
    }
    CGContextSaveGState(context);
    [[self cardColor] setStroke];
    [path stroke];
    CGContextRestoreGState(context);
}

- (void)applyShadingToPath:(UIBezierPath*)path inRect:(CGRect)rect withContext:(CGContextRef)context {
    if (self.shading == 0) {
        // Do nothing
    } else if (self.shading == 1) {
        [self drawLinesThroughRect:rect withPath:path WithContext:context];
    } else if (self.shading == 2) {
        CGContextSaveGState(context);
        [[self cardColor] setFill];
        [path fill];
        CGContextRestoreGState(context);
    } else {
        NSLog(@"Unknown Shading: %u",self.shading);
    }
}

- (void) populateWithSetCard:(SetCard*)card
{
    self.number = card.number;
    self.color = card.color;
    self.shape = card.shape;
    self.shading = card.shading;
    self.faceUp = card.isFaceUp;
    self.unplayable = card.isUnplayable;
}

@end
