//
//  Created by jve on 4/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DragContext.h"


@implementation DragContext {

    UIView *_draggedView;
    CGPoint _originalPosition;
        CGPoint firstPosition;
    UIView *_originalView;
    UIView *_firstView;
}
@synthesize draggedView = _draggedView;
@synthesize originalView = _originalView;

@synthesize firstPosition;
@synthesize firstView = _firstView;


- (id)initWithDraggedView:(UIView *)draggedView {
    self = [super init];
    if (self) {
        _draggedView = draggedView;
        _originalPosition = _draggedView.frame.origin;
        _originalView = draggedView.superview;
    }

    return self;
}


- (void)snapToOriginalPosition {
    [UIView animateWithDuration:0.3 animations:^() {
        CGPoint originalPointInSuperView = [_draggedView.superview convertPoint:_originalPosition fromView:_originalView];
        _draggedView.frame = CGRectMake(originalPointInSuperView.x, originalPointInSuperView.y, _draggedView.frame.size.width, _draggedView.frame.size.height);
    } completion:^(BOOL finished) {
        _draggedView.frame = CGRectMake(_originalPosition.x, _originalPosition.y, _draggedView.frame.size.width, _draggedView.frame.size.height);
        [_draggedView removeFromSuperview];
        [_originalView addSubview:_draggedView];
    }];
}

- (void)snapToFirstPositionwithDraggedView:(UIView *)dragdView withFirstPosition:(CGPoint)firstpos WithView:(UIView *)firstView{
    [UIView animateWithDuration:0.3 animations:^() {
        CGPoint originalPointInSuperView = [dragdView.superview convertPoint:firstpos fromView:firstView];
        dragdView.frame = CGRectMake(originalPointInSuperView.x, originalPointInSuperView.y, dragdView.frame.size.width, dragdView.frame.size.height);
        
    } completion:^(BOOL finished) {
        dragdView.frame = CGRectMake(firstpos.x, firstpos.y, dragdView.frame.size.width, dragdView.frame.size.height);
        [dragdView removeFromSuperview];
        [firstView addSubview:dragdView];
    }];
}


@end