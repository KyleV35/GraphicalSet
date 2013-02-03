//
//  SetCard.h
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

+(NSUInteger)maxShape;
+(NSUInteger)maxNumber;
+(NSUInteger)maxShading;
+(NSUInteger)maxColor;

@end
