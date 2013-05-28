//
//  ScoreViewController.m
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ScoreCardViewController.h"
#import "ScoreCardCell.h"
#import "QuizTrack.h"

@interface ScoreCardViewController ()
{
    IBOutlet UIImageView *imgPatch;
    IBOutlet UIImageView *imgBG;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnClose;
    IBOutlet UITableView *tbl;
    
    IBOutlet UILabel *lblTitleSerialNo;
    IBOutlet UILabel *lblTitleName;
    IBOutlet UILabel *lblTitleDate;
    IBOutlet UILabel *lblTitleScore;
    
    IBOutlet UIImageView *img_Cell;
    NSMutableArray * scoreArray;
    QuizTrack *objScore;
    int currentOrientation;
}
@end

@implementation ScoreCardViewController

 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    scoreArray = [db fnGetScores];
    lblTitle.font = FONT_20;
    lblTitle.textColor = COLOR_WHITE;
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

-(void) PopupView
{
    
}


-(IBAction)onClose:(id)sender
{
    [md Fn_SubScoreCard];
}

// Tables
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scoreArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ScoreCardCell *cell = (ScoreCardCell *)[tbl dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            NSArray *cellArray_Phone = [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCell_iPhone" owner:self options:nil];
            cell = [cellArray_Phone lastObject];
        }
        else
        {
            if (currentOrientation == 2) {
                NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellP" owner:self options:nil];
                cell = [cellArray lastObject];
                
            }
            else {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCell" owner:self options:nil];
                cell = [nib lastObject];
            }
        }
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        cell.lbl_serionNo.font = FONT_8;
        cell.lbl_name.font = FONT_8;
        cell.lbl_date.font = FONT_8;
        
        
        cell.lbl_serionNo.textColor = COLOR_BLACK;
        cell.lbl_name.textColor = COLOR_BLACK;
        cell.lbl_date.textColor = COLOR_BLACK;
        
        cell.lbl_name.numberOfLines = 3;
    }
    else
    {
        cell.lbl_serionNo.font = FONT_17;
        cell.lbl_name.font = FONT_17;
        cell.lbl_date.font = FONT_17;
        
        
        cell.lbl_serionNo.textColor = COLOR_BLACK;
        cell.lbl_name.textColor = COLOR_BLACK;
        cell.lbl_date.textColor = COLOR_BLACK;
    }
    
    objScore = [scoreArray objectAtIndex:indexPath.row];
    cell.lbl_serionNo.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@",objScore.strQuizTitle];
    //cell.lbl_score.text = [ [NSString alloc]initWithFormat:@"%.2f%%",objScore.floatPercentage];
    cell.lbl_score.text = [NSString stringWithFormat:@"%d of %d",objScore.intCorrectQuestion, objScore.intMissedQuestion + objScore.intCorrectQuestion];
    
    
    
    cell.backgroundColor = [UIColor redColor];
    
    //cell.lbl_date.text = [NSString stringWithFormat:@"%@", objScore.strCreatedDate];
    
    
    NSString *stringFromWS =[NSString stringWithString:objScore.strCreatedDate];
    //date formatter for the above string
    NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
    [dateFormatterWS setDateFormat:@"MM-dd-yyyy"];
    NSDate *date =[dateFormatterWS dateFromString:stringFromWS];
    
    //date formatter that you want
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:@"dd-MM-yyyy"];
    
    NSString *stringForNewDate = [dateFormatterNew stringFromDate:date];
    
    cell.lbl_date.text = stringForNewDate;
    
    cell.btn_share.hidden = YES;
    
    return cell;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        return NO;
    }
    
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        currentOrientation =1;
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
        currentOrientation =1;
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
        currentOrientation =2;
	}
	else {
        [self Fn_rotatePortrait];
        currentOrientation =2;
	}
    
	return YES;
}


-(void)Fn_rotatePortrait
{
    
    [self.view setFrame:CGRectMake(0,0,768,1024)];
    
    [imgPatch setImage:[UIImage imageNamed:@"P_Black_patch.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,768,1024)];
    
    [imgBG setImage:[UIImage imageNamed:@"Ipad_Portrait_TableBG.png"]];
    [imgBG setFrame:CGRectMake(30,67,709,710)];
    
    [img_Cell setImage:[UIImage imageNamed:@"Ipad_Portrait_Table01.png"]];
    [img_Cell setFrame:CGRectMake(57, 136, 655, 58)];    
    [lblTitle setFrame:CGRectMake(170,87,386,38)];
    [btnClose setFrame:CGRectMake(653,89,41,36)];
    [tbl setFrame:CGRectMake(57,195,655,430)];
    [lblTitleSerialNo setFrame:CGRectMake(72,143,61,38)];
    [lblTitleName setFrame:CGRectMake(130,143,386,38)];
    [lblTitleDate setFrame:CGRectMake(490,143,104,38)];
    [lblTitleScore  setFrame:CGRectMake(593,143,104,38)];
    
    [tbl reloadData];
}
-(void)Fn_rotateLandscape
{
    [self.view setFrame:CGRectMake(0,0,1024,768)];
    
    [imgPatch setImage:[UIImage imageNamed:@"L_Black_patch.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,1024,768)];
    
    [imgBG setImage:[UIImage imageNamed:@"BGImg_ScoreCard_with_Header.png"]];
    [imgBG setFrame:CGRectMake(134,67,755,615)];
    
    [img_Cell setImage:[UIImage imageNamed:@"Img_CellPatch.png"]];
    [img_Cell setFrame:CGRectMake(107, 127, 794, 57)];
    [lblTitle setFrame:CGRectMake(288,84,386,38)];
    [btnClose setFrame:CGRectMake(818,83,41,36)];
    [tbl setFrame:CGRectMake(145,182,722,336)];
    [lblTitleSerialNo setFrame:CGRectMake(156,135,61,38)];
    [lblTitleName setFrame:CGRectMake(242,135,386,38)];
    [lblTitleDate setFrame:CGRectMake(644,135,104,38)];
    [lblTitleScore  setFrame:CGRectMake(759,135,104,38)];
    
    [tbl reloadData];
    
}

@end
