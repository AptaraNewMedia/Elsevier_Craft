//
//  FILLINBLANKS.h
//  Craft
//
//  Created by PUN-MAC-012 on 14/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FILLINBLANKS : NSObject

@property (nonatomic) NSInteger intFillid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions;
@property (nonatomic, retain) NSArray *arrAnswer;
@property (nonatomic, retain) NSArray *arrXYpoints;
@property (nonatomic) float fWidth;
@property (nonatomic) float fHeight;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSMutableArray *arrFeedback;
@property (nonatomic, retain) NSString *strInstruction;

@end
