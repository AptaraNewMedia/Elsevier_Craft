//
//  DatabaseOperation.h
//  Springer1.1
//
//  Created by PUN-MAC-012 on 31/01/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCMS;
@class FILLINBLANKS;
@class RADIOHEADING;
@class TRUEFLASE;
@class MCSS;
@class MATCHTERMS;
@class DRAGDROP;
@class QuizTrack;
@class Notes;
@class DragDropRadio;

@interface DatabaseOperation : NSObject


// FlashCards
-(NSMutableArray *) fnGetFlashcardsSet:(int)chapter_id;
-(NSMutableArray *) fnGetSortedFlashcards:(int)chapter_id;

// TestYourSelf
-(void) fnGetTestyourselfChapterList;
-(NSMutableArray *) fnGetTestyourSelfQuestions:(int)chapter_id AndThematicId:(int)thematic_id;
-(MCMS *)fnGetTestyourselfMCMS:(NSString *)question_id;
-(FILLINBLANKS *)fnGetTestyourselfFillInTheBlanks:(NSString *)question_id;
-(RADIOHEADING *)fnGetTestyourselfRadioGroup:(NSString *)question_id;
-(TRUEFLASE *)fnGetTestyourselfTrueFalse:(NSString *)question_id;
-(MATCHTERMS *)fnGetTestyourselfMatchTerms:(NSString *)question_id;
-(MCSS *)fnGetTestyourselfMCSS:(NSString *)question_id;
-(DRAGDROP *)fnGetTestyourselfDRAGDROP:(NSString *)question_id;
-(DragDropRadio *)fnGetTestyourselfDRAGDROPRadio:(NSString *)question_id;

// CaseStudy
-(void) fnGetCaseStudyChapterList;
-(NSMutableArray *) fnGetCaseStudyQuestions:(int)chapter_id AndThematicId:(int)thematic_id;


//Notes
-(void) fnSetNote:(Notes *)notes;
-(void) fnUpdateNote:(Notes *)notes;
-(Notes *) fnGetNote:(int)category_id AndChapterID:(int)chapter_id AndThematicId:(int)thematic_id AndQuestionNo:(int)question_no;
-(NSMutableArray *) fnGetNotesList;


//Quiz
-(void) fnSetQuizTrack:(QuizTrack *)quiztrack;
-(NSMutableArray *)fnGetScores;

// For creating clean database
-(void) fnSetTestyourselfData;

-(void)Fn_DeleteNotes:(int)noteid;


@end
