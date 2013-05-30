//
//  DatabaseOperation.m
//  Springer1.1
//
//  Created by PUN-MAC-012 on 31/01/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import "DatabaseOperation.h"
#import "SQLiteManager.h"

// Objects
#import "FlashcardsSet.h"
#import "Chapters.h"
#import "ThematicArea.h"
#import "ChapterQuestionSet.h"
#import "MCMS.h"
#import "FILLINBLANKS.h"
#import "RADIOBUTTONS.h"
#import "RADIOHEADING.h"
#import "TRUEFLASE.h"
#import "MATCHTERMS.h"
#import "MCSS.h"
#import "DRAGDROP.h"
#import "Feedback.h"
#import "Notes.h"
#import "QuizTrack.h"
#import "DragDropRadio.h"
//
SQLiteManager *dbOperation;
//

//
NSString *strQuery;
NSArray *arrTempList;
int intRowCount;
NSArray *arrSubTempList;
int intSubRowCount;
NSError *error;
//

//

@implementation DatabaseOperation

-(id) init {
    self = [super init];
    
	if(self != nil) {
        dbOperation = [SQLiteManager sharedDatabase];
	}
	return self;
}


//--------------------------------------------------------------
#pragma mark -
#pragma mark FlashCards
//--------------------------------------------------------------


//FlashCards Key definition set
//--------------------------------------------------------------

