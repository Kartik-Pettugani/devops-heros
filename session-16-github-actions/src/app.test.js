const request = require('supertest');
const app = require('./app');

describe('Express API Server Tests', () => {
  test('GET /health should return status 200 and healthy state', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toEqual(200);
    expect(res.body.status).toEqual('HEALTHY');
  });

  test('GET /api/info should return application version metadata', async () => {
    const res = await request(app).get('/api/info');
    expect(res.statusCode).toEqual(200);
    expect(res.body.appName).toEqual('DevOps CI/CD Demo Application');
  });
});
