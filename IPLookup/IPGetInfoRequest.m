//
//  Assignment 6
//  COS30007 - CDDMA
//
//  Alex Cummaudo, 1744070
//  2014-04-22
//

#import "IPGetInfoRequest.h"
#import "IPAddress.h"

@interface IPGetInfoRequest ()

@end

@implementation IPGetInfoRequest

#pragma mark - Property Synthesis

-(IPAddress*) ipAddressLoaded
{
  // Return nil if not loaded yet
  if ([self percentageLoaded] != 1.0)
    return nil;
  else
  {
    // Convert the raw JSON to NSDictionary
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:_recievedData
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    // Now that we have the info, provide back the IP address generated from it!
    return [[IPAddress alloc] initWithAddressString:data[@"ip"]
                                             region:data[@"region_name"]
                                            country:data[@"country_name"]
                                               city:data[@"city"]
                                                lat:[data[@"latitude"] doubleValue]
                                                lon:[data[@"longitude"] doubleValue]];
  }
}

-(CGFloat) percentageLoaded
{
  return (CGFloat)[_recievedData length]/_expectedDataLength;
}

#pragma mark - Setup

-(id) initToGetDetailsForIP:(IPAddress *)ip
{
  if (self = [super init])
  {
    _recievedData = [[NSMutableData alloc] init];
    _expectedDataLength = 0;
    
    // Setup request to get info from
    NSString* urlStr;
    
    // Whether or not to get current IP
    if (ip != nil)
      urlStr = [NSString stringWithFormat:@"http://freegeoip.net/json/%@", [ip printableAddress]];
    else
      urlStr = @"http://freegeoip.net/json/";
    
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    _ctn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  }
  
  return self;
}

#pragma mark - NSURLConnectionDelegate method

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  // Recieved response? Set expected content length
  _expectedDataLength = [response expectedContentLength];
  // Clear former data
  [_recievedData setLength:0];
  // Announce to listeners new percentage loaded
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pct"
                                                      object:self];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  // Append data that was just recieved
  [_recievedData appendData:data];
  // Announce to listeners new percentage loaded
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pct"
                                                      object:self];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [_ctn cancel];
  // Announce to listener's a failure
  [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:self];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  // Announce to listener's a finished request
  [[NSNotificationCenter defaultCenter] postNotificationName:@"success"
                                                      object:self];
}

@end
