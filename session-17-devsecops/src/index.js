const express = require('express');
const app = express();

// Security Middleware: Set HTTP security headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('Content-Security-Policy', "default-src 'self'");
  next();
});

app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'OK', secAudited: true });
});

app.get('/api/secure-data', (req, res) => {
  res.status(200).json({ data: 'Protected microservice payload' });
});

module.exports = app;
