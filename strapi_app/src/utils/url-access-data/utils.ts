/**
 * url-access-data utils
 */

import { IncomingMessage } from "http";
import * as jwt from "jsonwebtoken";
import { 
  APP_STORE_APP_URL, 
  CLIENT_URL, 
  GOOGLE_PLAY_APP_URL, 
  HASH_SECRET,
} from "./constants";
import { ParametersForHash, Platform } from "./types";


// get timestamp (1 hour before now)
export const getTimestampForFilter: () => string = () => {
  const dateNow = new Date().getTime();
  const HOUR = 1000 * 60 * 60;
  const time = new Date(dateNow - HOUR);
  return time.toISOString();
}


// IP addr
export const getIpAddress: (req: IncomingMessage) => string = (
  req: IncomingMessage
) => {
  let xForwardedHeader: string | null = null;

  if (req.headers["x-forwarded-for"]) {
    if (typeof req.headers["x-forwarded-for"] === "string") {
      xForwardedHeader = req.headers["x-forwarded-for"].split(',')[0];
    } else {
      xForwardedHeader = req.headers["x-forwarded-for"][0];
    }
  }

  return xForwardedHeader ? xForwardedHeader : req.socket.remoteAddress;
};


// hash (get the same hash for the same params)
export const getHash: (params: ParametersForHash) => string = (
    params: ParametersForHash
) => {
  return jwt.sign(params, HASH_SECRET, {
    noTimestamp: true
  });
};


// Url for store
export const getRedirectUrl: (platform: Platform) => string = (
  platform: Platform
) => {
  return platform === "ios" ? APP_STORE_APP_URL : GOOGLE_PLAY_APP_URL;
}


// get url params
export const getUrlDetails: (url: string) => string = (
  url: string
) => {
  //get url part like /details/:id?query=
  const urlSubstr = url.replace(CLIENT_URL, '');
  return urlSubstr;
}
