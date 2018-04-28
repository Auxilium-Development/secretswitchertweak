#line 1 "Tweak.xm"
#import <objc/runtime.h>

#define PLIST_PATH @"/cygwin64/home/maxli/switcher/switcherPrefs/entry.plist" 

inline bool GetPrefBool(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

inline int GetPrefInt(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] intValue];
}

inline float GetPrefFloat(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] floatValue];
}



@interface FBSystemService : NSObject
+(id)sharedInstance;
- (void)exitAndRelaunch:(bool)arg1;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBAppSwitcherScrollView; @class FBSystemService; 
static void (*_logos_orig$_ungrouped$SBAppSwitcherScrollView$viewDidAppear)(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherScrollView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBAppSwitcherScrollView$viewDidAppear(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherScrollView* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$FBSystemService(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("FBSystemService"); } return _klass; }
#line 24 "Tweak.xm"
static void RespringDevice()
{
    [[_logos_static_class_lookup$FBSystemService() sharedInstance] exitAndRelaunch:YES];
}

static __attribute__((constructor)) void _logosLocalCtor_33e75ff0(int __unused argc, char __unused **argv, char __unused **envp)
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)RespringDevice, CFSTR("com.auxilium.switcherPrefs/respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately); 
}


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

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
 if ([gestureRecognizer isKindOfClass:[SBPSwitcherView class]]) {
return YES;
} else{
     return NO;
}
}
@end


static void _logos_method$_ungrouped$SBAppSwitcherScrollView$viewDidAppear(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherScrollView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
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
  _logos_orig$_ungrouped$SBAppSwitcherScrollView$viewDidAppear(self, _cmd);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBAppSwitcherScrollView = objc_getClass("SBAppSwitcherScrollView"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSwitcherScrollView, @selector(viewDidAppear), (IMP)&_logos_method$_ungrouped$SBAppSwitcherScrollView$viewDidAppear, (IMP*)&_logos_orig$_ungrouped$SBAppSwitcherScrollView$viewDidAppear);} }
#line 91 "Tweak.xm"