-(NSMutableArray *) fnGetAllFlashcardsSet
{
    FlashcardsSet *objFlashcardSet;
    NSMutableArray *flashcardData = [[NSMutableArray  alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT flashcard_id, chapter_id, word, definition, description FROM flashcards"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFlashcardSet = [FlashcardsSet new];
        objFlashcardSet.intFlashcardId = [[[arrTempList objectAtIndex:i] objectForKey:@"flashcard_id"] intValue];
        objFlashcardSet.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objFlashcardSet.strKey = [[arrTempList objectAtIndex:i] objectForKey:@"word"];
        objFlashcardSet.strDefinition = [[arrTempList objectAtIndex:i] objectForKey:@"definition"];
        objFlashcardSet.strDescription = [[arrTempList objectAtIndex:i] objectForKey:@"description"];
        //objFlashcardSet.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        objFlashcardSet.intIndex = i;
        [flashcardData addObject:objFlashcardSet];
    }
    return flashcardData;
}

-(NSMutableArray *) fnGetAllSortedFlashcards
{
    FlashcardsSet *objFlashcardSet;
    NSMutableArray *flashcardData = [[NSMutableArray  alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT flashcard_id, chapter_id, word, definition, description FROM flashcards"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFlashcardSet = [FlashcardsSet new];
        objFlashcardSet.intFlashcardId = [[[arrTempList objectAtIndex:i] objectForKey:@"flashcard_id"] intValue];
        objFlashcardSet.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objFlashcardSet.strKey = [[arrTempList objectAtIndex:i] objectForKey:@"word"];
        objFlashcardSet.strDefinition = [[arrTempList objectAtIndex:i] objectForKey:@"definition"];
        objFlashcardSet.strDescription = [[arrTempList objectAtIndex:i] objectForKey:@"description"];
        //objFlashcardSet.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        objFlashcardSet.intIndex = i;
        [flashcardData addObject:objFlashcardSet];
    }
    return flashcardData;
}

-(NSMutableArray *) fnGetAllAlphabetFlashcards:(NSString *)word
{
    FlashcardsSet *objFlashcardSet;
    NSMutableArray *flashcardData = [[NSMutableArray  alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT flashcard_id, chapter_id, word, definition, description FROM flashcards WHERE word LIKE '%@%%' ORDER BY word", word];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFlashcardSet = [FlashcardsSet new];
        objFlashcardSet.intFlashcardId = [[[arrTempList objectAtIndex:i] objectForKey:@"flashcard_id"] intValue];
        objFlashcardSet.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objFlashcardSet.strKey = [[arrTempList objectAtIndex:i] objectForKey:@"word"];
        objFlashcardSet.strDefinition = [[arrTempList objectAtIndex:i] objectForKey:@"definition"];
        objFlashcardSet.strDescription = [[arrTempList objectAtIndex:i] objectForKey:@"description"];
        //objFlashcardSet.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        objFlashcardSet.intIndex = i;
        [flashcardData addObject:objFlashcardSet];
    }
    return flashcardData;
}

-(NSMutableArray *) fnGetFlashcardsSet:(int)chapter_id
{
    FlashcardsSet *objFlashcardSet;
    NSMutableArray *flashcardData = [[NSMutableArray  alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT flashcard_id, chapter_id, word, definition, description FROM flashcards WHERE chapter_id = %d", chapter_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFlashcardSet = [FlashcardsSet new];
        objFlashcardSet.intFlashcardId = [[[arrTempList objectAtIndex:i] objectForKey:@"flashcard_id"] intValue];
        objFlashcardSet.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objFlashcardSet.strKey = [[arrTempList objectAtIndex:i] objectForKey:@"word"];
        objFlashcardSet.strDefinition = [[arrTempList objectAtIndex:i] objectForKey:@"definition"];
        objFlashcardSet.strDescription = [[arrTempList objectAtIndex:i] objectForKey:@"description"];
        //objFlashcardSet.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        objFlashcardSet.intIndex = i;
        [flashcardData addObject:objFlashcardSet];
    }
    return flashcardData;
}

-(NSMutableArray *) fnGetSortedFlashcards:(int)chapter_id
{
    FlashcardsSet *objFlashcardSet;
    NSMutableArray *flashcardData = [[NSMutableArray  alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT flashcard_id, chapter_id, word, definition, description FROM flashcards WHERE chapter_id = %d ORDER BY word", chapter_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFlashcardSet = [FlashcardsSet new];
        objFlashcardSet.intFlashcardId = [[[arrTempList objectAtIndex:i] objectForKey:@"flashcard_id"] intValue];
        objFlashcardSet.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objFlashcardSet.strKey = [[arrTempList objectAtIndex:i] objectForKey:@"word"];
        objFlashcardSet.strDefinition = [[arrTempList objectAtIndex:i] objectForKey:@"definition"];
        objFlashcardSet.strDescription = [[arrTempList objectAtIndex:i] objectForKey:@"description"];
        //objFlashcardSet.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        objFlashcardSet.intIndex = i;
        [flashcardData addObject:objFlashcardSet];
    }
    return flashcardData;
}

-(NSMutableArray *) fnGetAlphabetFlashcards:(int)chapter_id AndWord:(NSString *)word
{
    FlashcardsSet *objFlashcardSet;
    NSMutableArray *flashcardData = [[NSMutableArray  alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT flashcard_id, chapter_id, word, definition, description FROM flashcards WHERE chapter_id = %d AND word LIKE '%@%%' ORDER BY word", chapter_id, word];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFlashcardSet = [FlashcardsSet new];
        objFlashcardSet.intFlashcardId = [[[arrTempList objectAtIndex:i] objectForKey:@"flashcard_id"] intValue];
        objFlashcardSet.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objFlashcardSet.strKey = [[arrTempList objectAtIndex:i] objectForKey:@"word"];
        objFlashcardSet.strDefinition = [[arrTempList objectAtIndex:i] objectForKey:@"definition"];
        objFlashcardSet.strDescription = [[arrTempList objectAtIndex:i] objectForKey:@"description"];
        //objFlashcardSet.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        objFlashcardSet.intIndex = i;
        [flashcardData addObject:objFlashcardSet];
    }
    return flashcardData;
}

//--------------------------------------------------------------


//--------------------------------------------------------------
#pragma mark -
#pragma mark TestYourSelf
//--------------------------------------------------------------

//TestYourSelf Chapters
//--------------------------------------------------------------
-(void) fnGetTestyourselfChapterList
{
    
    Chapters *objTestChap;
    ThematicArea *objThematic;
    arr_chaptersTestAndFlashcard = [[NSMutableArray alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT chapter_id, chapter_title, isThematicArea,  category_id FROM chapters WHERE category_id = 2;"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objTestChap = [Chapters new];
        objTestChap.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objTestChap.strChapterTitle = [[arrTempList objectAtIndex:i] objectForKey:@"chapter_title"];
        objTestChap.intIsThematicArea = [[[arrTempList objectAtIndex:i] objectForKey:@"isThematicArea"] intValue];
        objTestChap.intCategoryId = [[[arrTempList objectAtIndex:i] objectForKey:@"category_id"] intValue];
        
        strQuery = [NSString stringWithFormat:@"SELECT thematic_id, thematic_title, thematic_sequence FROM thematic WHERE chapter_id = %d ORDER BY thematic_sequence;", objTestChap.intChapterId];
        arrSubTempList = [dbOperation getRowsForQuery:strQuery];
        intSubRowCount = [arrSubTempList count];
        for (int j = 0; j < intSubRowCount; j++) {
            objThematic = [ThematicArea new];
            objThematic.intThematicId = [[[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_id"] intValue];
            objThematic.strThematicTitle = [[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_title"];
            objThematic.intThematicSequence = [[[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_sequence"] intValue];
            
            [objTestChap.thematicData addObject:objThematic];
        }
        
        [arr_chaptersTestAndFlashcard addObject:objTestChap];
    }
}
//--------------------------------------------------------------

//TestYourSelf Question 
//--------------------------------------------------------------
-(NSMutableArray *) fnGetTestyourSelfQuestions:(int)chapter_id AndThematicId:(int)thematic_id
{
    NSMutableArray *questionData = [[NSMutableArray  alloc] init];
    ChapterQuestionSet *chapterQuestionSet;
    if (thematic_id == -1)
        strQuery = [NSString stringWithFormat:@"select testyourself_id,question_id,question_type, question_sequence from testyourself where chapter_id = %d  order by question_sequence", chapter_id];
	else
		
        strQuery = [NSString stringWithFormat:@"select testyourself_id,question_id,question_type, question_sequence from testyourself where chapter_id = %d  and thematic_id = %d order by question_sequence", chapter_id, thematic_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        chapterQuestionSet = [ChapterQuestionSet new];
        chapterQuestionSet.intId = [[[arrTempList objectAtIndex:i] objectForKey:@"testyourself_id"] intValue];
        chapterQuestionSet.strQuestionId = [[arrTempList objectAtIndex:i] objectForKey:@"question_id"];
        chapterQuestionSet.intType =  [[[arrTempList objectAtIndex:i] objectForKey:@"question_type"] intValue];
        chapterQuestionSet.intSequence = [[[arrTempList objectAtIndex:i] objectForKey:@"question_sequence"] intValue];
        
        [questionData addObject:chapterQuestionSet];
        
    }
    
    return questionData;
}
//--------------------------------------------------------------

//MCMS
//--------------------------------------------------------------
-(MCMS *)fnGetTestyourselfMCMS:(NSString *)question_id
{
    MCMS *objMCMS;
    strQuery = [NSString stringWithFormat:@"select mcms_id, question_text, options, options_text, answers, question_image, feedback, instruction from mcms where question_id = '%@'",question_id];

    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objMCMS = [MCMS new];
        objMCMS.intMCMSid = [[[arrTempList objectAtIndex:i] objectForKey:@"mcms_id"] intValue];
        objMCMS.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        objMCMS.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        objMCMS.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        objMCMS.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        objMCMS.strFeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        objMCMS.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];

        
    }
    return objMCMS;
}
//--------------------------------------------------------------

//Fill in the blanks
//--------------------------------------------------------------
-(FILLINBLANKS *)fnGetTestyourselfFillInTheBlanks:(NSString *)question_id
{
    FILLINBLANKS *objFillBlanks;
    strQuery = [NSString stringWithFormat:@"select fib_id, question_text, options, answers, question_image, feedback, instruction, ipad_normal_points, ipad_size, iphone_normal_size, iphone_size  from fillinblanks where question_id = '%@'",question_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objFillBlanks = [FILLINBLANKS new];
        objFillBlanks.intFillid = [[[arrTempList objectAtIndex:i] objectForKey:@"fib_id"] intValue];
        objFillBlanks.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        objFillBlanks.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        objFillBlanks.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        objFillBlanks.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        //objFillBlanks.strFeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        objFillBlanks.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
        NSString *str_pt = [[arrTempList objectAtIndex:i] objectForKey:@"ipad_normal_points"];
        
        if (str_pt == (id)[NSNull null] || str_pt.length == 0 )
            objFillBlanks.arrXYpoints = [[NSArray alloc] init];
        else
            objFillBlanks.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_normal_points"] componentsSeparatedByString:@"#$#"];        
        
        NSArray *widthhight;
        NSString *str_wh = [[arrTempList objectAtIndex:i] objectForKey:@"ipad_size"] ;
        if (str_wh == (id)[NSNull null] || str_wh.length == 0 )
            widthhight = [[NSArray alloc] init];
        else
            widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_size"] componentsSeparatedByString:@","];
        if (widthhight.count > 0) {
            objFillBlanks.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
            objFillBlanks.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
        }
        
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            str_pt = [[arrTempList objectAtIndex:i] objectForKey:@"iphone_normal_size"];
            
            if (str_pt == (id)[NSNull null] || str_pt.length == 0 )
                objFillBlanks.arrXYpoints = [[NSArray alloc] init];
            else
                objFillBlanks.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_normal_size"] componentsSeparatedByString:@"#$#"];
                        
            NSString *str_wh = [[arrTempList objectAtIndex:i] objectForKey:@"iphone_size"] ;
            if (str_wh == (id)[NSNull null] || str_wh.length == 0 )
                widthhight = [[NSArray alloc] init];
            else
                widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_size"] componentsSeparatedByString:@","];
            if (widthhight.count > 0) {
                objFillBlanks.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
                objFillBlanks.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
            }
            
            objFillBlanks.strImageName = [NSString stringWithFormat:@"%@_iphone", objFillBlanks.strImageName];

        }
        
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objFillBlanks.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objFillBlanks.arrFeedback addObject:objFeedback];
            }
        }
        
    }
    return objFillBlanks;
}
//--------------------------------------------------------------

//Radio Group
//--------------------------------------------------------------
-(RADIOHEADING *)fnGetTestyourselfRadioGroup:(NSString *)question_id
{

    RADIOBUTTONS *objRD;
    RADIOHEADING *objRH;
    strQuery = [NSString stringWithFormat:@"select heading_id, question_id, question_text, heading_text FROM RBHeading where question_id = '%@'",question_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objRH = [RADIOHEADING new];
        objRH.strQuestionId = [[arrTempList objectAtIndex:i] objectForKey:@"question_id"];
        objRH.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        objRH.strHeadingText = [[arrTempList objectAtIndex:i] objectForKey:@"heading_text"];
        objRH.arrHeadingText = [[[arrTempList objectAtIndex:i] objectForKey:@"heading_text"] componentsSeparatedByString:@"#$#"];
        objRH.arrRadioButtons  = [[NSMutableArray alloc] init];
        strQuery = [NSString stringWithFormat:@"SELECT data_id, question_sequence, question_text, options,  answers, feedback, instruction FROM RBData WHERE question_id = '%@';", question_id];
        arrSubTempList = [dbOperation getRowsForQuery:strQuery];
        intSubRowCount = [arrSubTempList count];
        for (int j = 0; j < intSubRowCount; j++) {
            objRD = [RADIOBUTTONS new];
            objRD.intRBid = [[[arrSubTempList objectAtIndex:j] objectForKey:@"data_id"] intValue];
            objRD.strQuestionText = [[arrSubTempList objectAtIndex:j] objectForKey:@"question_text"];
            objRD.intSequence = [[[arrSubTempList objectAtIndex:j] objectForKey:@"question_sequence"] intValue];
            objRD.arrOptions = [[[arrSubTempList objectAtIndex:j] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
            objRD.strAnswer = [[arrSubTempList objectAtIndex:j] objectForKey:@"answers"];
            objRD.strInstruction = [[arrSubTempList objectAtIndex:j] objectForKey:@"instruction"];
            
            NSArray *feedback = [[[arrSubTempList objectAtIndex:j] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            Feedback *objFeedback;
            
            objRD.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];                
                [objRD.arrFeedback addObject:objFeedback];
            }
            
            [objRH.arrRadioButtons addObject:objRD];
        }        
        
    }
    return objRH;
}
//--------------------------------------------------------------

//True False
//--------------------------------------------------------------
-(TRUEFLASE *)fnGetTestyourselfTrueFalse:(NSString *)question_id
{
    TRUEFLASE *objTF;
    strQuery = [NSString stringWithFormat:@"select tf_id, question_text, option_1, option_2,  answers, feedback, instruction from truefalse where question_id = '%@'",question_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objTF = [TRUEFLASE new];
        objTF.intTrueid = [[[arrTempList objectAtIndex:i] objectForKey:@"tf_id"] intValue];
        objTF.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objTF.strQuestionText == (id)[NSNull null] || objTF.strQuestionText.length == 0 )
            objTF.strQuestionText = @"";
        objTF.strOptions1 = [[arrTempList objectAtIndex:i] objectForKey:@"option_1"];
        objTF.strOptions2 = [[arrTempList objectAtIndex:i] objectForKey:@"option_2"];
        objTF.strAnswer = [[arrTempList objectAtIndex:i] objectForKey:@"answers"];
        //objTF.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        
        NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];        
        Feedback *objFeedback;
        
        objTF.arrFeedback = [[NSMutableArray alloc] init];
        
        for (int x = 0; x < feedback.count; x++) {
            NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
            objFeedback = [[Feedback alloc] init];
            objFeedback.strOption = [arrTemp objectAtIndex:0];
            objFeedback.strType = [arrTemp objectAtIndex:1];
            objFeedback.strFeedback = [arrTemp objectAtIndex:2];
            [objTF.arrFeedback addObject:objFeedback];
        }

        
        objTF.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
    }
    return objTF;
}
//--------------------------------------------------------------

//Match terms
//--------------------------------------------------------------
-(MATCHTERMS *)fnGetTestyourselfMatchTerms:(NSString *)question_id
{
    MATCHTERMS *objMatch;
    strQuery = [NSString stringWithFormat:@"select mc_id, question_text, option_1, option_2, answers, feedback, instruction from matching where question_id = '%@'",question_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objMatch = [MATCHTERMS new];
        objMatch.intMatchid = [[[arrTempList objectAtIndex:i] objectForKey:@"mc_id"] intValue];
        objMatch.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objMatch.strQuestionText == (id)[NSNull null] || objMatch.strQuestionText.length == 0 )
            objMatch.strQuestionText = @"";
        objMatch.arrOptions1 = [[[arrTempList objectAtIndex:i] objectForKey:@"option_1"] componentsSeparatedByString:@"#$#"];
        objMatch.arrOptions2 = [[[arrTempList objectAtIndex:i] objectForKey:@"option_2"] componentsSeparatedByString:@"#$#"];
        objMatch.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        //objMatch.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        
        objMatch.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];

        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
        
            //if (categoryNumber != 3) {
                
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objMatch.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objMatch.arrFeedback addObject:objFeedback];
            }
                
            //}
        
        }
    }
    return objMatch;
}
//--------------------------------------------------------------

//MCSS
//--------------------------------------------------------------
-(MCSS *)fnGetTestyourselfMCSS:(NSString *)question_id
{
    MCSS *objMCSS;
    strQuery = [NSString stringWithFormat:@"select mcss_id, question_text, options, answers, question_image, feedback, instruction from mcss where question_id = '%@'",question_id];
    
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objMCSS = [MCSS new];
        objMCSS.intMCSSid = [[[arrTempList objectAtIndex:i] objectForKey:@"mcss_id"] intValue];
        objMCSS.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objMCSS.strQuestionText == (id)[NSNull null] || objMCSS.strQuestionText.length == 0 )
            objMCSS.strQuestionText = @"";
        objMCSS.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        //objMCSS.arrAnswer = [[arrTempList objectAtIndex:i] objectForKey:@"answers"];
        objMCSS.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];        
        objMCSS.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        
        objMCSS.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
        
        }
        else {
            
            //if (categoryNumber != 3) {
            
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objMCSS.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objMCSS.arrFeedback addObject:objFeedback];
            //}
                
            }
        }
        
    }
    return objMCSS;
}
//--------------------------------------------------------------

