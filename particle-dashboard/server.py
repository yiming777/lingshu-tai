#!/usr/bin/env python3
"""灵枢台·中控 服务器 — 静态文件 + /api/command 桥接 OpenClaw Gateway"""
import json, mimetypes, subprocess, shlex, html as html_mod
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse
from pathlib import Path

STATIC_DIR = Path(__file__).parent

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == "/api/command":
            length = int(self.headers.get("Content-Length", 0))
            body = json.loads(self.rfile.read(length))
            message = body.get("message", "")
            model = body.get("model", "deepseek/deepseek-v4-pro")

            # 调用 openclaw agent CLI 桥接 Gateway
            cmd = [
                "openclaw", "agent",
                "-m", message,
                "--agent", "main",
                "--model", model,
                "--json",
            ]
            try:
                proc = subprocess.run(
                    cmd,
                    capture_output=True, text=True,
                    timeout=300,  # 5 分钟超时
                )
                if proc.returncode != 0:
                    err = proc.stderr.strip() or f"CLI exit {proc.returncode}"
                    self._json(502, {"error": err})
                    return

                data = json.loads(proc.stdout)
                if data.get("status") == "ok":
                    payloads = data.get("result", {}).get("payloads", [])
                    text = payloads[0].get("text", "") if payloads else ""
                    meta = data.get("result", {}).get("meta", {})
                    duration = meta.get("durationMs", 0)
                    self._json(200, {
                        "text": text,
                        "meta": {
                            "durationMs": duration,
                            "model": meta.get("providerModel", model),
                            "sessionId": meta.get("agentMeta", {}).get("sessionId", ""),
                        },
                    })
                else:
                    self._json(502, {"error": data.get("error", "未知错误")})
            except subprocess.TimeoutExpired:
                self._json(504, {"error": "处理超时（>5分钟）"})
            except json.JSONDecodeError as e:
                self._json(502, {"error": f"解析响应失败: {e}"})
            except Exception as e:
                self._json(500, {"error": str(e)})
        else:
            self._json(404, {"error": "Not found"})

    def do_GET(self):
        path = urlparse(self.path).path
        if path == "/":
            path = "/index.html"
        fpath = STATIC_DIR / path.lstrip("/")
        if not str(fpath).startswith(str(STATIC_DIR.resolve())):
            self._static(403, b"Forbidden")
            return
        if fpath.is_file():
            mime, _ = mimetypes.guess_type(str(fpath))
            self._static(200, fpath.read_bytes(), mime or "application/octet-stream")
        elif fpath.is_dir() and (fpath / "index.html").is_file():
            mime, _ = mimetypes.guess_type("index.html")
            self._static(200, (fpath / "index.html").read_bytes(), mime or "text/html; charset=utf-8")
        else:
            self._static(404, b"Not Found")

    def _json(self, code, data):
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data, ensure_ascii=False).encode())

    def _static(self, code, body, mime="text/html; charset=utf-8"):
        self.send_response(code)
        self.send_header("Content-Type", mime)
        self.end_headers()
        self.wfile.write(body)

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 3333), Handler)
    print("🌌 灵枢台·中控 → http://localhost:3333")
    print("   桥接 OpenClaw Gateway via CLI")
    server.serve_forever()
