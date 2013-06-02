//
//  ChapterListViewController.h
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CasestudyChapterListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    
}

@property (nonatomic, assign) NSInteger openSectionIndex;

- (IBAction)Bn_Back_Tapped:(id)sender;
- (void) setAllArrowsRight;

@end
