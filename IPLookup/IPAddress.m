//
//  Assignment 6
//  COS30007 - CDDMA
//
//  Alex Cummaudo, 1744070
//  2014-04-22
//

#import "IPAddress.h"
#include <stdlib.h>

@implementation IPAddress

#pragma mark - Property Synthesis

@synthesize coord = _coord;

-(NSString*) city
{
  if (_city == nil) return @"N/A";
  else return _city;
}
-(void) setCity:(NSString *)city
{
  if ([city isEqual: @""]) _city = nil;
  else _city = city;
}
-(NSString*) region
{
  if (_region == nil) return @"N/A";
  else return _region;
}
-(void) setRegion:(NSString *)region
{
  if ([region isEqual: @""]) _region = nil;
  else _region = region;
}
-(NSString*) country
{
  if (_country == nil) return @"N/A";
  else return _country;
}
-(void) setCountry:(NSString *)country
{
  if ([country isEqual: @""]) _country = nil;
  else _country = country;
}

-(NSString*) printableAddress
{
  return [NSString stringWithFormat:@"%d.%d.%d.%d",
          _octet[0], _octet[1], _octet[2], _octet[3]];
}

-(BOOL) hasCoords
{
  return _coord.longitude != 0.00 && _coord.longitude != 0.00;
}

#pragma mark - Setup

+(id) generateRandomIP
{
  NSInteger octets[4];
  // Generate 4 random octets between 1-254
  // Not going to use 0 or 255 since in breach of limits
  for (NSInteger i = 0; i < 4; i++)
    octets[i] = arc4random() % 254 + 1;
  return [[IPAddress alloc] initWithOctets:octets];
}

-(id) initWithOctets:(NSInteger [4])octets
{
  if (self = [super init])
  {
    for (NSInteger i = 0; i < 4; i++)
      _octet[i] = octets[i];
  }
  return self;
}

-(id) initWithAddressString:(NSString*) addressStr
                     region:(NSString*) region
                    country:(NSString*) country
                       city:(NSString*) city
                        lat:(CLLocationDegrees) lat
                        lon:(CLLocationDegrees) lon
{
  if (self = [super init])
  {
    // Split the address into four octets
    NSArray* octets = [addressStr componentsSeparatedByString:@"."];
    for (NSInteger i = 0; i < 4; i++)
      _octet[i] = [octets[i] integerValue];
    [self setRegion:region];
    [self setCountry:country];
    [self setCity:city];
    [self setCoord:CLLocationCoordinate2DMake(lat, lon)];
  }
  return self;
}

@end