//DRAG DROP
//--------------------------------------------------------------
-(DRAGDROP *)fnGetTestyourselfDRAGDROP:(NSString *)question_id
{
    DRAGDROP *objDRAGDROP;
    strQuery = [NSString stringWithFormat:@"select mcms_id, question_text, options, options_text, answers, question_image, feedback, instruction, ipad_normal_points, ipad_size, iphone_normal_points, iphone_size from mcms where question_id = '%@'",question_id];
    if (categoryNumber == 3) {
        strQuery = [NSString stringWithFormat:@"select mcms_id, question_text, options, options_text, answers, question_image, feedback, instruction, ipad_normal_points, ipad_size from mcms_cs where question_id = '%@'",question_id];
    }
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objDRAGDROP = [DRAGDROP new];
        objDRAGDROP.intDRAGDROPid = [[[arrTempList objectAtIndex:i] objectForKey:@"mcms_id"] intValue];
        objDRAGDROP.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objDRAGDROP.strQuestionText == (id)[NSNull null] || objDRAGDROP.strQuestionText.length == 0 )
            objDRAGDROP.strQuestionText = @"";
        objDRAGDROP.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.arrOptionsText = [[[arrTempList objectAtIndex:i] objectForKey:@"options_text"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        //objDRAGDROP.strFeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        objDRAGDROP.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];

        objDRAGDROP.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_normal_points"] componentsSeparatedByString:@"#$#"];
        
        NSArray *widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_size"] componentsSeparatedByString:@","];
        if (widthhight.count > 0) {
            objDRAGDROP.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
            objDRAGDROP.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
        }
        
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            objDRAGDROP.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_normal_points"] componentsSeparatedByString:@"#$#"];
            
            widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_size"] componentsSeparatedByString:@","];
            if (widthhight.count > 0) {
                objDRAGDROP.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
                objDRAGDROP.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
            }
            
            objDRAGDROP.strImageName = [NSString stringWithFormat:@"%@_iphone", objDRAGDROP.strImageName];            
        }
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objDRAGDROP.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objDRAGDROP.arrFeedback addObject:objFeedback];
            }
        }
    }
    return objDRAGDROP;
}
//--------------------------------------------------------------

