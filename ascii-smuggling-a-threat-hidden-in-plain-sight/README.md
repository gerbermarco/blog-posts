# ASCII Smuggling Demo

This script demonstrates the ASCII smuggling technique using Unicode Tag
characters. Read the full blog post on [ASCII Smuggling: A Threat Hidden in Plain Sight](https://marcogerber.ch/ascii-smuggling-a-threat-hidden-in-plain-sight/) to learn more about ASCII smuggling.

## Prerequisites

- Python 3.10+ (standard library only)

## Usage

```bash
cd ascii-smuggling-a-threat-hidden-in-plain-sight
python ascii_smuggle.py
```

1. Enter the visible cover text when prompted.
2. Enter the hidden instruction.
3. The script writes the combined text to smuggled_text.txt.
4. Copy and paste the file contents into the [ASCII Smuggler tool](https://embracethered.com/blog/ascii-smuggler.html) (encoding option: Unicode Tags) to reveal the hidden data.

## Notes

- The encoder maps each ASCII byte into the Unicode Tags block and appends a
  Tag Cancel (U+E007F) marker so online tools know where the payload ends.
- Non-ASCII characters are rejected up front because Unicode Tags mode cannot
  represent them.
