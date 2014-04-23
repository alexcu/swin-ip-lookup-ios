//
//  Assignment 6
//  COS30007 - CDDMA
//
//  Alex Cummaudo, 1744070
//  2014-04-22
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface IPAddress : NSObject
{
  /// The four octets of the IP Address
  NSInteger _octet[4];
  /// The region of this IP address
  NSString* _region;
  /// The country of this IP address
  NSString* _country;
  /// The city of this IP address
  NSString* _city;
}

/// Printable address in the standard format
@property (readonly) NSString* printableAddress;

/// The region of this IP address
@property (nonatomic) NSString* region;

/// The country of this IP address
@property (nonatomic) NSString* country;

/// The city of this IP address
@property (nonatomic) NSString* city;

/// The coordinates of this IP address
@property CLLocationCoordinate2D coord;

/// Checks if coordinates avaliable
@property (readonly) BOOL hasCoords;

/**
 * Creates an IP address with the four octets
 * @param octets  The octets of the IP to initialise with
 */
-(id) initWithOctets:(NSInteger[4]) octets;

/**
 * Creates an IP address based on items provided
 */
-(id) initWithAddressString:(NSString*) addressStr
                     region:(NSString*) region
                    country:(NSString*) country
                       city:(NSString*) city
                        lat:(CLLocationDegrees) lat
                        lon:(CLLocationDegrees) lon;

/**
 * Generates a random, valid, IP Address
 * @return  A new IP Address
 */
+(id) generateRandomIP;


@end
