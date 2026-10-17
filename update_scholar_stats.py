#!/usr/bin/env python3
"""Fetches current Google Scholar metrics (publications, citations, h-index)
and writes them to scholar_stats.txt.
"""

from __future__ import annotations

import argparse
import os
import re
import sys
import urllib.error
import urllib.request

DEFAULT_USER_ID = "i2LNBfUAAAAJ"
DEFAULT_OUTPUT_FILE = "scholar_stats.txt"
USER_AGENT = (
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko)"
    " Chrome/120.0.0.0 Safari/537.36"
)


def fetch_scholar_stats(user_id: str) -> dict[str, int]:
    """Fetches publication count, total citations, and h-index from Google Scholar."""
    headers = {
        "User-Agent": USER_AGENT,
        "Accept-Language": "en-US,en;q=0.9",
    }

    cstart = 0
    pagesize = 100
    total_pubs = 0
    citations = None
    h_index = None

    while True:
        url = (
            f"https://scholar.google.com/citations?user={user_id}&hl=en"
            f"&cstart={cstart}&pagesize={pagesize}"
        )
        req = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                html = resp.read().decode("utf-8", errors="ignore")
        except urllib.error.HTTPError as e:
            if e.code == 429:
                sys.exit(
                    "Error: Google Scholar returned HTTP 429 (Too Many Requests / CAPTCHA)."
                )
            sys.exit(f"Error fetching Google Scholar profile (HTTP {e.code}): {e.reason}")
        except urllib.error.URLError as e:
            sys.exit(f"Network error connecting to Google Scholar: {e.reason}")

        # Extract metrics from the summary table on the first page
        if cstart == 0:
            c_m = re.search(
                r'Citations</a>\s*</td>\s*<td class="gsc_rsb_std">([\d,]+)</td>', html
            )
            h_m = re.search(
                r'h-index</a>\s*</td>\s*<td class="gsc_rsb_std">([\d,]+)</td>', html
            )
            if c_m:
                citations = int(c_m.group(1).replace(",", ""))
            if h_m:
                h_index = int(h_m.group(1).replace(",", ""))

        # Count articles on this page
        articles = re.findall(r'class="gsc_a_at"[^>]*>(.*?)</a>', html)
        num_articles = len(articles)
        total_pubs += num_articles

        # If fewer articles than pagesize were returned, we have reached the end
        if num_articles < pagesize:
            break
        cstart += pagesize

    if citations is None or h_index is None:
        sys.exit(
            "Error: Could not parse citations or h-index from Google Scholar response."
        )

    return {
        "publications": total_pubs,
        "citations": citations,
        "h_index": h_index,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Fetch Google Scholar metrics and write them to scholar_stats.txt."
    )
    parser.add_argument(
        "-u",
        "--user-id",
        default=os.environ.get("SCHOLAR_USER_ID", DEFAULT_USER_ID),
        help=f"Google Scholar user ID (default: {DEFAULT_USER_ID} or $SCHOLAR_USER_ID)",
    )
    parser.add_argument(
        "-o",
        "--output",
        default=DEFAULT_OUTPUT_FILE,
        help=f"Output file path (default: {DEFAULT_OUTPUT_FILE})",
    )
    parser.add_argument(
        "--format",
        choices=["numbers", "phrase"],
        default="numbers",
        help="Output format: 'numbers' (3 lines) or 'phrase' (full sentence)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Fetch and print metrics to stdout without writing to file",
    )

    args = parser.parse_args()

    print(f"Fetching Google Scholar metrics for user ID '{args.user_id}'...")
    stats = fetch_scholar_stats(args.user_id)
    pubs = stats["publications"]
    cits = stats["citations"]
    h = stats["h_index"]

    print(f"Found: {pubs} publications, {cits} citations, h-index {h}.")

    if args.dry_run:
        return

    if args.format == "numbers":
        content = (
            "# Google Scholar metrics: publications, citations, h-index (one per line or comma-separated)\n"
            f"{pubs}\n"
            f"{cits}\n"
            f"{h}\n"
        )
    else:
        content = f"{pubs} publications, {cits} citations, and h-index {h} in Google Scholar.\n"

    # Check if file already exists with same content
    if os.path.exists(args.output):
        with open(args.output, "r", encoding="utf-8") as f:
            existing = f.read()
        if existing == content:
            print(f"{args.output} is already up to date.")
            return

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Wrote updated metrics to {args.output}.")


if __name__ == "__main__":
    main()
