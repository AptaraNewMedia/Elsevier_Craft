//
//  ScoreCard.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 10/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "ScoreCard.h"

@implementation ScoreCard
@synthesize  strName, intScore;

- (id)init
{
    self = [super init];
    if (self) {
        strName = [[NSMutableString alloc] init];        
    }
    return self;
}
@end
