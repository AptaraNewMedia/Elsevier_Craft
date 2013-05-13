//
//  Notes.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 21/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notes : NSObject

@property (nonatomic) NSInteger intNotesId;
@property (nonatomic) NSInteger intCategoryId;
@property (nonatomic) NSInteger intChapterId;
@property (nonatomic) NSInteger intThematicId;
@property (nonatomic) NSInteger intMode;
@property (nonatomic, retain) NSString *strQuestionId;
@property (nonatomic) NSInteger intQuestionNo;
@property (nonatomic) NSInteger intQuizTrackId;
@property (nonatomic, retain) NSString *strNoteTitle;
@property (nonatomic, retain) NSString *strNoteDesc;
@property (nonatomic, retain) NSString *strNoteHistory;
@property (nonatomic, retain) NSString *strCreatedDate;
@property (nonatomic, retain) NSString *strModifiedDate;
@end
