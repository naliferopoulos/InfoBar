#include "IBPRootListController.h"

@implementation IBPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)openGithub {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/naliferopoulos"]];
}

- (void)openTwitter {
	NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=naliferopoulos"];
	if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
		[[UIApplication sharedApplication] openURL:twitterURL];
	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/naliferopoulos"]];
}
@end
