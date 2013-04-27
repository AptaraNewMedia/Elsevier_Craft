//
//  MCSS.h
//  Craft
//
//  Created by PUN-MAC-012 on 14/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCSS : NSObject

@property (nonatomic) NSInteger intMCSSid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions;
@property (nonatomic, retain) NSArray *arrAnswer;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSMutableArray *arrFeedback;
@property (nonatomic, retain) NSString *strInstruction;

@end
