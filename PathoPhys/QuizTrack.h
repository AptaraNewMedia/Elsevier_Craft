//
//  QuizTrack.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 11/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizTrack : NSObject

@property (nonatomic) NSInteger intQuizTrackId;
@property (nonatomic) NSInteger intCategoryId;
@property (nonatomic) NSInteger intChapterId;
@property (nonatomic, retain) NSString *strQuizTitle;
@property (nonatomic) NSInteger intThematicId;
@property (nonatomic, retain) NSMutableArray *arrQuestionIds;
@property (nonatomic, retain) NSMutableArray *arrVisited;
@property (nonatomic, retain) NSMutableArray *arrSelectedAnswer;
@property (nonatomic) NSInteger intCorrectQuestion;
@property (nonatomic) NSInteger intMissedQuestion;
@property (nonatomic) float floatPercentage;
@property (nonatomic) NSInteger intLastVisitedQuestion;
@property (nonatomic) NSInteger intComplete;
@property (nonatomic, retain) NSString *strCreatedDate;

@end