//DRAG DROP Radio
//--------------------------------------------------------------
-(DragDropRadio *)fnGetTestyourselfDRAGDROPRadio:(NSString *)question_id
{
    DragDropRadio *objDRAGDROP;
    strQuery = [NSString stringWithFormat:@"select mcms_id, question_text, options, options_text, answers, question_image, feedback, instruction, ipad_normal_points, ipad_size, radio_options, radio_answers, iphone_normal_size, iphone_size  from dragdroprb where question_id = '%@'",question_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objDRAGDROP = [DragDropRadio new];
        objDRAGDROP.intDRAGDROPRADIOid = [[[arrTempList objectAtIndex:i] objectForKey:@"mcms_id"] intValue];
        objDRAGDROP.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objDRAGDROP .strQuestionText == (id)[NSNull null] || objDRAGDROP.strQuestionText.length == 0 )
            objDRAGDROP.strQuestionText = @"";
        objDRAGDROP.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.arrOptionsText = [[[arrTempList objectAtIndex:i] objectForKey:@"options_text"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        objDRAGDROP.strFeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        objDRAGDROP.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
        objDRAGDROP.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_normal_points"] componentsSeparatedByString:@"#$#"];

        objDRAGDROP.arrRadioOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"radio_options"] componentsSeparatedByString:@"#$#"];

        objDRAGDROP.arrRadioAnswers = [[[arrTempList objectAtIndex:i] objectForKey:@"radio_answers"] componentsSeparatedByString:@"#$#"];
        
        NSArray *widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_size"] componentsSeparatedByString:@","];
        if (widthhight.count > 0) {
            objDRAGDROP.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
            objDRAGDROP.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
        }
        
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            objDRAGDROP.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_normal_size"] componentsSeparatedByString:@"#$#"];
            
            widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_size"] componentsSeparatedByString:@","];
            if (widthhight.count > 0) {
                objDRAGDROP.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
                objDRAGDROP.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
            }
            
            objDRAGDROP.strImageName = [NSString stringWithFormat:@"%@_iphone", objDRAGDROP.strImageName];
        }
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objDRAGDROP.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objDRAGDROP.arrFeedback addObject:objFeedback];
            }
        }

    }
    return objDRAGDROP;
}
//--------------------------------------------------------------



//--------------------------------------------------------------
#pragma mark -
#pragma mark Casestudy
//--------------------------------------------------------------

//CaseStudy Chapters
//--------------------------------------------------------------
-(void) fnGetCaseStudyChapterList
{
    
    Chapters *objTestChap;
    ThematicArea *objThematic;
    arr_chaptersCaseStudy = [[NSMutableArray alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT chapter_id, chapter_title, isThematicArea,  category_id FROM chapters WHERE category_id = 3;"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objTestChap = [Chapters new];
        objTestChap.intChapterId = [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objTestChap.strChapterTitle = [[arrTempList objectAtIndex:i] objectForKey:@"chapter_title"];
        objTestChap.intIsThematicArea = [[[arrTempList objectAtIndex:i] objectForKey:@"isThematicArea"] intValue];
        objTestChap.intCategoryId = [[[arrTempList objectAtIndex:i] objectForKey:@"category_id"] intValue];
        
        strQuery = [NSString stringWithFormat:@"SELECT thematic_id, thematic_title, thematic_sequence FROM thematic WHERE chapter_id = %d ORDER BY thematic_sequence;", objTestChap.intChapterId];
        arrSubTempList = [dbOperation getRowsForQuery:strQuery];
        intSubRowCount = [arrSubTempList count];
        for (int j = 0; j < intSubRowCount; j++) {
            objThematic = [ThematicArea new];
            objThematic.intThematicId = [[[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_id"] intValue];
            objThematic.strThematicTitle = [[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_title"];
            objThematic.intThematicSequence = [[[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_sequence"] intValue];
            
            [objTestChap.thematicData addObject:objThematic];
        }
        
        [arr_chaptersCaseStudy addObject:objTestChap];
    }
}
//--------------------------------------------------------------


//CaseStudy Question
//--------------------------------------------------------------
-(NSMutableArray *) fnGetCaseStudyQuestions:(int)chapter_id AndThematicId:(int)thematic_id
{
    NSMutableArray *questionData = [[NSMutableArray  alloc] init];
    ChapterQuestionSet *chapterQuestionSet;
    if (thematic_id == -1)
        strQuery = [NSString stringWithFormat:@"select cs_id,question_id,question_type, question_sequence from casestudy where chapter_id = %d  order by question_sequence", chapter_id];
	else
		
        strQuery = [NSString stringWithFormat:@"select cs_id,question_id,question_type, question_sequence from casestudy where chapter_id = %d  and thematic_id = %d order by question_sequence", chapter_id, thematic_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        chapterQuestionSet = [ChapterQuestionSet new];
        chapterQuestionSet.intId = [[[arrTempList objectAtIndex:i] objectForKey:@"cs_id"] intValue];
        chapterQuestionSet.strQuestionId = [[arrTempList objectAtIndex:i] objectForKey:@"question_id"];
        chapterQuestionSet.intType =  [[[arrTempList objectAtIndex:i] objectForKey:@"question_type"] intValue];
        chapterQuestionSet.intSequence = [[[arrTempList objectAtIndex:i] objectForKey:@"question_sequence"] intValue];
        
        [questionData addObject:chapterQuestionSet];
        
    }
    
    return questionData;
}
//--------------------------------------------------------------

//MCSS
//--------------------------------------------------------------
-(MCSS *)fnGetCasestudyMCSS:(NSString *)question_id
{
    MCSS *objMCSS;
    strQuery = [NSString stringWithFormat:@"select mcss_id, question_text, options, answers, question_image, feedback, instruction, casestudy_text from mcss_cs where question_id = '%@'",question_id];
    
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objMCSS = [MCSS new];
        objMCSS.intMCSSid = [[[arrTempList objectAtIndex:i] objectForKey:@"mcss_id"] intValue];
        objMCSS.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objMCSS.strQuestionText == (id)[NSNull null] || objMCSS.strQuestionText.length == 0 )
            objMCSS.strQuestionText = @"";
        objMCSS.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        //objMCSS.arrAnswer = [[arrTempList objectAtIndex:i] objectForKey:@"answers"];
        objMCSS.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        objMCSS.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        
        objMCSS.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
        objMCSS.strCasestudyText = [[arrTempList objectAtIndex:i] objectForKey:@"casestudy_text"];
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
            
            //if (categoryNumber != 3) {
            
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objMCSS.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objMCSS.arrFeedback addObject:objFeedback];
                //}
                
            }
        }
        
    }
    return objMCSS;
}
//--------------------------------------------------------------
//--------------------------------------------------------------

//Match terms
//--------------------------------------------------------------
-(MATCHTERMS *)fnGetCasestudyMatchTerms:(NSString *)question_id
{
    MATCHTERMS *objMatch;
    strQuery = [NSString stringWithFormat:@"select mc_id, question_text, option_1, option_2, answers, feedback, instruction, casestudy_text from matching_cs where question_id = '%@'",question_id];
    
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objMatch = [MATCHTERMS new];
        objMatch.intMatchid = [[[arrTempList objectAtIndex:i] objectForKey:@"mc_id"] intValue];
        objMatch.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objMatch.strQuestionText == (id)[NSNull null] || objMatch.strQuestionText.length == 0 )
            objMatch.strQuestionText = @"";
        objMatch.arrOptions1 = [[[arrTempList objectAtIndex:i] objectForKey:@"option_1"] componentsSeparatedByString:@"#$#"];
        objMatch.arrOptions2 = [[[arrTempList objectAtIndex:i] objectForKey:@"option_2"] componentsSeparatedByString:@"#$#"];
        objMatch.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        //objMatch.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        
        objMatch.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
        objMatch.strCasestudyText = [[arrTempList objectAtIndex:i] objectForKey:@"casestudy_text"];
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
            
            //if (categoryNumber != 3) {
            
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objMatch.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objMatch.arrFeedback addObject:objFeedback];
            }
            
            //}
            
        }
    }
    return objMatch;
}
//--------------------------------------------------------------

