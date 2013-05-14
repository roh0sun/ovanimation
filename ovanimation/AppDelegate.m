//
//  AppDelegate.m
//  ovanimation
//
//  Created by ROH YOUNG SUN on 13. 5. 14..
//  Copyright (c) 2013년 openobject. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib
{
    [self buildFolderTree];
    [_outlineView reloadData];
    [_outlineView setNeedsDisplay:YES];
}

- (NSArray*)childrenForItem:(id)item
{
    if (item == nil)
        return [_folderRoot childNodes];
    else
        return [item childNodes];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSArray *children = [self childrenForItem:item];
    return [children objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [[self childrenForItem:item] count] > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSArray *children = [self childrenForItem:item];
    return [children count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [[item representedObject] objectForKey:@"name"];
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
}

- (BOOL)outlineView:(NSOutlineView *)ov shouldSelectItem:(id)item
{
    return YES;
}

- (NSTreeNode*)treeNodeFromDictionary:(NSDictionary*)data
{
    NSTreeNode* result = [NSTreeNode treeNodeWithRepresentedObject:data];
    
    NSArray* children = [data objectForKey:@"children"];
    for (id item in children)
    {
        NSTreeNode* childNode = [self treeNodeFromDictionary:item];
        
        [[result mutableChildNodes] addObject:childNode];
    }
    
    return result;
}

static int sNodeIdx = 0;

- (void)buildNodeData:(NSMutableDictionary*)nodeData count:(NSInteger)count
{
    NSMutableArray* children = [NSMutableArray array];
    for (int i=0; i<count; ++i)
    {
        NSMutableDictionary* childData = [NSMutableDictionary dictionary];
        NSString* name = [NSString stringWithFormat:@"%d", sNodeIdx++];
        [childData setObject:name forKey:@"name"];
        [children addObject:childData];
    }
    [nodeData setObject:children forKey:@"children"];
}

- (void)buildFolderTree
{
    NSMutableDictionary* rootData = [NSMutableDictionary dictionary];
    NSString* name = [NSString stringWithFormat:@"%d", sNodeIdx++];
    [rootData setObject:name forKey:@"name"];
    [self buildNodeData:rootData count:5];
    NSArray* children = [rootData objectForKey:@"children"];
    for (NSMutableDictionary* nodeData in children)
    {
        [self buildNodeData:nodeData count:5];
    }
    
    _folderRoot = [[self treeNodeFromDictionary:rootData] retain];
}

@end
