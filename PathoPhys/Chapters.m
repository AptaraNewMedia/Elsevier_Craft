//
//  TestyourselfChapters.m
//  Craft
//
//  Created by PUN-MAC-012 on 12/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import "Chapters.h"

@implementation Chapters

@synthesize intChapterId;
@synthesize strChapterTitle;
@synthesize intIsThematicArea;
@synthesize thematicData;
@synthesize intCategoryId;

- (id)init
{
    self = [super init];
    if (self) {       
        thematicData = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
