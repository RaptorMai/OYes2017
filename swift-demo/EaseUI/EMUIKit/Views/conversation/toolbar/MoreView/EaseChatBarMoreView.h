
#import <UIKit/UIKit.h>

typedef enum{
    EMChatToolbarTypeChat,
    EMChatToolbarTypeGroup,
}EMChatToolbarType;

@protocol EaseChatBarMoreViewDelegate;
@interface EaseChatBarMoreView : UIView

@property (nonatomic,assign) id<EaseChatBarMoreViewDelegate> delegate;

@property (nonatomic) UIColor *moreViewBackgroundColor UI_APPEARANCE_SELECTOR; 

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type;

- (void)insertItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title;

- (void)updateItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title
                    atIndex:(NSInteger)index;

- (void)removeItematIndex:(NSInteger)index;

@end

@protocol EaseChatBarMoreViewDelegate <NSObject>

@optional

- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView;

//TODO: remove functions
//- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView;
//- (void)moreViewAudioCallAction:(EaseChatBarMoreView *)moreView;
//- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView;

- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index;

@end
