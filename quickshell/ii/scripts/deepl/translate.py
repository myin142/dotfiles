#!/usr/bin/env python3
import sys
import json
import argparse
import urllib.request
import urllib.error

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--key", required=True)
    parser.add_argument("--text", required=True)
    parser.add_argument("--target-lang", required=True)
    parser.add_argument("--source-lang", default="")
    args = parser.parse_args()

    # DeepL free API uses api-free.deepl.com, paid uses api.deepl.com
    # Try free first, fallback handled by error output
    base_url = "https://api-free.deepl.com/v2/translate"

    payload = {
        "text": [args.text],
        "target_lang": args.target_lang.upper(),
    }
    if args.source_lang:
        payload["source_lang"] = args.source_lang.upper()

    data = json.dumps(payload).encode("utf-8")

    req = urllib.request.Request(
        base_url,
        data=data,
        headers={
            "Authorization": f"DeepL-Auth-Key {args.key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            print(json.dumps(result))
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")
        # Try paid API if free returns 403/wrong domain
        if e.code in (403, 404):
            paid_url = "https://api.deepl.com/v2/translate"
            req2 = urllib.request.Request(
                paid_url,
                data=data,
                headers={
                    "Authorization": f"DeepL-Auth-Key {args.key}",
                    "Content-Type": "application/json",
                },
                method="POST",
            )
            try:
                with urllib.request.urlopen(req2, timeout=15) as resp2:
                    result = json.loads(resp2.read().decode("utf-8"))
                    print(json.dumps(result))
                    return
            except urllib.error.HTTPError as e2:
                body = e2.read().decode("utf-8", errors="replace")
                print(json.dumps({"error": f"HTTP {e2.code}: {body}"}), file=sys.stderr)
        else:
            print(json.dumps({"error": f"HTTP {e.code}: {body}"}), file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"error": str(e)}), file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
