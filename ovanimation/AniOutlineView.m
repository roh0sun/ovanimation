//
//  AniOutlineView.m
//  ovanimation
//
//  Created by ROH YOUNG SUN on 13. 5. 14..
//  Copyright (c) 2013년 openobject. All rights reserved.
//

#import "AniOutlineView.h"

@interface AniOutlineViewAnimation : NSAnimation
{
    NSView* _target;
}
@property (retain) NSView* target;
@end

@implementation AniOutlineViewAnimation
@synthesize target = _target;

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
    [_target setNeedsDisplay:YES];
    [super setCurrentProgress:progress];
}
@end

@implementation AniOutlineView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row
{
    return NSZeroRect;
}


- (void)drawExpandEffect
{
    if (_aniImage)
    {
        NSRect bounds = [self bounds];
        
        int y1 = _aniParentRect.origin.y + _aniParentRect.size.height;
        int y2 = _aniLastChildRect.origin.y + _aniLastChildRect.size.height;
        int dy = (y2 - y1);
        
        // 0 -> 1
        float f = [_aniObject currentProgress];
        
        NSRect fromRect = NSMakeRect(0, y1, bounds.size.width, bounds.size.height);
        NSRect toRect = NSMakeRect(0, (int)(y1 - dy + (dy * f)), bounds.size.width, bounds.size.height);
        [_aniImage drawInRect:toRect fromRect:fromRect operation:NSCompositeCopy fraction:1.0f];
        
        NSRect topRect = NSMakeRect(0, 0, bounds.size.width, y1);
        [_aniImage drawInRect:topRect fromRect:topRect operation:NSCompositeCopy fraction:1.0f];
    }
}

- (void)drawCollapseEffect
{
    if (_aniImage)
    {
        NSRect bounds = [self bounds];
        
        int y1 = _aniParentRect.origin.y + _aniParentRect.size.height;
        int y2 = _aniLastChildRect.origin.y + _aniLastChildRect.size.height;
        int dy = (y2 - y1);
        
        // 0 -> 1
        float f = [_aniObject currentProgress];
        
        NSRect fromRect = NSMakeRect(0, y1, bounds.size.width, bounds.size.height);
        NSRect toRect = NSMakeRect(0, (int)(y1 - (dy * f)), bounds.size.width, bounds.size.height);
        [_aniImage drawInRect:toRect fromRect:fromRect operation:NSCompositeCopy fraction:1.0f];
        
        NSRect topRect = NSMakeRect(0, 0, bounds.size.width, y1);
        [_aniImage drawInRect:topRect fromRect:topRect operation:NSCompositeCopy fraction:1.0f];
    }
}
- (void)drawRect:(NSRect)dirtyRect
{
    if (!_aniObject)
    {
        [super drawRect:dirtyRect];
    }
    else
    {
        [NSGraphicsContext saveGraphicsState];
        [self drawBackgroundInClipRect:dirtyRect];
        [NSGraphicsContext restoreGraphicsState];
        
        if (_yesIfExpand)
            [self drawExpandEffect];
        else
            [self drawCollapseEffect];
    }
}

- (BOOL)animationShouldStart:(NSAnimation*)animation
{
    return YES;
}

- (void)clearAnimation
{
    [_aniImage release];
    _aniImage = nil;
    [_aniObject release];
    _aniObject = nil;
    
    [self setNeedsDisplay];
}

- (void)animationDidStop:(NSAnimation*)animation
{
    [self clearAnimation];
}

- (void)animationDidEnd:(NSAnimation*)animation
{
    [self clearAnimation];
}

- (void)prepareViewImage
{
    NSRect bounds = [self bounds];
    
    bounds.size.width = MIN(bounds.size.width, 400);
    bounds.size.height = MIN(bounds.size.height, 4000);
    
    NSBitmapImageRep* bmp = [self bitmapImageRepForCachingDisplayInRect:bounds];
    if (bmp)
    {
        [self cacheDisplayInRect:bounds toBitmapImageRep:bmp];
        _aniImage = [[NSImage alloc] init];
        [_aniImage setFlipped:YES];
        [_aniImage addRepresentation:bmp];
        [_aniImage setSize:bounds.size];
    }
}

- (void)startAnimation
{
    _aniObject = [[AniOutlineViewAnimation alloc] initWithDuration:0.2 animationCurve:NSAnimationEaseIn];
    [_aniObject setAnimationBlockingMode:NSAnimationNonblocking];
    [_aniObject setFrameRate:50.0f];
    [_aniObject setDelegate:self];
    [_aniObject setTarget:self];
    [_aniObject startAnimation];
}

- (void)expandItem:(id)item
{
    [super expandItem:item];
    
    NSInteger parentRow = [self rowForItem:item];
    NSInteger nchild = [self.dataSource outlineView:self numberOfChildrenOfItem:item];
    if (parentRow >= 0 && nchild > 0)
    {
        [self prepareViewImage];
        if (_aniImage)
        {
            _yesIfExpand = YES;
            _aniParentRect = [self rectOfRow:parentRow];
            _aniLastChildRect = [self rectOfRow:parentRow + nchild];
            [self startAnimation];
        }
    }
}

- (void)collapseItem:(id)item
{
    NSInteger parentRow = [self rowForItem:item];
    NSInteger nchild = [self.dataSource outlineView:self numberOfChildrenOfItem:item];
    if (parentRow >= 0 && nchild > 0)
    {
        [self prepareViewImage];
        if (_aniImage)
        {
            _yesIfExpand = NO;
            _aniParentRect = [self rectOfRow:[self rowForItem:item]];
            _aniLastChildRect = [self rectOfRow:parentRow + nchild];
            [self startAnimation];
        }
    }
    
    [super collapseItem:item];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
	NSPoint point = [theEvent locationInWindow];
	point = [self convertPoint:point fromView:NULL];
	
    NSInteger col = [self columnAtPoint:point];
    if (col == 0)
    {
        NSInteger row = [self rowAtPoint:point];
        if (row >= 0)
        {
            id item = [self itemAtRow:row];
            if ([self isItemExpanded:item])
                [self collapseItem:item];
            else
                [self expandItem:item];
        }
    }
}

@end
