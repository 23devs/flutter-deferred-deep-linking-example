/**
 * url-access-data controller
 */

import { factories } from '@strapi/strapi'

export default factories.createCoreController('api::url-access-data.url-access-data', ({ strapi }) =>  ({
  async set(ctx) {
    try {
      const clientIp = ctx.req.headers['x-forwarded-for'] || ctx.req.socket.remoteAddress;
      console.log(clientIp);
      console.log(ctx.request.body);

      const { screenWidth, os, version, url } = ctx.request.body;
      
      return {
        status: 'ok'
      };
    } catch (err) {
      ctx.body = err;
    }
  },

  async check(ctx) {
    try {
      const clientIp = ctx.req.headers['x-forwarded-for'] || ctx.req.socket.remoteAddress;
      console.log(clientIp);
      return {
        status: 'ok'
      };
    } catch (err) {
      ctx.body = err;
    }
  },
}));
