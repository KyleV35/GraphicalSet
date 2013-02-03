//
//  Deck.h
//  Matchismo
//
//  Created by Kyle Vermeer on 1/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card*)card atTop:(BOOL)atTop;

-(Card*)drawRandomCard;

@end
