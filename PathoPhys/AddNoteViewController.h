//
//  ScoreViewController.h
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Notes;

@interface AddNoteViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

- (void) Fn_LoadNoteData:(Notes *)notes;

@end
