
#import <UIKit/UIKit.h>

#import "EaseFacialView.h"

@protocol EMFaceDelegate

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;
- (void)sendFaceWithEmotion:(EaseEmotion *)emotion;

@end

@interface EaseFaceView : UIView <EaseFacialViewDelegate>

@property (nonatomic, assign) id<EMFaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

- (void)setEmotionManagers:(NSArray*)emotionManagers;

@end
