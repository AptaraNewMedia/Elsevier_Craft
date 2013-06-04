//
//  NotesListNewViewController.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 10/05/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "NotesListNewViewController.h"
#import "NotesCell.h"
#import "Notes.h"
#import "Chapters.h"
#import "ThematicArea.h"
#import "FlashCardsViewController.h"
#import "TestYourSelfViewController.h"
#import "CaseStudyViewController.h"

@interface NotesListNewViewController ()
{
    IBOutlet UIImageView *imgPatch;
    //    IBOutlet UIImageView *imgBG;
    //    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnClose;
    IBOutlet UITableView *tbl;
    
    IBOutlet UILabel *lblTitleSerialNo;
    IBOutlet UILabel *lblTitleName;
    IBOutlet UILabel *lblTitleDescription;
    IBOutlet UILabel *lblTitleDate;
    
    IBOutlet UITextField *txtSearch;
    
    NSMutableArray * arrNotes;
    Notes *objNotes;
    
    NSMutableArray *arrsearch;
    
    int currentOrientation;
    FlashCardsViewController *flashCardsViewController;
    TestYourSelfViewController *testYourSelfViewController;
    CaseStudyViewController *caseStudyViewController;
    
    
    // 1- Landscape
    // 2- Portrait
}
@end

@implementation NotesListNewViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrNotes = [db fnGetNotesList];
    arrsearch = [[NSMutableArray alloc] init];
    arrsearch = arrNotes;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        txtSearch.font = FONT_8;
    }
    else
    {
        txtSearch.font = FONT_17;
    }
    
    txtSearch.delegate = self;
    txtSearch.textColor = COLOR_BLACK;
    
    //    lblTitle.font = FONT_20;
    //    lblTitle.textColor = COLOR_WHITE;
    
    btnClose.hidden = YES;    
    
}
-(IBAction)onClose:(id)sender{
    [md Fn_SubNotesList];
}

