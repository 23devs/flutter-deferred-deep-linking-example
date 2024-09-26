/**
 * url-access-data service
 */

import { factories } from "@strapi/strapi";
import { errors } from '@strapi/utils';
const { ApplicationError } = errors;
import { ParametersForHash, Platform } from "../../../utils/url-access-data/types";
import { 
  getHash, 
  getIpAddress, 
  getRedirectUrl, 
  getTimestampForFilter, 
  getUrlDetails, 
} from "../../../utils/url-access-data/utils";


export default factories.createCoreService(
  "api::url-access-data.url-access-data",
  ({ strapi }) => ({
    async set(ctx) {
      const { screenWidth, os, version, url } = ctx.request.body;

      if (!os || !version || !url || !screenWidth) {
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

      if (!os || !version || !screenWidth ) {
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

      const hash = getHash(params);

      const timestampForFilter = getTimestampForFilter();

      try {
        // find entries with same hash 
        // that were created in recent hour
        // return the most recent one
        const documents = await strapi.documents(
          "api::url-access-data.url-access-data"
        ).findMany(
          {
            filters: {
              hash: {
                $eq: hash
              },
              createdAt: {
                $gt: timestampForFilter
              }
            },
            sort: "createdAt:desc"
          }
        );

        if(documents?.length > 0) {
          const document = documents[0];

          return document.url;
        } else {
          throw Error();
        }
      } catch(e) {
        throw new ApplicationError("Unable to get url");
      }
    },
  })
);