//DRAG DROP
//--------------------------------------------------------------
-(DRAGDROP *)fnGetCasestudyDRAGDROP:(NSString *)question_id
{
    DRAGDROP *objDRAGDROP;
    strQuery = [NSString stringWithFormat:@"select mcms_id, question_text, options, options_text, answers, question_image, feedback, instruction, ipad_normal_points, ipad_size, casestudy_text, iphone_normal_size, iphone_size  from mcms_cs where question_id = '%@'",question_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objDRAGDROP = [DRAGDROP new];
        objDRAGDROP.intDRAGDROPid = [[[arrTempList objectAtIndex:i] objectForKey:@"mcms_id"] intValue];
        objDRAGDROP.strQuestionText = [[arrTempList objectAtIndex:i] objectForKey:@"question_text"];
        if (objDRAGDROP.strQuestionText == (id)[NSNull null] || objDRAGDROP.strQuestionText.length == 0 )
            objDRAGDROP.strQuestionText = @"";
        objDRAGDROP.arrOptions = [[[arrTempList objectAtIndex:i] objectForKey:@"options"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.arrOptionsText = [[[arrTempList objectAtIndex:i] objectForKey:@"options_text"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.arrAnswer = [[[arrTempList objectAtIndex:i] objectForKey:@"answers"] componentsSeparatedByString:@"#$#"];
        objDRAGDROP.strImageName = [[arrTempList objectAtIndex:i] objectForKey:@"question_image"];
        //objDRAGDROP.strFeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        objDRAGDROP.strInstruction = [[arrTempList objectAtIndex:i] objectForKey:@"instruction"];
        
        objDRAGDROP.strCasestudyText = [[arrTempList objectAtIndex:i] objectForKey:@"casestudy_text"];
        
        objDRAGDROP.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_normal_points"] componentsSeparatedByString:@"#$#"];
        
        NSArray *widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"ipad_size"] componentsSeparatedByString:@","];
        if (widthhight.count > 0) {
            objDRAGDROP.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
            objDRAGDROP.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
        }
        
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            objDRAGDROP.arrXYpoints = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_normal_size"] componentsSeparatedByString:@"#$#"];
            
            widthhight = [[[arrTempList objectAtIndex:i] objectForKey:@"iphone_size"] componentsSeparatedByString:@","];
            if (widthhight.count > 0) {
                objDRAGDROP.fWidth = [[widthhight objectAtIndex:0] floatValue]/2;
                objDRAGDROP.fHeight = [[widthhight objectAtIndex:1] floatValue]/2;
            }
            
            objDRAGDROP.strImageName = [NSString stringWithFormat:@"%@_iphone", objDRAGDROP.strImageName];
        }
        
        NSString *strfeedback = [[arrTempList objectAtIndex:i] objectForKey:@"feedback"];
        
        if (strfeedback == (id)[NSNull null] || strfeedback.length == 0 || [strfeedback isEqualToString:@" "]) {
            
        }
        else {
            NSArray *feedback = [[[arrTempList objectAtIndex:i] objectForKey:@"feedback"] componentsSeparatedByString:@"#$#"];
            
            Feedback *objFeedback;
            
            objDRAGDROP.arrFeedback = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < feedback.count; x++) {
                NSArray *arrTemp = [[feedback objectAtIndex:x] componentsSeparatedByString:@"$"];
                objFeedback = [[Feedback alloc] init];
                objFeedback.strOption = [arrTemp objectAtIndex:0];
                objFeedback.strType = [arrTemp objectAtIndex:1];
                objFeedback.strFeedback = [arrTemp objectAtIndex:2];
                [objDRAGDROP.arrFeedback addObject:objFeedback];
            }
        }
    }
    return objDRAGDROP;
}
//--------------------------------------------------------------
//--------------------------------------------------------------



//--------------------------------------------------------------
#pragma mark -
#pragma mark Notes
//--------------------------------------------------------------
-(void) fnSetNote:(Notes *)notes {
    strQuery = [NSString stringWithFormat:@"INSERT INTO Notes (category_id, chapter_id, thematic_id,  question_no, quiztrack_id, question_id, note_title, note_desc, note_history, modified_date, created_date) VALUES (%d, %d, %d, %d, %d, '%@', '%@', '%@', '%@', '%@', '%@')", notes.intCategoryId, notes.intChapterId, notes.intThematicId, notes.intQuestionNo, notes.intQuizTrackId, notes.strQuestionId, notes.strNoteTitle, notes.strNoteDesc, notes.strNoteHistory, notes.strModifiedDate, notes.strCreatedDate];
    error = [dbOperation doQuery:strQuery];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}
-(void) fnUpdateNote:(Notes *)notes {
    strQuery = [NSString stringWithFormat:@"UPDATE Notes SET note_desc = '%@', modified_date =  '%@', note_history = '%@',WHERE note_id = %d ", notes.strNoteDesc, notes.strModifiedDate, notes.strNoteHistory, notes.intNotesId];
    error = [dbOperation doQuery:strQuery];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}
-(Notes *) fnGetNote:(int)category_id AndChapterID:(int)chapter_id AndThematicId:(int)thematic_id AndQuestionNo:(int)question_no AndQuizTrackId:(int)quiz_id {

    
    Notes *objNote = [[Notes alloc] init];
    
    strQuery = [NSString stringWithFormat:@"SELECT note_id, note_title, note_desc, note_history, modified_date, created_date FROM Notes WHERE category_id = %d AND chapter_id = %d AND thematic_id = %d AND question_no = %d AND quiztrack_id = %d",category_id, chapter_id, thematic_id, question_no, quiz_id];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objNote.intNotesId  =   [[[arrTempList objectAtIndex:i] objectForKey:@"note_id"] intValue];
        objNote.strNoteTitle = [[arrTempList objectAtIndex:i] objectForKey:@"note_title"];
        objNote.strNoteDesc = [[arrTempList objectAtIndex:i] objectForKey:@"note_desc"];
        if (objNote.strNoteDesc == (id)[NSNull null] || objNote.strNoteDesc.length == 0 )
            objNote.strNoteDesc = @"";

        objNote.strNoteHistory = [[arrTempList objectAtIndex:i] objectForKey:@"note_history"];
        if (objNote.strNoteHistory == (id)[NSNull null] || objNote.strNoteHistory.length == 0 )
            objNote.strNoteHistory = @"";
        
        objNote.strModifiedDate  =    [[arrTempList objectAtIndex:i] objectForKey:@"modified_date"];
        
        objNote.strCreatedDate     =    [[arrTempList objectAtIndex:i] objectForKey:@"created_date"];
    }
    if (intRowCount == 0) {
        return nil;
    }
    return objNote;
}

-(NSMutableArray *) fnGetNotesList {
    
    NSMutableArray *arrNotes = [[NSMutableArray alloc] init];    
    
    strQuery = [NSString stringWithFormat:@"SELECT note_id, category_id, chapter_id, thematic_id,  question_no, note_title, note_desc, note_history,  modified_date, created_date FROM Notes ORDER BY modified_date"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        Notes *objNote = [[Notes alloc] init];        
        objNote.intNotesId  =   [[[arrTempList objectAtIndex:i] objectForKey:@"note_id"] intValue];
        objNote.intCategoryId   =   [[[arrTempList objectAtIndex:i] objectForKey:@"category_id"] intValue];
        objNote.intChapterId    =   [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objNote.intThematicId   =   [[[arrTempList objectAtIndex:i] objectForKey:@"thematic_id"] intValue];
        //objNote.strQuestionId   =    [[arrTempList objectAtIndex:i] objectForKey:@"question_id"];
        objNote.intQuestionNo   =   [[[arrTempList objectAtIndex:i] objectForKey:@"question_no"] intValue];
        objNote.strNoteTitle    =    [[arrTempList objectAtIndex:i] objectForKey:@"note_title"];
        
        objNote.strNoteDesc = [[arrTempList objectAtIndex:i] objectForKey:@"note_desc"];
        if (objNote.strNoteDesc == (id)[NSNull null] || objNote.strNoteDesc.length == 0 )
            objNote.strNoteDesc = @"";        

        objNote.strNoteHistory = [[arrTempList objectAtIndex:i] objectForKey:@"note_history"];
        if (objNote.strNoteHistory == (id)[NSNull null] || objNote.strNoteHistory.length == 0 )
            objNote.strNoteHistory = @"";
        
        objNote.strModifiedDate  =    [[arrTempList objectAtIndex:i] objectForKey:@"modified_date"];

        objNote.strCreatedDate     =    [[arrTempList objectAtIndex:i] objectForKey:@"created_date"];
        [arrNotes addObject:objNote];
    }
    return arrNotes;
}
-(void)Fn_DeleteNotes:(int)noteid{
    strQuery = [NSString stringWithFormat:@"DELETE FROM Notes WHERE note_id = %d ", noteid];
    error = [dbOperation doQuery:strQuery];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
	}
    
}
//--------------------------------------------------------------



