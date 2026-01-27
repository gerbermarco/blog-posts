from pathlib import Path

TAG_BASE = 0xE0000          # Offset where the Unicode Tags block starts
TAG_CANCEL = '\U000E007F'   # Tag Cancel signals the end of the hidden payload
OUTPUT_FILE = Path('smuggled_text.txt')


def encode_hidden_text(visible_text: str, hidden_text: str) -> tuple[str, int]:
    """Encode the payload using Unicode Tag characters appended to the cover text."""
    try:
        payload_bytes = hidden_text.encode('ascii')
    except UnicodeEncodeError as exc:
        raise ValueError("Unicode Tags mode only supports ASCII characters") from exc

    if not payload_bytes:
        return visible_text, 0

    # Each byte maps directly into the Tags block so ASCII Smuggler can decode it.
    encoded_hidden = ''.join(chr(TAG_BASE + byte) for byte in payload_bytes) + TAG_CANCEL
    return visible_text + encoded_hidden, len(payload_bytes)


def main() -> None:
    print("=== Let's smuggle! ===\n")

    visible_text = input("Enter the visible text: ")
    hidden_text = input("Enter the hidden instruction: ")

    smuggled_text, hidden_byte_count = encode_hidden_text(visible_text, hidden_text)

    OUTPUT_FILE.write_text(smuggled_text, encoding='utf-8')

    print(f"\n✓ Encoded output saved to {OUTPUT_FILE}")
    print(f"Visible length: {len(visible_text)}")
    print(f"Hidden bytes : {hidden_byte_count}")
    print("Paste the contents into ASCII Smuggler (Unicode Tags mode) to decode: https://embracethered.com/blog/ascii-smuggler.html")


if __name__ == "__main__":
    main()