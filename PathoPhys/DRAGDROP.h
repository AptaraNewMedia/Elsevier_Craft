//
//  DRAGDROP.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 30/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRAGDROP : NSObject

@property (nonatomic) NSInteger intDRAGDROPid;
@property (nonatomic, retain) NSString *strQuestionText;
@property (nonatomic, retain) NSArray *arrOptions;
@property (nonatomic, retain) NSArray *arrOptionsText;
@property (nonatomic, retain) NSArray *arrAnswer;
@property (nonatomic, retain) NSArray *arrXYpoints;
@property (nonatomic) float fWidth;
@property (nonatomic) float fHeight;
@property (nonatomic, retain) NSString *strImageName;
@property (nonatomic, retain) NSMutableArray *arrFeedback;
@property (nonatomic, retain) NSString *strInstruction;

@end
