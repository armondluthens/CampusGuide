//
// Please report any problems with this app template to contact@estimote.com
//

#import <Foundation/Foundation.h>

#import "BeaconContentFactory.h"

@class ProximityContentManager;

@protocol ProximityContentManagerDelegate <NSObject>

- (void)proximityContentManager:(ProximityContentManager *)proximityContentManager didUpdateContent:(id)content;

@end

@interface ProximityContentManager : NSObject

@property (weak, nonatomic) id<ProximityContentManagerDelegate> delegate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithBeaconRegions:(NSArray *)beaconRegions beaconContentFactory:(id<BeaconContentFactory>)beaconContentFactory NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithBeaconIDs:(NSArray *)beaconIDs beaconContentFactory:(id<BeaconContentFactory>)beaconContentFactory;

- (void)startContentUpdates;
- (void)stopContentUpdates;

@end