// Tables

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrNotes.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"tblCellView";
    NotesCell *cell = (NotesCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            NSArray *cellArray_Phone = [[NSBundle mainBundle] loadNibNamed:@"NotesCell_iPhone" owner:self options:nil];
            cell = [cellArray_Phone lastObject];
        }
        else
        {
            if (currentOrientation == 2) {
                NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"NotesCellP" owner:self options:nil];
                cell = [cellArray lastObject];
                
            }
            else  {
                NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"NotesCell" owner:self options:nil];
                cell = [cellArray lastObject];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        cell.lbl_serionNo.font = FONT_8;
        cell.lbl_name.font = FONT_8;
        cell.lbl_date.font = FONT_8;
        cell.lbl_desc.font = FONT_8;
    }
    else
    {
        cell.lbl_serionNo.font = FONT_17;
        cell.lbl_name.font = FONT_17;
        cell.lbl_date.font = FONT_17;
        cell.lbl_desc.font = FONT_17;
    }
    
    cell.lbl_serionNo.textColor = COLOR_BLACK;
    cell.lbl_name.textColor = COLOR_BLACK;
    cell.lbl_date.textColor = COLOR_BLACK;
    cell.lbl_desc.textColor = COLOR_BLACK;
    
    cell.lbl_name.numberOfLines = 3;
    
    
    objNotes = (Notes *)[arrNotes objectAtIndex:indexPath.row];
    cell.lbl_serionNo.text = [NSString stringWithFormat:@"%d",objNotes.intNotesId];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@",objNotes.strNoteTitle];
    cell.lbl_date.text = [NSString stringWithFormat:@"%@", objNotes.strCreatedDate];
    cell.lbl_desc.text = [NSString stringWithFormat:@"%@", objNotes.strNoteDesc];
    //    if(currentOrientation == 2){
    //        NSLog(@"protrait");
    //        cell.imgview_cellpatch.image = [UIImage imageNamed:@"white_patch_with_line.png"];
    //    }
    //    else{
    //        NSLog(@"protrait");
    //        cell.imgview_cellpatch.image = [UIImage imageNamed:@"img_notelist_centerrow.png"];
    //    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    objNotes = (Notes *)[arrNotes objectAtIndex:indexPath.row];
    
    //Navigation Logic
    //[md Fn_SubNotesList];
    
    
    
    NSString *message;
    if(objNotes.intCategoryId == 1){
        //Flash Cards
        message = @"Flash Cards";
        categoryNumber = 1;
        
        intCurrentFlashcard_ChapterId = objNotes.intChapterId;
        
        Chapters *objChap = (Chapters *)[arr_chaptersTestAndFlashcard objectAtIndex:intCurrentFlashcard_ChapterId-1];
        str_BarTitle = [NSString stringWithFormat:@"Flash Cards - %@", objChap.strChapterTitle];
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPhone5" bundle:nil];
        }
        else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPhone" bundle:nil];
        }
        else {
            flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:flashCardsViewController animated:YES];
        
        
        [flashCardsViewController disableAllButtons:objNotes.intQuestionNo];
        
        
        
    }
    else if(objNotes.intCategoryId == 2){
        //Test Yourself
        message = @"Test Yourself";
        categoryNumber = 2;
        
        
        intCurrentTestYourSelf_ChapterId = objNotes.intChapterId;
        intCurrentTestYourSelf_ThematicId = -1;
        
        Chapters *objChap = (Chapters *)[arr_chaptersTestAndFlashcard objectAtIndex:objNotes.intChapterId-1];
        
        str_BarTitle = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        strCurrentChapterName = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        
        ThematicArea *objThematic;
        if(objNotes.intThematicId!=0) {
            intCurrentTestYourSelf_ThematicId = objNotes.intThematicId;
            objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:objNotes.intThematicId - 1];
            str_BarTitle = [NSString stringWithFormat:@"%@ - %@", objChap.strChapterTitle, objThematic.strThematicTitle];
            strCurrentThematicName = [NSString stringWithFormat:@"%@",  objThematic.strThematicTitle];
            
        }
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            testYourSelfViewController = [[TestYourSelfViewController alloc] initWithNibName:@"TestYourSelfViewController_iPhone5" bundle:nil];
        }
        else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            testYourSelfViewController = [[TestYourSelfViewController alloc] initWithNibName:@"TestYourSelfViewController_iPhone" bundle:nil];
        }
        else {
            testYourSelfViewController = [[TestYourSelfViewController alloc] initWithNibName:@"TestYourSelfViewController_iPad" bundle:nil];
            
        }
        [self.navigationController pushViewController:testYourSelfViewController animated:YES];
        [testYourSelfViewController disableAllButtons:objNotes.intQuestionNo];
        
    }
    else if(objNotes.intCategoryId == 3){
        //Case Studies
        message = @"Case Studies";
        categoryNumber = 3;
        
        intCurrentCaseStudy_ChapterId = objNotes.intChapterId;
        intCurrentCaseStudy_ThematicId = -1;
        
        Chapters *objChap = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:objNotes.intChapterId-40];
        
        str_BarTitle = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        strCurrentChapterName = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        
        ThematicArea *objThematic;
        if(objNotes.intThematicId!=0) {
            intCurrentCaseStudy_ThematicId = objNotes.intThematicId;
            objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:objNotes.intThematicId - 1];
            str_BarTitle = [NSString stringWithFormat:@"%@ - %@", objChap.strChapterTitle, objThematic.strThematicTitle];
            strCurrentThematicName = [NSString stringWithFormat:@"%@",  objThematic.strThematicTitle];
            
        }
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPhone5" bundle:nil];
        }
        else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPhone" bundle:nil];
        }
        else {
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:caseStudyViewController animated:YES];
        [caseStudyViewController disableAllButtons:objNotes.intQuestionNo];
        
    }
    else{
        //Nothing
        message = @"";
    }
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *data = txtSearch.text;
    // [db Fn_GetSearchList:data];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i =0 ;i<[arrsearch count];i++)
    {
        objNotes = (Notes *)[arrNotes objectAtIndex:i];
        NSString *str11 = objNotes.strNoteDesc;
        NSLog(@"Str111 i%d  %@",i,objNotes.strNoteDesc);
        
        
        if ([str11 rangeOfString:data options:NSCaseInsensitiveSearch].location == NSNotFound)
        {
            NSLog(@"string does not contain data");
        }
        else {
            
            NSLog(@"string contains data!");
            NSLog(@"%@",objNotes.strNoteTitle);
            
            
            [arr addObject:objNotes];
            NSLog(@" Result %@",arr);
            
        }
    }
    arrNotes = arr;
    [tbl reloadData];
    
    arrNotes = arrsearch;
    return YES;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        objNotes = (Notes *)[arrNotes objectAtIndex:indexPath.row];
        //int int_success = [db Fn_DeleteNotes:obj.int_note_id];
        
        [db Fn_DeleteNotes:objNotes.intNotesId];
        
        [arrNotes removeObjectAtIndex:indexPath.row];
        [tbl reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return 25;
    }
    else {
        return 57;
    }
    return 0.0;
}


#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