//--------------------------------------------------------------
#pragma mark -
#pragma mark ScoreCard
//--------------------------------------------------------------
-(void) fnSetQuizTrack:(QuizTrack *)quiztrack {
    //CREATE TABLE "QuizTrack" ("track_id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "category_id" INTEGER, "chapter_id" INTEGER, "thematic_id" INTEGER, "quiz_title" TEXT, "question_ids" TEXT, "visited" TEXT, "selected_answers" TEXT, "correct_question" INTEGER, "missed_question" INTEGER, "Percentage" DOUBLE, "last_visited" INTEGER, "created_date" TEXT)
    
    strQuery = [NSString stringWithFormat:@"INSERT INTO QuizTrack (category_id, chapter_id, thematic_id, quiz_title, question_ids, visited, selected_answers, correct_question, missed_question, Percentage, last_visited, created_date, completed) VALUES (%d, %d, %d, '%@', '%@', '%@', '%@',%d, %d, %f, %d,'%@', %d)", quiztrack.intCategoryId, quiztrack.intChapterId, quiztrack.intThematicId, quiztrack.strQuizTitle, [quiztrack.arrQuestionIds componentsJoinedByString:@"#$#"], [quiztrack.arrVisited componentsJoinedByString:@"#$#"], [quiztrack.arrSelectedAnswer componentsJoinedByString:@"#$#"], quiztrack.intCorrectQuestion, quiztrack.intMissedQuestion, quiztrack.floatPercentage, quiztrack.intLastVisitedQuestion, quiztrack.strCreatedDate, quiztrack.intComplete];
    error = [dbOperation doQuery:strQuery];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
}
-(NSMutableArray *)fnGetScores {
    NSMutableArray *arrScore = [[NSMutableArray alloc] init];
    strQuery = [NSString stringWithFormat:@"SELECT track_id, category_id, chapter_id, thematic_id, quiz_title, question_ids, visited, selected_answers, correct_question, missed_question, Percentage, last_visited, created_date FROM QuizTrack ORDER BY track_id DESC LIMIT 5"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        QuizTrack *objQuiz = [[QuizTrack alloc] init];
        objQuiz.intQuizTrackId  =   [[[arrTempList objectAtIndex:i] objectForKey:@"track_id"] intValue];
        objQuiz.intCategoryId   =   [[[arrTempList objectAtIndex:i] objectForKey:@"category_id"] intValue];
        objQuiz.intChapterId    =   [[[arrTempList objectAtIndex:i] objectForKey:@"chapter_id"] intValue];
        objQuiz.intThematicId   =   [[[arrTempList objectAtIndex:i] objectForKey:@"thematic_id"] intValue];
        objQuiz.strQuizTitle    =    [[arrTempList objectAtIndex:i] objectForKey:@"quiz_title"];
        
        NSArray *q_ids = [[[arrTempList objectAtIndex:i] objectForKey:@"question_ids"] componentsSeparatedByString:@"#$#"];
        objQuiz.arrQuestionIds = [q_ids copy];
        
        NSArray *visit = [[[arrTempList objectAtIndex:i] objectForKey:@"visited"] componentsSeparatedByString:@"#$#"];
        objQuiz.arrVisited = [visit copy];
        
        NSArray *ans = [[[arrTempList objectAtIndex:i] objectForKey:@"selected_answers"] componentsSeparatedByString:@"#$#"];
        objQuiz.arrSelectedAnswer = [ans copy];
        
        objQuiz.intCorrectQuestion = [[[arrTempList objectAtIndex:i] objectForKey:@"correct_question"] intValue];
        objQuiz.intMissedQuestion = [[[arrTempList objectAtIndex:i] objectForKey:@"missed_question"] intValue];
        objQuiz.floatPercentage = [[[arrTempList objectAtIndex:i] objectForKey:@"Percentage"] floatValue];
        objQuiz.intLastVisitedQuestion = [[[arrTempList objectAtIndex:i] objectForKey:@"last_visited"] intValue];
        
        objQuiz.strCreatedDate  =    [[arrTempList objectAtIndex:i] objectForKey:@"created_date"];        
        [arrScore addObject:objQuiz];
    }

    return arrScore;
}
//--------------------------------------------------------------

