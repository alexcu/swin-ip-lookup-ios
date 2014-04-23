//
//  Assignment 6
//  COS30007 - CDDMA
//
//  Alex Cummaudo, 1744070
//  2014-04-22
//

#import <Foundation/Foundation.h>

// Forward declaration
@class IPAddress;

@interface IPGetInfoRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
  /// Internal connection
  NSURLConnection* _ctn;
  /// Amount to be loaded
  long long _expectedDataLength;
  /// Data recieved
  NSMutableData* _recievedData;
}

/// The percentage loaded for this request
@property (readonly) CGFloat percentageLoaded;
/// The ip address loaded for this request
@property (readonly) IPAddress* ipAddressLoaded;

/**
 * Request for getting IP Address infomation
 * @param ip  The IP to get infomation for (if nil, then it will get current IP address)
 */
-(id) initToGetDetailsForIP:(IPAddress*) ip;

@end
