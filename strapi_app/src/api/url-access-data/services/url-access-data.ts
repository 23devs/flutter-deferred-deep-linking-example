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

interface UrlDetails {
  param: number;
  url: string;
}

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
  console.log('req headers');
  console.log(req.headers["x-forwarded-for"]);
  console.log(req.socket.remoteAddress);

  return req.headers["x-forwarded-for"] ? req.headers["x-forwarded-for"][0] : req.socket.remoteAddress;
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
const getUrlDetails: (url: string) => UrlDetails = (
  url: string
) => {
  // get page id from url param like https://example.com/details/2

  const urlParts: string[] = url.split('/');
  let param: number | null = Number(urlParts[urlParts.length - 1]);

  if (isNaN(param)) {
    param = null;
  }

  // if needed get id from query params here
  // like https://example.com/details?id=2

  if (!param) {
    throw new ApplicationError("Invalid url");
  }

  //get url part like /details
  const urlSubstr = url.replace(`/${param}`, '').replace(CLIENT_URL, '');

  let urlDetails: UrlDetails = {
    url: urlSubstr,
    param
  };
  return urlDetails;
}


export default factories.createCoreService(
  "api::url-access-data.url-access-data",
  ({ strapi }) => ({
    async set(ctx) {
      const { screenWidth, os, version, url } = ctx.request.body;

      if (!screenWidth || !os || !url) {
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
      const urlDetails: UrlDetails = getUrlDetails(url);
      
      try {
        await strapi.documents(
          "api::url-access-data.url-access-data"
        ).create({
          data: {
            hash: hash,
            url: urlDetails.url,
            param: urlDetails.param
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
