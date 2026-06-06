#!/usr/bin/env node
/**
 * 灵枢台 · 全息中控 桥接服务器
 * 
 * 功能：
 *   1. 托管静态文件（index.html）
 *   2. POST /api/command → 转发到 OpenClaw agent CLI → 返回辨证结果
 *
 * 启动：node server.js [port]
 * 默认端口：3333
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const { execFile } = require('child_process');

const PORT = parseInt(process.argv[2], 10) || 3333;
const ROOT = __dirname;
const AGENT_TIMEOUT = 120_000; // agent 命令超时（120秒）
const SESSION_KEY = 'agent:main:dashboard';

// MIME 映射
const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.woff2': 'font/woff2',
};

function serveStatic(req, res) {
  let filePath = req.url === '/' ? '/index.html' : req.url;
  // 安全：禁止路径穿越
  filePath = path.normalize(filePath).replace(/^(\.\.(\/|\\|$))+/, '');
  const fullPath = path.join(ROOT, filePath);

  if (!fullPath.startsWith(ROOT)) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }

  const ext = path.extname(fullPath).toLowerCase();
  const mime = MIME[ext] || 'application/octet-stream';

  fs.readFile(fullPath, (err, data) => {
    if (err) {
      res.writeHead(err.code === 'ENOENT' ? 404 : 500);
      res.end(err.code === 'ENOENT' ? 'Not Found' : 'Internal Error');
      return;
    }
    res.writeHead(200, { 'Content-Type': mime, 'Cache-Control': 'no-cache' });
    res.end(data);
  });
}

function handleCommand(req, res) {
  let body = '';
  req.on('data', chunk => { body += chunk; });
  req.on('end', () => {
    let cmd;
    try {
      cmd = JSON.parse(body);
    } catch {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Invalid JSON' }));
      return;
    }

    if (!cmd.message || typeof cmd.message !== 'string' || !cmd.message.trim()) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'message is required' }));
      return;
    }

    const message = cmd.message.trim();
    console.log(`[bridge] 收到指令: ${message}`);

    const child = execFile('openclaw', [
      'agent',
      '--session-key', SESSION_KEY,
      '--message', message,
      '--json',
      '--timeout', String(Math.floor(AGENT_TIMEOUT / 1000)),
    ], {
      timeout: AGENT_TIMEOUT + 5000,
      maxBuffer: 1024 * 1024,
    }, (err, stdout, stderr) => {
      if (err) {
        console.error(`[bridge] agent 执行失败: ${err.message}`);
        // 尝试从 stdout 中解析部分结果
        if (stdout) {
          try {
            const partial = JSON.parse(stdout);
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
              text: partial?.result?.payloads?.[0]?.text
                || partial?.summary
                || '（处理未完成）',
              meta: partial?.result?.meta || {},
              partial: true,
            }));
            return;
          } catch {}
        }
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
          error: err.message,
          stderr: stderr?.slice(-500) || '',
        }));
        return;
      }

      try {
        const result = JSON.parse(stdout);
        const text = result?.result?.payloads?.[0]?.text || result?.summary || '（无输出）';
        const meta = result?.result?.meta || {};

        console.log(`[bridge] 响应 (${meta.durationMs || '?'}ms): ${text.slice(0, 80)}...`);

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ text, meta }));
      } catch (parseErr) {
        console.error(`[bridge] JSON 解析失败: ${parseErr.message}`);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Failed to parse agent response' }));
      }
    });
  });
}

// 创建服务器
const server = http.createServer((req, res) => {
  // CORS（开发阶段宽松）
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  if (req.method === 'POST' && req.url === '/api/command') {
    handleCommand(req, res);
  } else if (req.method === 'GET') {
    serveStatic(req, res);
  } else {
    res.writeHead(405);
    res.end('Method Not Allowed');
  }
});

server.listen(PORT, '0.0.0.0', () => {
  const os = require('os');
  const ifaces = os.networkInterfaces();
  console.log(`灵枢台中控桥接已就绪 → http://127.0.0.1:${PORT}`);
  Object.values(ifaces).forEach(iface => {
    iface.forEach(addr => {
      if (addr.family === 'IPv4' && !addr.internal) {
        console.log(`  手机访问 → http://${addr.address}:${PORT}`);
      }
    });
  });
  console.log(`  会话: ${SESSION_KEY}`);
  console.log(`  静态: ${ROOT}`);
});
