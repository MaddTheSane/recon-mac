//
//  PSMTabBarControl.h
//  PSMTabBarControl
//
//  Created by John Pannell on 10/13/05.
//  Copyright 2005 Positive Spin Media. All rights reserved.
//

/*
 This view provides a control interface to manage a regular NSTabView.  It looks and works like the tabbed browsing interface of many popular browsers.
 */

#import <Cocoa/Cocoa.h>

#define PSMTabDragDidEndNotification @"PSMTabDragDidEndNotification"
#define PSMTabDragDidBeginNotification @"PSMTabDragDidBeginNotification"

#define kPSMTabBarControlHeight 22
// internal cell border
#define MARGIN_X        6
#define MARGIN_Y        3
// padding between objects
#define kPSMTabBarCellPadding 4
// fixed size objects
#define kPSMMinimumTitleWidth 30
#define kPSMTabBarIndicatorWidth 16.0
#define kPSMTabBarIconWidth 16.0
#define kPSMHideAnimationSteps 2.0

// Value used in _currentStep to indicate that resizing operation is not in progress
#define kPSMIsNotBeingResized -1

// Value used in _currentStep when a resizing operation has just been started
#define kPSMStartResizeAnimation 0

@class PSMOverflowPopUpButton;
@class PSMRolloverButton;
@class PSMTabBarCell;
@protocol PSMTabStyle;
@protocol TabBarControlDelegate;

typedef NS_ENUM(NSInteger, PSMTabBarOrientation) {
	PSMTabBarHorizontalOrientation,
	PSMTabBarVerticalOrientation
};

typedef NS_OPTIONS(UInt32, PSMTabState) {
    PSMTab_SelectedMask             = 1 << 1,
    PSMTab_LeftIsSelectedMask       = 1 << 2,
    PSMTab_RightIsSelectedMask      = 1 << 3,
    PSMTab_PositionLeftMask         = 1 << 4,
    PSMTab_PositionMiddleMask       = 1 << 5,
    PSMTab_PositionRightMask        = 1 << 6,
    PSMTab_PositionSingleMask       = 1 << 7
};

typedef NS_ENUM(NSInteger, PSMTabLocation) {
    PSMTab_TopTab           = 0,
    PSMTab_BottomTab		= 1
};

@interface PSMTabBarControl : NSControl <NSTabViewDelegate, NSDraggingSource>
{    
    // control basics
    NSMutableArray              *_cells;                    // the cells that draw the tabs
    NSTabView          			*tabView;                   // the tab view being navigated
    PSMOverflowPopUpButton      *_overflowPopUpButton;      // for too many tabs
    PSMRolloverButton           *_addTabButton;
    
    // drawing style
    id<PSMTabStyle>             style;
    BOOL                        _canCloseOnlyTab;
	BOOL						_disableTabClose;
    BOOL                        _hideForSingleTab;
    BOOL                        _showAddTabButton;
    BOOL                        _sizeCellsToFit;
    BOOL                        _useOverflowMenu;
	int							_resizeAreaCompensation;
	PSMTabBarOrientation		_orientation;
	BOOL						_automaticallyAnimates;
	NSTimer						*_animationTimer;
	CGFloat						_animationDelta;
	
	// behavior
	BOOL						_allowsBackgroundTabClosing;
	BOOL						_selectsTabsOnMouseDown;
	
	// vertical tab resizing
	BOOL						_allowsResizing;
	BOOL						_resizing;
	
    // cell width
    NSInteger                   _cellMinWidth;
    NSInteger                   _cellMaxWidth;
    NSInteger                   _cellOptimumWidth;
    
    // animation for hide/show
    int                         _currentStep;
    BOOL                        _isHidden;
    BOOL                        _hideIndicators;
    id                 			partnerView;                // gets resized when hide/show
    BOOL                        _awakenedFromNib;
	int							_tabBarWidth;
    
    // drag and drop
    NSEvent                     *_lastMouseDownEvent;      // keep this for dragging reference
	BOOL						_didDrag;
	BOOL						_closeClicked;
    
    // MVC help
    __weak id<TabBarControlDelegate> delegate;
    
    // orientation, top or bottom
    PSMTabLocation              _tabLocation;
}

// control characteristics
+ (NSBundle *)bundle;

