//
//  SetCard.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SetCard.h"

#define NUM_VALUES 3
#define MAX_NUMBER 2
#define MAX_SHADING 2
#define MAX_COLOR 2
#define MAX_SHAPE 2

#define SET_MATCH_SCORE 4

@implementation SetCard

+ (NSUInteger) maxShape
{
    return MAX_SHAPE;
}

+ (NSUInteger) maxNumber
{
    return MAX_NUMBER;
}

+ (NSUInteger) maxColor
{
    return MAX_COLOR;
}

+ (NSUInteger) maxShading
{
    return MAX_SHADING;
}

- (void)setShape:(NSUInteger)shape
{
    if (shape <= [SetCard maxShape]) {
        _shape = shape;
    } else {
        NSLog(@"Attempted to set an invalid shape: %u",shape);
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    } else {
        NSLog(@"Attempted to set an invalid number: %u",number);
    }
}

- (void)setShading:(NSUInteger)shading
{
    if (shading <= [SetCard maxShading]) {
        _shading = shading;
    } else {
        NSLog(@"Attempted to set an invalid shading: %u",shading);
    }
}

- (void)setColor:(NSUInteger)color
{
    if (color <= [SetCard maxColor]) {
        _color = color;
    } else {
        NSLog(@"Attempted to set an invalid color: %u",color);
    }
}

/* Shape,number,color,shading */
- (NSString*)contents
{
    return [NSString stringWithFormat:@"%u%u%u%u",self.shape,self.number,self.color,self.shading];
}

- (int) match:(NSArray *)otherCards
{
    BOOL shapeMatch = [self shapeMatch:otherCards];
    BOOL numberMatch = [self numberMatch:otherCards];
    BOOL colorMatch = [self colorMatch:otherCards];
    BOOL shadingMatch = [self shadingMatch:otherCards];
    if (shapeMatch && numberMatch && shadingMatch && colorMatch) {
        return SET_MATCH_SCORE;
    } else {
        return 0;
    }
}

#pragma mark - Set Match Methods

- (BOOL) shapeMatch:(NSArray*)otherCards
{
    NSMutableArray* shapeArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [shapeArray addObject:@(card.shape)];
    }
    [shapeArray addObject:@(self.shape)];
    return [SetCard setMatch:[NSArray arrayWithArray:shapeArray]];
}

- (BOOL)numberMatch:(NSArray*)otherCards
{
    NSMutableArray* numberArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [numberArray addObject:@(card.number)];
    }
    [numberArray addObject:@(self.number)];
    return [SetCard setMatch:[NSArray arrayWithArray:numberArray]];
}

- (BOOL)shadingMatch:(NSArray*)otherCards
{
    NSMutableArray* shadingArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [shadingArray addObject:@(card.shading)];
    }
    [shadingArray addObject:@(self.shading)];
    return [SetCard setMatch:[NSArray arrayWithArray:shadingArray]];
}

- (BOOL)colorMatch:(NSArray*)otherCards
{
    NSMutableArray* colorArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [colorArray addObject:@(card.color)];
    }
    [colorArray addObject:@(self.color)];
    return [SetCard setMatch:[NSArray arrayWithArray:colorArray]];
}

#pragma mark - Helper Methods

/* Values argument must have all values, including current cards values */
+ (BOOL)setMatch:(NSArray*)values
{
    NSMutableArray* frequencyArray = [[NSMutableArray alloc] init];
    //First create an array with bucks for each possible value
    for (NSUInteger i=0; i < NUM_VALUES; i++) {
        [frequencyArray addObject:@(0)];
    }
    // Then update the count for each value using the array
    for (NSNumber* value in values) {
        frequencyArray[[value unsignedIntValue]] = @([frequencyArray[[value unsignedIntValue]] unsignedIntValue] +1);
    }
    NSUInteger numCards =[values count];
    bool isMatch = YES;
    
    /* Finally check if all the array buckets (indices) have exactly one entry,
     if not, one bucket must have every entry for it to be a set Match. */
    for (NSUInteger i=0; i < NUM_VALUES; i++) {
        if ([frequencyArray[i] unsignedIntValue] == numCards) {
            isMatch = YES;
            break;
        } else if ([frequencyArray[i] unsignedIntValue] != 1) {
            isMatch = NO; // Don't break, if one key has all the values, it can still be a match
        }
    }
    return isMatch ? YES : NO;

}

@end
