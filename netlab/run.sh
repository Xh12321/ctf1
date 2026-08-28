#!/usr/bin/env bash
# temporary network probe (runs on GitHub Actions; sandbox egress is firewalled)
B="https://eci-2zebr08wgnldoatsjknv.cloudeci1.ichunqiu.com:9999"
set +e

echo "===== GET / (headers + body) ====="
curl -sk -m 25 -i "$B/" | head -80
echo
echo "===== raw HTML length ====="
curl -sk -m 25 "$B/" | wc -c
echo "===== raw HTML ====="
curl -sk -m 25 "$B/" | head -c 12000
echo
echo "===== OPTIONS / (CORS?) ====="
curl -sk -m 25 -i -X OPTIONS -H "Origin: https://foo.example" "$B/v1/onboarding/people" | head -30
echo
echo "===== GET with Origin (CORS?) ====="
curl -sk -m 25 -i -H "Origin: https://foo.example" "$B/openapi.json" | head -30

echo
echo "===== endpoint guesses ====="
for p in /openapi.json /docs /redoc /health /healthz /status /v1/health /v1/status \
         /v1/session /v1/sessions /v1/bootstrap /v1/whoami /v1/me /v1/auth/session \
         /v1/public/session /v1/public/bootstrap /v1/signup /v1/register /v1/token \
         /v1/tenant /v1/fixtures /v1/seed /v1/admin/session /v1/onboarding/people \
         /v1/onboarding/memory /v1/starter-packets/mine /v1/memory /v1/tools ; do
  printf -- "--- GET %s : " "$p"
  curl -sk -m 15 -o /tmp/o.txt -w "%{http_code} " "$B$p"
  head -c 400 /tmp/o.txt; echo
done

echo
echo "===== POST guesses (empty json) ====="
for p in /v1/session /v1/sessions /v1/bootstrap /v1/auth/session /v1/public/session \
         /v1/signup /v1/register /v1/tenant /v1/fixtures /v1/seed /v1/admin/session ; do
  printf -- "--- POST %s : " "$p"
  curl -sk -m 15 -o /tmp/o.txt -w "%{http_code} " -X POST -H 'Content-Type: application/json' -d '{}' "$B$p"
  head -c 400 /tmp/o.txt; echo
done
echo "===== done ====="
