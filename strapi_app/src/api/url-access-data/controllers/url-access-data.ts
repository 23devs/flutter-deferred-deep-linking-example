/**
 * url-access-data controller
 */

import { factories } from '@strapi/strapi';

export default factories.createCoreController('api::url-access-data.url-access-data', ({ strapi }) =>  ({
  async set(ctx) {
    try {
      const url = await strapi.service('api::url-access-data.url-access-data').set(ctx);
      
      return {
        message: 'ok',
        redirectUrl: url
      };
    } catch (err) {
      return ctx.badRequest(err);
    }
  },

  async check(ctx) {
    try {
      await strapi.service('api::url-access-data.url-access-data').check(ctx);

      return {
        status: 'ok'
      };
    } catch (err) {
      return ctx.badRequest(err);
    }
  },
}));
