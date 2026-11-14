# Incident Report — LAB-001

**Date:** November 14, 2026  
**Environment:** Isolated Ubuntu virtual machine in UTM  
**Service:** Nginx web server  
**Classification:** Controlled service interruption; no production impact  
**Status:** Resolved

## Summary
The Nginx web server was intentionally stopped to simulate a website outage. The Ubuntu operating system remained operational. An HTTP request to `localhost` failed while the Nginx service was inactive. The service was subsequently restarted and local HTTP connectivity was restored.

## Evidence and timeline
Times below are shown in EST from the screenshots.

| Time | Event | Evidence |
| --- | --- | --- |
| 15:46:46 | Nginx started successfully | `04-nginx-running.png`, `07-nginx-logs.png` |
| 15:51:43 | Nginx intentionally stopped; systemd recorded a clean shutdown | `06-nginx-failure.png`, `07-nginx-logs.png` |
| After shutdown | `curl -I http://localhost` returned connection failure on port 80 | `06-nginx-failure.png` |
| 15:54:30 | Nginx restarted successfully | `08-nginx-recovery.png` |
| After restart | `curl -I http://localhost` returned `HTTP/1.1 200 OK` | `08-nginx-recovery.png` |

## Investigation
1. Checked `systemctl status nginx --no-pager` and observed `inactive (dead)`.
2. Tested local HTTP availability with `curl -I http://localhost` and received `curl: (7) Failed to connect`.
3. Examined `sudo journalctl -u nginx -n 30 --no-pager`. Entries showed a clean shutdown, not a service crash.
4. Identified the cause as the deliberate `sudo systemctl stop nginx` command used in this exercise. The journal entries alone do not identify who issued that command.

## Recovery and validation
```bash
sudo systemctl start nginx
systemctl status nginx --no-pager
curl -I http://localhost
```

The service returned to `active (running)` and the local HTTP request returned `200 OK`.

## Lessons learned
- A running operating system does not guarantee that a hosted service is available.
- `systemctl` checks service state; `journalctl` provides service event history; `curl` tests application-level response.
- Validation after remediation is necessary.
- In production, assess impact, permissions, change history, and escalation requirements before restarting services.
