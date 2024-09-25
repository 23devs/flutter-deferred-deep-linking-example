export default {
  routes: [
    {
      method: 'POST',
      path: '/url-access-datas/set',
      handler: 'url-access-data.set',
    },
    {
      method: 'POST',
      path: '/url-access-datas/check',
      handler: 'url-access-data.check',
    }
  ]
}
