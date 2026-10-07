const express = require('express');
const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'HEALTHY', timestamp: new Date().toISOString() });
});

app.get('/api/info', (req, res) => {
  res.status(200).json({
    appName: 'DevOps CI/CD Demo Application',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

module.exports = app;
