//
//  AppDelegate.h
//  ovanimation
//
//  Created by ROH YOUNG SUN on 13. 5. 14..
//  Copyright (c) 2013년 openobject. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AniOutlineView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet AniOutlineView* _outlineView;

    NSTreeNode* _folderRoot;
}

@property (assign) IBOutlet NSWindow *window;

@end