//--------------------------------------------------------------
#pragma mark -
#pragma mark Database creation
//--------------------------------------------------------------
-(void) fnSetChapters
{    
    
    error = [dbOperation doQuery:@"CREATE TABLE 'testyourself_chapters' ('chapter_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'chapter_title' TEXT, 'isThematic' INTEGER);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbOperation doQuery:@"CREATE TABLE 'testyourself_thematic' ('tfst_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'chapter_id' INTEGER, 'thematic_id' INTEGER, 'thematic_title' TEXT);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    Chapters *objTestChap;
    ThematicArea *objThematic;
    strQuery = [NSString stringWithFormat:@"SELECT min(Craft_id) as Id, trim(Chapter_Name, ' ') as chapter_title  FROM CRAFT group by 2 order by 1"];
    arrTempList = [dbOperation getRowsForQuery:strQuery];
    intRowCount = [arrTempList count];
    for (int i = 0; i < intRowCount; i++) {
        objTestChap = [Chapters new];
        objTestChap.strChapterTitle = [[arrTempList objectAtIndex:i] objectForKey:@"chapter_title"];
               
        strQuery = [NSString stringWithFormat:@"select distinct(TRIM(Thematic_Area)) as thematic_title from CRAFT where trim(Thematic_Area) LIKE '%@'", objTestChap.strChapterTitle];
        arrSubTempList = [dbOperation getRowsForQuery:strQuery];
        intSubRowCount = [arrSubTempList count];
        
        int thematic = 0;
        
        if (intSubRowCount > 0) {
            thematic = 1;
        }
        
        strQuery = [NSString stringWithFormat:@"INSERT INTO testyourself_chapters (chapter_title, isThematic) VALUES (\"%@\",%d)", objTestChap.strChapterTitle, thematic];
        error = [dbOperation doQuery:strQuery];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        
        for (int j = 0; j < intSubRowCount; j++) {
            objThematic = [ThematicArea new];
            objThematic.strThematicTitle = [[arrSubTempList objectAtIndex:j] objectForKey:@"thematic_title"];
            [objTestChap.thematicData addObject:objThematic];
            
            strQuery = [NSString stringWithFormat:@"INSERT INTO testyourself_thematic (thematic_title, chapter_id, thematic_id) VALUES (\"%@\",%d,%d)", objThematic.strThematicTitle, i+1, j+1];
            error = [dbOperation doQuery:strQuery];
            if (error != nil) {
                NSLog(@"Error: %@",[error localizedDescription]);
            }
        }
         
    }
}
-(void) fnSetTestyourselfData
{
    
    //[self fnSetChapters];
    
    
    // Test Your Self
    // Create table
    
    error = [dbOperation doQuery:@"CREATE TABLE 'testyourself_bank' ('tfs_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,'chapter_id' INTEGER, 'thematic_id' INTEGER, 'question_type' INTEGER, 'template_id' TEXT, 'feedback' TEXT, 'question_sequence' INTEGER);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbOperation doQuery:@"CREATE TABLE 'mcss_new' ('mcss_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'template_id' TEXT, 'question_text' TEXT, 'options' TEXT, 'answers' TEXT, 'feedback' TEXT, 'instruction' TEXT);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbOperation doQuery:@"CREATE TABLE 'mcms_new' ('mcms_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'template_id' TEXT, 'question_text' TEXT, 'options' TEXT, 'answers' TEXT, 'feedback' TEXT, 'instruction' TEXT);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }

    error = [dbOperation doQuery:@"CREATE TABLE 'fillinblanks_new' ('fb_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'template_id' TEXT, 'question_text' TEXT, 'options' TEXT, 'answers' TEXT, 'feedback' TEXT, 'instruction' TEXT);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbOperation doQuery:@"CREATE TABLE 'true_false_new' ('tf_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'template_id' TEXT, 'question_text' TEXT, 'option_1' TEXT, 'option_2' TEXT, 'answers' TEXT, 'feedback' TEXT, 'instruction' TEXT);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbOperation doQuery:@"CREATE TABLE 'matching_new' ('mc_id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'template_id' TEXT, 'question_text' TEXT, 'option_1' TEXT, 'option_2' TEXT, 'answers' TEXT, 'feedback' TEXT, 'instruction' TEXT);"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    // Chapter
    
    
    // Thematic
    
    
    // Question Bank
    strQuery = [NSString stringWithFormat:@"SELECT * FROM CRAFT"];
    NSArray *arr_banks = [dbOperation getRowsForQuery:strQuery];
    int int_bank_count = [arr_banks count];
    for (int i = 0; i < int_bank_count; i++) {        
        
        int row_id = [[[arr_banks objectAtIndex:i] objectForKey:@"Craft_id"] intValue];
        
        NSString *templateid = nil;
        if (![[[arr_banks objectAtIndex:i] objectForKey:@"Template_ID"] isKindOfClass:[NSNull class]])
        {
            templateid = [NSString stringWithFormat:@"T%@", [[arr_banks objectAtIndex:i] objectForKey:@"Template_ID"]];            
        }
        
        
        NSString *feedback = [[arr_banks objectAtIndex:i] objectForKey:@"Feedback"];
        NSString *chaptername= [[arr_banks objectAtIndex:i] objectForKey:@"Chapter_Name"];

        int question_sequence;
        
        if ([[[arr_banks objectAtIndex:i] objectForKey:@"QuestionSequence"] isKindOfClass:[NSNull class]]) 
        {
            question_sequence = 0;
        }
        else {
            question_sequence = [[[arr_banks objectAtIndex:i] objectForKey:@"QuestionSequence"] intValue];
        }
        
        int thematic_id ;
        int chapter_id;
        int tmp_id;
        int question_type;
        
        //mcss_id = [[templateid substringFromIndex: [templateid length] - 2] intValue];
        
        strQuery = [NSString stringWithFormat:@"SELECT * FROM testyourself_thematic WHERE thematic_title = '%@' ", [[arr_banks objectAtIndex:i] objectForKey:@"Thematic_Area"]];
        NSArray *thematic_data = [dbOperation getRowsForQuery:strQuery];
        for (int x = 0; x < [thematic_data count]; x++) {
            thematic_id = [[[thematic_data objectAtIndex:x] objectForKey:@"thematic_id"] intValue];
        }

        
        NSArray *tempArray = [templateid componentsSeparatedByString:@"00"];
        
        if ([tempArray count] > 0) {
                
            
            int len_no = [[tempArray objectAtIndex:0] length];
            if (len_no == 3) {
                chapter_id = [[templateid substringWithRange:(NSMakeRange(1, 1))] intValue];
            }
            else {
                chapter_id = [[templateid substringWithRange:(NSMakeRange(1, 2))] intValue];
            }        
            question_type = [[templateid substringWithRange:(NSMakeRange(len_no-1, 1))] intValue];
                   
            tmp_id = [[tempArray objectAtIndex:1] intValue];
            
            if ([feedback isKindOfClass:[NSNull class]]) {
                feedback = @"''";
            }
            else {
                if ([feedback rangeOfString:@"\""].location == NSNotFound) {
                    if ([feedback rangeOfString:@"'"].location == NSNotFound) {
                        feedback = [NSString stringWithFormat:@"'%@'", feedback];
                    }
                    else {
                        feedback = [NSString stringWithFormat:@"\"%@\"", feedback];
                    }
                }
                else{
                    feedback = [NSString stringWithFormat:@"'%@'", feedback];
                }
            }
            
            if ([chaptername isKindOfClass:[NSNull class]]) {
                chaptername = @"''";
            }
            else {
                if ([chaptername rangeOfString:@"\""].location == NSNotFound) {
                    if ([chaptername rangeOfString:@"'"].location == NSNotFound) {
                        chaptername = [NSString stringWithFormat:@"'%@'", chaptername];
                    }
                    else {
                        chaptername = [NSString stringWithFormat:@"\"%@\"", chaptername];
                    }
                }
                else{
                    chaptername = [NSString stringWithFormat:@"'%@'", chaptername];
                }
            }
            
            
            // Check chapter exist
            
            NSString *newtemplate_id = [NSString stringWithFormat:@"'%d_%d_%d_%d'", chapter_id, thematic_id, question_type, tmp_id];
            
            strQuery = [NSString stringWithFormat:@"INSERT INTO testyourself (question_id, question_sequence, chapter_id, thematic_id,question_type) VALUES (%@,%d,%d, %d, %d);", newtemplate_id, question_sequence, chapter_id, thematic_id , question_type];
            
            //NSLog(@"%@ ", strQuery);
            
            error = [dbOperation doQuery:strQuery];
            if (error != nil) {
                NSLog(@"Error: %@",[error localizedDescription]);
            }
        
            
            
            switch (question_type) {
                case QUESTION_TYPE_MCMS:
                {
                    
                    strQuery = [NSString stringWithFormat:@"SELECT * FROM MCMS WHERE template_id = %@", [templateid substringFromIndex:1]];
                    NSArray *arrMCSS = [dbOperation getRowsForQuery:strQuery];
                    int intMCSSCount = [arrMCSS count];
                    for (int i = 0; i < intMCSSCount; i++) {
                        NSString *question = [[arrMCSS objectAtIndex:i] objectForKey:@"options"];
                        NSString *image = [[arrMCSS objectAtIndex:i] objectForKey:@"image_name"];
                        NSString *options = [[arrMCSS objectAtIndex:i] objectForKey:@"optionss"];
                        if ([options isKindOfClass:[NSNull class]])
                            options = @"";
                        
                        NSString *answer = [[arrMCSS objectAtIndex:i] objectForKey:@"corerct answer"];
                        if ([answer isKindOfClass:[NSNull class]])
                            answer = @"";                        
                        NSString *instruction = [[arrMCSS objectAtIndex:i] objectForKey:@"Instuction"];
                        if ([instruction isKindOfClass:[NSNull class]])
                            instruction = @"";
                        
                        strQuery = [NSString stringWithFormat:@"INSERT INTO mcms (question_id, question_text, options, answers, feedback, instruction, question_image) VALUES (%@, '%@',\"%@\",\"%@\",%@,'%@','%@');", newtemplate_id, question, options, answer, feedback, instruction, image];
                        //NSLog(@"%@ ", strQuery);
                        error = [dbOperation doQuery:strQuery];
                        if (error != nil) {
                            NSLog(@"Error: %@",[error localizedDescription]);
                        }
                    }
                    
                }
                    break;
                case QUESTION_TYPE_FILLINBLANKS:
                {
                    
                    strQuery = [NSString stringWithFormat:@"SELECT * FROM FIB WHERE template_id = %@", [templateid substringFromIndex:1]];
                    NSArray *arrMCSS = [dbOperation getRowsForQuery:strQuery];
                    int intMCSSCount = [arrMCSS count];
                    for (int i = 0; i < intMCSSCount; i++) {
                        NSString *question = [[arrMCSS objectAtIndex:i] objectForKey:@"text"];
                        NSString *image = [[arrMCSS objectAtIndex:i] objectForKey:@"image_name"];
                        NSString *options = [[arrMCSS objectAtIndex:i] objectForKey:@"options"];
                        if ([options isKindOfClass:[NSNull class]])
                            options = @"";
                        
                        NSString *answer = [[arrMCSS objectAtIndex:i] objectForKey:@"corerct_answer"];
                        if ([answer isKindOfClass:[NSNull class]])
                            answer = @"";
                        NSString *instruction = [[arrMCSS objectAtIndex:i] objectForKey:@"Instuction"];
                        if ([instruction isKindOfClass:[NSNull class]])
                            instruction = @"";
                        
                        strQuery = [NSString stringWithFormat:@"INSERT INTO fillinblanks (question_id, question_text, options, answers, feedback, instruction, question_image) VALUES (%@, '%@',\"%@\",\"%@\",%@,'%@', '%@');", newtemplate_id, question, options, answer, feedback, instruction, image];
                        //NSLog(@"%@ ", strQuery);
                        error = [dbOperation doQuery:strQuery];
                        if (error != nil) {
                            NSLog(@"Error: %@",[error localizedDescription]);
                        }
                    }
                    
                }
                    break;
                case QUESTION_TYPE_RADIOBUTTONS:
                {
                    
                }
                    break;
                case QUESTION_TYPE_TRUEFLASE:
                {
                    strQuery = [NSString stringWithFormat:@"SELECT * FROM true_false WHERE template_id = %@", [templateid substringFromIndex:1]];
                    NSArray *arrMCSS = [dbOperation getRowsForQuery:strQuery];
                    int intMCSSCount = [arrMCSS count];
                    for (int i = 0; i < intMCSSCount; i++) {
                        NSString *question = [[arrMCSS objectAtIndex:i] objectForKey:@"text"];
                        NSString *image_1 = [[arrMCSS objectAtIndex:i] objectForKey:@"image_name_1"];
                        NSString *image_2 = [[arrMCSS objectAtIndex:i] objectForKey:@"image_name_2"];
                        
                        NSString *answer = [[arrMCSS objectAtIndex:i] objectForKey:@"correct_image"];
                        NSString *instruction = [[arrMCSS objectAtIndex:i] objectForKey:@"LN_comments"];
                        if ([instruction isKindOfClass:[NSNull class]])
                            instruction = @"";
                        
                        strQuery = [NSString stringWithFormat:@"INSERT INTO truefalse (question_id, question_text, option_1, option_2, answers, feedback, instruction) VALUES (%@, '%@','%@', '%@','%@',%@,'%@');", newtemplate_id, question, image_1,image_2, answer, feedback, instruction];
                        NSLog(@"%@ ", strQuery);
                        error = [dbOperation doQuery:strQuery];
                        if (error != nil) {
                            NSLog(@"Error: %@",[error localizedDescription]);
                        }
                    }
                }
                    break;
                case QUESTION_TYPE_MATCHTERMS:                    
                {
                    strQuery = [NSString stringWithFormat:@"SELECT * FROM matching WHERE template_id = %@", [templateid substringFromIndex:1]];
                    NSArray *arrMCSS = [dbOperation getRowsForQuery:strQuery];
                    int intMCSSCount = [arrMCSS count];
                    for (int i = 0; i < intMCSSCount; i++) {
                        NSString *image_1 = [[arrMCSS objectAtIndex:i] objectForKey:@"column_1"];
                        NSString *image_2 = [[arrMCSS objectAtIndex:i] objectForKey:@"column_2"];
                        
                        NSString *answer = [[arrMCSS objectAtIndex:i] objectForKey:@"answers"];
                        NSString *instruction = [[arrMCSS objectAtIndex:i] objectForKey:@"LN_comments"];
                        if ([instruction isKindOfClass:[NSNull class]])
                            instruction = @"";
                        
                        strQuery = [NSString stringWithFormat:@"INSERT INTO matching_new (template_id, option_1, option_2, answers, feedback, instruction) VALUES (%@, '%@', '%@','%@','','%@')", newtemplate_id, image_1,image_2, answer, instruction];
                        //NSLog(@"%@ ", strQuery);
                        error = [dbOperation doQuery:strQuery];
                        if (error != nil) {
                            NSLog(@"Error: %@",[error localizedDescription]);
                        }
                    }

                }
                    break;
                case QUESTION_TYPE_MCSS:
                {
                    
                    strQuery = [NSString stringWithFormat:@"SELECT * FROM MCSS WHERE template_id = %@", [templateid substringFromIndex:1]];
                    NSArray *arrMCSS = [dbOperation getRowsForQuery:strQuery];
                    int intMCSSCount = [arrMCSS count];
                    for (int i = 0; i < intMCSSCount; i++) {
                        NSString *question = [[arrMCSS objectAtIndex:i] objectForKey:@"question_text"];
                        NSString *image = [[arrMCSS objectAtIndex:i] objectForKey:@"question_image"];
                        NSString *options = [[arrMCSS objectAtIndex:i] objectForKey:@"options"];
                        NSString *answer = [[arrMCSS objectAtIndex:i] objectForKey:@"corerct_answer"];
                        
                        if ([question rangeOfString:@"\""].location == NSNotFound) {
                            if ([question rangeOfString:@"'"].location == NSNotFound) {
                                question = [NSString stringWithFormat:@"'%@'", question];
                            }
                            else {
                                question = [NSString stringWithFormat:@"\"%@\"", question];
                            }
                        }
                        else{
                            question = [NSString stringWithFormat:@"'%@'", question];
                        }
                        
                        
                        
                        if ([options rangeOfString:@"\""].location == NSNotFound) {
                            if ([options rangeOfString:@"'"].location == NSNotFound) {
                                options = [NSString stringWithFormat:@"'%@'", options];
                            }
                            else {
                                options = [NSString stringWithFormat:@"\"%@\"", options];
                            }
                        }
                        else{
                            options = [NSString stringWithFormat:@"'%@'", options];
                        }
                        
                        
                        
                        if ([answer rangeOfString:@"\""].location == NSNotFound) {
                            if ([answer rangeOfString:@"'"].location == NSNotFound) {
                                answer = [NSString stringWithFormat:@"'%@'", answer];
                            }
                            else {
                                answer = [NSString stringWithFormat:@"\"%@\"", answer];
                            }
                        }
                        else{
                            answer = [NSString stringWithFormat:@"'%@'", answer];
                        }
                        
                        
                        strQuery = [NSString stringWithFormat:@"INSERT INTO mcss_new (template_id, question_text, options, answers, feedback, instruction) VALUES (%@, %@,%@,%@,%d,'%@')", newtemplate_id, question, options, answer, row_id, image];
                        //NSLog(@"%@ ", strQuery);
                        error = [dbOperation doQuery:strQuery];
                        if (error != nil) {
                            NSLog(@"Error: %@",[error localizedDescription]);
                        }
                    }
                    
                    }
                    
                    break;
            }
            
        }
    }
    
}


//--------------------------------------------------------------

@end
