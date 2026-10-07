const request = require('supertest');
const app = require('./index');

describe('DevSecOps Security API Suite', () => {
  test('GET /healthz should return 200 with security audit headers', async () => {
    const res = await request(app).get('/healthz');
    expect(res.statusCode).toEqual(200);
    expect(res.headers['x-content-type-options']).toEqual('nosniff');
    expect(res.headers['x-frame-options']).toEqual('DENY');
  });

  test('GET /api/secure-data should return protected payload', async () => {
    const res = await request(app).get('/api/secure-data');
    expect(res.statusCode).toEqual(200);
    expect(res.body.data).toBeDefined();
  });
});
