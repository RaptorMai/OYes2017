

#import <UIKit/UIKit.h>

@interface EaseImageView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

@property (nonatomic) NSInteger badge;

@property (nonatomic) BOOL showBadge;

@property (nonatomic) CGFloat imageCornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat badgeSize UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *badgeFont UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *badgeTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *badgeBackgroudColor UI_APPEARANCE_SELECTOR;

@end
