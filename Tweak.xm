#import <objc/runtime.h>
//Prefs
#define PLIST_PATH @"/cygwin64/home/maxli/switcher/switcherPrefs/entry.plist" //Change to your entry.plist path. Include file extension.

inline bool GetPrefBool(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

inline int GetPrefInt(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] intValue];
}

inline float GetPrefFloat(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] floatValue];
}
//End Prefs

//Respring function
@interface FBSystemService : NSObject
+(id)sharedInstance;
- (void)exitAndRelaunch:(bool)arg1;
@end

static void RespringDevice()
{
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)RespringDevice, CFSTR("com.auxilium.switcherPrefs/respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately); //Your Prefs Bundle + "/respring" (different form tweak bundle) See reference in /prefs/MotusPrefsRootListController.m
}
//End Respring

@interface SBPSwitcherWindow : UIWindow
@end

@interface SBPSwitcherView : UIView
@end

@interface SBAppSwitcherScrollView
+(id)sharedInstance;
+(void)presentAnimated:(BOOL)arg1;
@end

@implementation SBPSwitcherWindow
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIWindow *window in self.subviews) {
        if (!window.hidden && window.userInteractionEnabled && [window pointInside:[self convertPoint:point toView:window] withEvent:event])
            return YES;
    }
    return NO;
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
 if ([gestureRecognizer isKindOfClass:[SBPSwitcherView class]]) {
return YES;
} else{
     return NO;
}
}
@end

%hook SBAppSwitcherScrollView
-(void)viewDidAppear {
	float setNewWidth = GetPrefFloat(@"kWidth");
    float setNewAlpha = 0.5f;
    float setNewHeight = 300;
	UIWindow * screen = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];

	SBPSwitcherView * rightView=[[SBPSwitcherView alloc]initWithFrame:CGRectMake(screen.bounds.size.width, screen.bounds.size.height, - setNewWidth, - setNewHeight)];
    [rightView setBackgroundColor:[UIColor blackColor]];
    [rightView setAlpha: setNewAlpha];
    rightView.userInteractionEnabled = TRUE;

	SBPSwitcherView * leftView=[[SBPSwitcherView alloc]initWithFrame:CGRectMake(screen.bounds.origin.x, screen.bounds.size.height, setNewWidth, - setNewHeight)];
    [leftView setBackgroundColor:[UIColor blackColor]];
    [leftView setAlpha: setNewAlpha];
    leftView.userInteractionEnabled = TRUE;

	SBPSwitcherWindow *window = [[SBPSwitcherWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	window.windowLevel = 1005;
	[window setHidden:NO];
	[window setAlpha:1.0];
	[window setBackgroundColor:[UIColor clearColor]];
	[window addSubview:rightView];
	[window addSubview:leftView];
  %orig;
}
%end