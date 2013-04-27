//
//  TestyourselfChapters.h
//  Craft
//
//  Created by PUN-MAC-012 on 12/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Chapters : NSObject

@property (nonatomic) NSInteger intChapterId;
@property (nonatomic, retain) NSString *strChapterTitle;
@property (nonatomic) NSInteger intIsThematicArea;
@property (nonatomic, retain) NSMutableArray *thematicData;
@property (nonatomic) NSInteger intCategoryId;
@end
