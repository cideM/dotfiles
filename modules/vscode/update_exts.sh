#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq unzip
set -eu -o pipefail

echo "["

while IFS=$'\n' read -r line; do
  owner=$(echo "$line" | cut -d. -f1)
  extension=$(echo "$line" | cut -d. -f2)
  tempdir=$(mktemp -d -t vscode_exts_XXXXXXXX)

  # First, download the latest available version of the extension
  curl --silent --show-error --fail -X GET -o "$tempdir/$line.zip" "https://$owner.gallery.vsassets.io/_apis/public/gallery/publisher/$owner/extension/$extension/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  version=$(jq -r '.version' <(unzip -qc "$tempdir/$line.zip" "extension/package.json"))

  filename=$(printf "%s_%s" "$line" "$version")
  # Now download the specific version, because this file will have a different hash than the one from /latest/
  curl --silent --show-error --fail -X GET -o "$tempdir/$filename.zip" "https://$owner.gallery.vsassets.io/_apis/public/gallery/publisher/$owner/extension/$extension/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

  hash=$(nix-hash --flat --base32 --type sha256 "$tempdir/$filename.zip")

  rm -r "$tempdir"

  cat <<-EOF
{
  name = "$extension";
  publisher = "$owner";
  version = "$version";
  sha256 = "$hash";
}
EOF
done

echo "]"
