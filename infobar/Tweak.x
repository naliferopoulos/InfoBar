#include <dlfcn.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Explain to the compiler what a _UIStatusBarStringView is.
@interface _UIStatusBarStringView : UILabel
-(void)setString:(NSString *)arg1;
@end

// Define our helper type (function pointer).
typedef NSString* (*helper)(void);

// Store our helpers.
NSMutableArray* helpers;

// Store whether InfoBar is enabled.
BOOL isEnabled;

// Helper for the original value.
NSString* Original()
{
	return nil;
}

// Store the currently displayed helper.
static int display = 0;

// Store an instance of the time originally, so that we can flip back to it when required.
static NSString* originalTime = nil;

%ctor
{
	// Determine whether InfoBar is enabled.
	NSDictionary* bundleDefaults = [[NSUserDefaults standardUserDefaults]
	persistentDomainForName:@"com.naliferopoulos.infobarpreferences"];

	if([[bundleDefaults valueForKey:@"enabled"] isEqual:@1])
		isEnabled = YES;
	else
		isEnabled = NO;

	// Initialize our helpers array.
	helpers = [[NSMutableArray alloc] init];

	// Add in our default helper.
	[helpers addObject: [NSValue valueWithPointer: Original]];

	// Fetch the list of helpers stored on the filesystem.
	NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/usr/lib/infobar/" error:NULL];
       
       	// Enumerate through each one.
        [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
        {
                NSString* filename = (NSString* ) obj;
                NSString* extension = [[filename pathExtension] lowercaseString];

                if([extension isEqualToString:@"dylib"])
                {
                        NSString* helperLibrary = [@"/usr/lib/infobar" stringByAppendingPathComponent:filename];

			// Load it.
                        void* handle = dlopen([helperLibrary UTF8String], RTLD_NOW);
                        
			// Grab its function.
                        helper sym = (helper)dlsym(handle, "GetInfo");

			// Add it to the list of helpers.
                        [helpers addObject: [NSValue valueWithPointer: sym]];
                }
        }]; 
}

%hook _UIStatusBarStringView

// Add a new method, as a tap action responder.
%new 
-(void) tapAction
{
	display++;

	if(display >= [helpers count])
		display = 0;

	if(originalTime)
		[self setText:originalTime];
}

// Hook initialization, to add a gesture recognizer and enable user interaction.
-(id) initWithFrame:(CGRect)arg1
{
	id o = %orig;

        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [recognizer setNumberOfTapsRequired:1];
	
	[self addGestureRecognizer:recognizer];
	
	self.userInteractionEnabled = YES;
	
	return o;
}


-(void) setText:(NSString *)text 
{
	// Make sure it is the timer label.
	if([text containsString:@":"] && isEnabled) 
	{
		// Save the original time for later.
		originalTime = text;

		// Adjust the width to fit.
		//self.adjustsFontSizeToFitWidth = YES;
	
		// Select a helper.	
		helper current = (helper)([[helpers objectAtIndex: display] pointerValue]);

		// And call it.
		NSString* new_text = current(); 

	
		// If we need to change the text, change it.
		if(new_text)
			text = new_text;
	}
	// It wasn't, so no need to update the stored timer.
	else 
	{
		originalTime = nil;
	}

	%orig;
	
	// Reset user interaction, because Apple's original code disables it for some reason.
	self.userInteractionEnabled = YES;
}
%end
