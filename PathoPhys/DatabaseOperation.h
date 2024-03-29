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
-(NSMutableArray *) fnGetAllFlashcardsSet;
-(NSMutableArray *) fnGetAllSortedFlashcards;
-(NSMutableArray *) fnGetAllAlphabetFlashcards:(NSString *)word;
-(NSMutableArray *) fnGetFlashcardsSet:(int)chapter_id;
-(NSMutableArray *) fnGetSortedFlashcards:(int)chapter_id;
-(NSMutableArray *) fnGetAlphabetFlashcards:(int)chapter_id AndWord:(NSString *)word;

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
-(MCSS *)fnGetCasestudyMCSS:(NSString *)question_id;
-(MATCHTERMS *)fnGetCasestudyMatchTerms:(NSString *)question_id;
-(DRAGDROP *)fnGetCasestudyDRAGDROP:(NSString *)question_id;

//Notes
-(void) fnSetNote:(Notes *)notes;
-(void) fnUpdateNote:(Notes *)notes;
-(Notes *) fnGetNote:(int)category_id AndChapterID:(int)chapter_id AndThematicId:(int)thematic_id AndQuestionNo:(int)question_no AndQuizTrackId:(int)quiz_id;
-(NSMutableArray *) fnGetNotesList;


//Quiz
-(void) fnSetQuizTrack:(QuizTrack *)quiztrack;
-(QuizTrack *)fnGetQuizTRack:(int)category_id AndChapterID:(int)chapter_id AndThematicId:(int)thematic_id;
-(void)fnDeleteQuizTrack:(int)trackid;
-(NSMutableArray *)fnGetScores;

// For creating clean database
-(void) fnSetTestyourselfData;

-(void)Fn_DeleteNotes:(int)noteid;


@end
