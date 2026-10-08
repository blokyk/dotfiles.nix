from jinja2.ext import Extension

import http.client
import json
import subprocess

def get_latest_version(publisher: str, name: str):
    req = {
        "filters": [{
            "criteria": [{
                "filterType": 7,
                "value": f"{publisher}.{name}"
            }]
        }],
        "flags": 0x200 # include_latest_version_only
    }

    headers = {
        "Accept": "application/json;api-version=7.2-preview.1",
        "Content-Type": "application/json"
    }

    conn = http.client.HTTPSConnection("marketplace.visualstudio.com")
    try:
        conn.request("POST", "/_apis/public/gallery/extensionquery/", body=json.dumps(req), headers=headers)

        with conn.getresponse() as raw_res:
            res = json.load(raw_res, )
    finally:
        conn.close()

    return res["results"][0]["extensions"][0]["versions"][0]["version"]

def prefetch_url(url : str, name: str | None = None, unpack: bool = False, executable: bool = False) -> str:
    hash = subprocess.run(
        ["$nix-prefetch-url$", url, "--name", name]
            + (["--unpack"] if unpack else [])
            + (["--executable"] if executable else []),
        capture_output=True
    )

    if hash.returncode != 0:
        print(f"\x1b[33mWARNING\x1b[0m: Couldn't prefetch '{url}'")
        print(hash.stderr.decode())
        hash.check_returncode()

    sri = subprocess.run(
        [
            "$nix-hash$",
            "--type", "sha256",
            "--to-sri", hash.stdout.strip()
        ],
        capture_output=True
    )

    if sri.returncode != 0:
        print(f"\x1b[33mWARNING\x1b[0m: Couldn't prefetch '{url}'")
        print(sri.stderr.decode())
        sri.check_returncode()

    return sri.stdout.strip().decode()

def prefetch_ext_spec(publisher: str, name: str) -> str:
    version = get_latest_version(publisher, name)
    url = f"https://{publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/{publisher}/extension/{name}/{version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    hash = prefetch_url(url, f"vscode-extension-{publisher}-{name}-{version}")
    return f'{{ publisher = "{publisher}"; name = "{name}"; version = "{version}"; hash = "{hash}"; }}'

class PrefetchExtension(Extension):
    def __init__(self, env):
        super().__init__(env)
        env.filters['prefetch_url'] = prefetch_url
        env.filters['prefetch_vscode_ext'] = prefetch_ext_spec
