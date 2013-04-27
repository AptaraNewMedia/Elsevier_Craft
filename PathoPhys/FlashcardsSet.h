//
//  FlashcardsSet.h
//  Craft
//
//  Created by PUN-MAC-012 on 09/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashcardsSet : NSObject

@property (nonatomic) NSInteger intFlashcardId;
@property (nonatomic) NSInteger intChapterId;
@property (nonatomic) NSInteger intIndex;
@property (nonatomic, retain) NSString *strKey;
@property (nonatomic, retain) NSString *strDefinition;
@property (nonatomic, retain) NSString *strDescription;
@property (nonatomic, retain) NSString *strInstruction;

@end
