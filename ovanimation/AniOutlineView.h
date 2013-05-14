//
//  AniOutlineView.h
//  ovanimation
//
//  Created by ROH YOUNG SUN on 13. 5. 14..
//  Copyright (c) 2013년 openobject. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AniOutlineViewAnimation;

@interface AniOutlineView : NSOutlineView<NSAnimationDelegate>
{
    BOOL _yesIfExpand;
    NSImage* _aniImage;
    NSRect _aniParentRect;
    NSRect _aniLastChildRect;
    AniOutlineViewAnimation* _aniObject;
}

@end
