//
//  MCMS.h
//  Craft
//
//  Created by PUN-MAC-012 on 14/03/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCMS : NSObject

@property (nonatomic) NSInteger intMCMSid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions;
@property (nonatomic, retain) NSArray *arrAnswer;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSString *strFeedback;
@property (nonatomic, retain) NSString *strInstruction;

@end