// control configuration
@property (nonatomic) PSMTabBarOrientation orientation;
@property (nonatomic) BOOL canCloseOnlyTab;
@property (nonatomic) BOOL disableTabClose;
@property (nonatomic, strong) id<PSMTabStyle> style;
@property (weak, setter=setStyleNamed:) NSString *styleName;
@property (nonatomic) BOOL hideForSingleTab;
@property (nonatomic) BOOL showAddTabButton;
@property (nonatomic) NSInteger cellMinWidth;
@property (nonatomic) NSInteger cellMaxWidth;
@property (nonatomic) NSInteger cellOptimumWidth;
@property (nonatomic) BOOL sizeCellsToFit;
@property (nonatomic) BOOL useOverflowMenu;
@property (nonatomic) BOOL allowsBackgroundTabClosing;
@property BOOL allowsResizing;
@property BOOL selectsTabsOnMouseDown;
@property BOOL automaticallyAnimates;
@property PSMTabLocation tabLocation;

// accessors
@property (strong) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet id<TabBarControlDelegate> delegate;
@property (strong) IBOutlet id partnerView;

// the buttons
@property (readonly, strong) PSMRolloverButton *addTabButton;
@property (readonly, strong) PSMOverflowPopUpButton *overflowPopUpButton;

// tab information
- (NSMutableArray *)representedTabViewItems;
@property (readonly) NSInteger numberOfVisibleTabs;

// special effects
- (void)hideTabBar:(BOOL)hide animate:(BOOL)animate;
@property (readonly, getter=isTabBarHidden) BOOL tabBarHidden;

// internal bindings methods also used by the tab drag assistant
- (void)bindPropertiesForCell:(PSMTabBarCell *)cell andTabViewItem:(NSTabViewItem *)item;
- (void)removeTabForCell:(PSMTabBarCell *)cell;
- (void)setLabelColor:(NSColor *)aColor forTabViewItem:(NSTabViewItem *) tabViewItem;

- (void)tabClick:(id)sender;
@end


@protocol TabBarControlDelegate <NSObject, NSTabViewDelegate>

@optional

//Standard NSTabView methods
- (BOOL)tabView:(NSTabView *)aTabView shouldCloseTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)aTabView didCloseTabViewItem:(NSTabViewItem *)tabViewItem;

//"Spring-loaded" tabs methods
- (NSArray *)allowedDraggedTypesForTabView:(NSTabView *)aTabView;
- (void)tabView:(NSTabView *)aTabView acceptedDraggingInfo:(id <NSDraggingInfo>)draggingInfo onTabViewItem:(NSTabViewItem *)tabViewItem;

//Contextual menu method
- (NSMenu *)tabView:(NSTabView *)aTabView menuForTabViewItem:(NSTabViewItem *)tabViewItem;

//Drag and drop methods
- (BOOL)tabView:(NSTabView *)aTabView shouldDragTabViewItem:(NSTabViewItem *)tabViewItem fromTabBar:(PSMTabBarControl *)tabBarControl;
- (BOOL)tabView:(NSTabView *)aTabView shouldDropTabViewItem:(NSTabViewItem *)tabViewItem inTabBar:(PSMTabBarControl *)tabBarControl;
- (void)tabView:(NSTabView*)aTabView didDropTabViewItem:(NSTabViewItem *)tabViewItem inTabBar:(PSMTabBarControl *)tabBarControl;

//Tear-off tabs methods
- (NSImage *)tabView:(NSTabView *)aTabView imageForTabViewItem:(NSTabViewItem *)tabViewItem offset:(NSSize *)offset styleMask:(unsigned int *)styleMask;
- (PSMTabBarControl *)tabView:(NSTabView *)aTabView newTabBarForDraggedTabViewItem:(NSTabViewItem *)tabViewItem atPoint:(NSPoint)point;
- (void)tabView:(NSTabView *)aTabView closeWindowForLastTabViewItem:(NSTabViewItem *)tabViewItem;

//Overflow menu validation
- (BOOL)tabView:(NSTabView *)aTabView validateOverflowMenuItem:(NSMenuItem*)menuItem forTabViewItem:(NSTabViewItem *)tabViewItem;

//tab bar hiding methods
- (void)tabView:(NSTabView *)aTabView tabBarDidHide:(PSMTabBarControl *)tabBarControl;
- (void)tabView:(NSTabView *)aTabView tabBarDidUnhide:(PSMTabBarControl *)tabBarControl;

//tooltips
- (NSString *)tabView:(NSTabView *)aTabView toolTipForTabViewItem:(NSTabViewItem *)tabViewItem;

//accessibility
- (NSString *)accessibilityStringForTabView:(NSTabView *)aTabView objectCount:(NSInteger)objectCount;

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView willRemoveTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView willAddTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView willInsertTabViewItem:(NSTabViewItem *)tabViewItem atIndex:(NSInteger) index;
- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)tabView;

// iTerm add-on
- (void)setLabelColor:(NSColor *)aColor forTabViewItem:(NSTabViewItem *) tabViewItem;
- (void)closeSession:(id)identifier;
- (void)tabView:(NSTabView *)tabView doubleClickTabViewItem:(NSTabViewItem *)tabViewItem;

@end
