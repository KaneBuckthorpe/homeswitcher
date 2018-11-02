#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
    @end

@interface KBButtonCell : PSTableCell <PreferencesTableCustomView> {
    NSString *platform;
    UIImageView *logoView;
    UIImage *logo;
}
    @end
