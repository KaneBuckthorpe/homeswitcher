#import "KBButtonCell.h"

@implementation KBButtonCell
-(instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    
    
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KBButtonCell" specifier:specifier];
    
}
    
-(void)layoutSubviews{
    
    CGRect logoFrame;
    float screenWidth =self.bounds.size.width;
    CGRect labelFrame;
    CGFloat labelWidth=self.textLabel.attributedText.size.width;
    if ([platform isEqualToString:@"developer"]){
        
        logoFrame =CGRectMake((screenWidth/2)-30,10,60,60);
        labelFrame = CGRectMake(0, logoFrame.size.height+10, screenWidth, 30);
        
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0];
        self.textLabel.textAlignment = 1; 
    }else{
        float logoWidth=40;
        float labelOriginX=(screenWidth/2)-((labelWidth+logoWidth+5)/2)+5+logoWidth;
        
        float logoOriginX= labelOriginX-5-logoWidth;
        
        logoFrame =CGRectMake(logoOriginX,10, 30,30);
        
        labelFrame = CGRectMake(labelOriginX, 10, screenWidth-logoFrame.size.width+20, logoFrame.size.height);
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
        self.textLabel.textAlignment = 0; 
    }
    
    self.imageView.frame=logoFrame;
    self.textLabel.frame = labelFrame;
    
    
    if ([platform isEqualToString:@"paypal"]){
        
        self.textLabel.textColor=[UIColor colorWithRed:0 green:45.0f/255.0f blue:139.0f/255.0f alpha:1];
    }else if ([platform isEqualToString:@"twitter"]){
        self.textLabel.textColor=[UIColor colorWithRed:(29.0f/255.0f) green:(161.0f/255.0f) blue:(242.0f/255.0f) alpha:1];
    }
}
    ///Doesn't work but kept in anyway
-(CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 100;
}
    
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    platform = [[specifier propertyForKey:@"platform"] lowercaseString];
    
    self.imageView.image=[UIImage imageNamed:platform inBundle:[NSBundle bundleWithPath:@"/Library/PreferenceBundles/HomeSwitcher.bundle"] compatibleWithTraitCollection:nil];
    
    [self layoutSubviews];
}
    
    @end
