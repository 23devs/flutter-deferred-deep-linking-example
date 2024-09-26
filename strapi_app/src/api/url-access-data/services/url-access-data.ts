/**
 * url-access-data service
 */

import { factories } from "@strapi/strapi";
import { errors } from '@strapi/utils';
const { ApplicationError } = errors;
import { IncomingMessage } from "http";
import * as jwt from "jsonwebtoken";

const APP_STORE_APP_URL = process.env.APP_STORE_APP_URL || 
  "https://apps.apple.com/ru/app/23-devs-library/id6472991915";
const GOOGLE_PLAY_APP_URL = process.env.GOOGLE_PLAY_APP_URL || 
  "https://play.google.com/store/apps/details?id=ru.e2e4gu.books_flutter_application";

const HASH_SECRET = process.env.HASH_SECRET || "secret$wssh2Hdnd73hsg%2ssi$8Kj";

const CLIENT_URL = process.env.CLIENT_URL;

type Platform = "android" | "ios";

interface ParametersForHash {
  screenWidth: number;
  os: Platform;
  version: string;
  ip: string;
}

// IP addr
const getIpAddress: (req: IncomingMessage) => string = (
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
const getHash: (params: ParametersForHash) => string = (
    params: ParametersForHash
) => {
  return jwt.sign(params, HASH_SECRET, {
    noTimestamp: true
  });
};

// Url for store
const getRedirectUrl: (platform: Platform) => string = (
  platform: Platform
) => {
  return platform === "ios" ? APP_STORE_APP_URL : GOOGLE_PLAY_APP_URL;
}

// get url params
const getUrlDetails: (url: string) => string = (
  url: string
) => {
  //get url part like /details/:id?query=
  const urlSubstr = url.replace(CLIENT_URL, '');
  return urlSubstr;
}


export default factories.createCoreService(
  "api::url-access-data.url-access-data",
  ({ strapi }) => ({
    async set(ctx) {
      const { screenWidth, os, version, url } = ctx.request.body;

      if (!screenWidth || !os || !url) {
        throw new ApplicationError("Invalid body");
      }

      console.log(screenWidth);
      console.log(os);
      console.log(url);
      console.log(version);

      let platform: Platform | null = null;

      if (os === 'ios' || os === 'android') {
        platform = os as Platform;
      }

      console.log(platform);

      if (!platform) {
        throw new ApplicationError("Invalid platform");
      }

      const ip = getIpAddress(ctx.req);
    
      const params: ParametersForHash = {
        screenWidth,
        os: platform,
        version,
        ip
      };

      console.log('params:');
      console.log(params);

      const hash = getHash(params);
      const urlDetails: string = getUrlDetails(url);
      
      try {
        await strapi.documents(
          "api::url-access-data.url-access-data"
        ).create({
          data: {
            hash: hash,
            url: urlDetails
          }
        });
      } catch(e) {
        throw new ApplicationError("Unable to save instance");
      }

      const redirectUrl = getRedirectUrl(platform);
      return redirectUrl;
    },

    async check(ctx) {
      const { screenWidth, os, version } = ctx.request.body;

      if (!screenWidth || !os) {
        throw new ApplicationError("Invalid body");
      }

      let platform: Platform | null = null;

      if (os === 'ios' || os === 'android') {
        platform = os as Platform;
      }

      if (!platform) {
        throw new ApplicationError("Invalid platform");
      }

      const ip = getIpAddress(ctx.req);
    
      const params: ParametersForHash = {
        screenWidth,
        os: platform,
        version,
        ip
      };

      console.log('params:');
      console.log(params);

      const hash = getHash(params);

      console.log('hash:');
      console.log(hash);
      
      return { message: 'ok' };
    },
  })
);
