//
//  Created by jve on 4/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DragDropManager.h"
#import "DragContext.h"
#import "CustomDragButton.h"


@implementation DragDropManager {

    NSArray *_dragSubjects;
    NSArray *_dropAreas;
    DragContext *_dragContext;
    DragContext *_dragContextSwap;
    CGPoint tempPoint;
}

UIView *tempView;
@synthesize dragContext = _dragContext;
@synthesize dragContextSwap = _dragContextSwap;
@synthesize dropAreas = _dropAreas;


- (id)initWithDragSubjects:(NSArray *)dragSubjects andDropAreas:(NSArray *)dropAreas {
    self = [super init];
    if (self) {
        _dropAreas = dropAreas ;
        _dragSubjects = dragSubjects ;
        _dragContext = nil;
        _dragContextSwap = nil;
    }

    return self;
}


- (void)dragObjectAccordingToGesture:(UIPanGestureRecognizer *)recognizer {
    if (self.dragContext) {
        CGPoint pointOnView = [recognizer locationInView:recognizer.view];
        self.dragContext.draggedView.center = pointOnView;
    }
}

- (void)dragging:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            for (UIView *dragSubject in _dragSubjects) {
                //todo: pointInside seems to answer no even tough the point is actually inside the view?
                CGPoint pointInSubjectsView = [recognizer locationInView:dragSubject];
                BOOL pointInSideDraggableObject = [dragSubject pointInside:pointInSubjectsView withEvent:nil];
                NSLog(@"point%@ %@ subject%@", NSStringFromCGPoint(pointInSubjectsView), pointInSideDraggableObject ? @"inside" : @"outside", NSStringFromCGRect(dragSubject.frame));
                if (pointInSideDraggableObject) {
                    NSLog(@"started dragging an object");
                    self.dragContext = [[DragContext alloc] initWithDraggedView:dragSubject] ;
                    tempView = dragSubject.superview;
                    tempPoint.x = dragSubject.frame.origin.x;
                    tempPoint.y = dragSubject.frame.origin.y;

                    
                    [dragSubject removeFromSuperview];
                    [recognizer.view addSubview:dragSubject];
                    [self dragObjectAccordingToGesture:recognizer];
                } else {
                    NSLog(@"started drag outside drag subjects");
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self dragObjectAccordingToGesture:recognizer];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.dragContext) {
                UIView *viewBeingDragged = self.dragContext.draggedView;
                NSLog(@"ended drag event");
                
                
                //CGPoint centerOfDraggedView = viewBeingDragged.center;
                
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++
                
                
                BOOL droppedViewInKnownArea = NO;
                //   for(int i = 0; i < [self.dropAreas count]; i++) {
                //     UIView *dropArea = [self.dropAreas objectAtIndex:i];
                for (UIView *dropArea in self.dropAreas) {
                    CGPoint pointInDropView = [recognizer locationInView:dropArea];
                    //NSLog(@"tag %li pointInDropView %@ center of dragged view %@", dropArea.tag, NSStringFromCGPoint(pointInDropView), NSStringFromCGPoint(centerOfDraggedView));
                    
                    if ([dropArea pointInside:pointInDropView withEvent:nil]) {
                        droppedViewInKnownArea = YES;
                        //NSLog(@"dropped subject %@ on to view tag %li", NSStringFromCGRect(viewBeingDragged.frame), dropArea.tag);
                        [viewBeingDragged removeFromSuperview];
                        
                        
                        
                        
                        for(UIView *view in [dropArea subviews]) {
                            if([view isKindOfClass:[UIButton class]]) {
                                CustomDragButton *bn = view;
                                self.dragContextSwap =[[DragContext alloc] initWithDraggedView:bn];
                                
                                [self.dragContextSwap snapToFirstPositionwithDraggedView:bn withFirstPosition:tempPoint WithView:tempView];
                                [view removeFromSuperview];
                            }
                        }
                        
                        [dropArea addSubview:viewBeingDragged];
                        
                        
                        //change origin to match offset on new super view
                        //viewBeingDragged.frame = CGRectMake(pointInDropView.x - (viewBeingDragged.frame.size.width / 2), pointInDropView.y - (viewBeingDragged.frame.size.height / 2), viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
                        viewBeingDragged.frame = CGRectMake(0, 0, viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
                    }
                }
                
                if (!droppedViewInKnownArea) {
                    NSLog(@"release draggable object outside target views - snapping back to last known location");
                    [self.dragContext snapToOriginalPosition];
                }
                
                self.dragContext = nil;
            } else {
                NSLog(@"Nothing was being dragged");
            }
            break;
        }
    }
}



@end