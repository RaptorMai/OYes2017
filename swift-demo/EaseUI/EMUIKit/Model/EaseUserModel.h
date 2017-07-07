
#import <Foundation/Foundation.h>

#import "IUserModel.h"

@interface EaseUserModel : NSObject<IUserModel>

@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;
@property (nonatomic) int unreadMessageCount;

- (instancetype)initWithUsername:(NSString *)username;

@end
