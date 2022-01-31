set tempdir (mktemp -d -t vscode_exts_XXXXXXXX)

function cleanup --on-event fish_exit
  rm -r $tempdir
end

# $version is reserved it seems
function makeurl -d "Generate a URL to download an extension" -a owner extension ver
  if not test -n "$ver"
    set ver "latest"
  end
  echo "https://$owner.gallery.vsassets.io/_apis/public/gallery/publisher/$owner/extension/$extension/$ver/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
end

echo "["

while read -l line
  set -l owner (echo "$line" | cut -d. -f1)
  set -l extension (echo "$line" | cut -d. -f2)

  # First, download the latest available version of the extension
  set -l url (makeurl $owner $extension)
  curl --silent --show-error --fail -X GET -o "$tempdir/$line.zip" $url
  if not test $status -eq 0; echo "error downloading from $url"; exit 1; end

  set -l ver (jq -r '.version' (unzip -qc "$tempdir/$line.zip" "extension/package.json" | psub))
  set -l filename (printf "%s_%s" "$line" "$ver")

  # Now download the specific version, because this file will have a different hash than the one from /latest/
  set -l url (makeurl $owner $extension $ver)
  curl --silent --show-error --fail -X GET -o "$tempdir/$filename.zip" $url
  if not test $status -eq 0; echo "error downloading from $url"; exit 1; end

  set -l hash (nix-hash --flat --base32 --type sha256 "$tempdir/$filename.zip")

  printf '{ name = "%s"; publisher = "%s"; version = "%s"; sha256 = "%s"; }\n' $extension $owner $ver $hash
end

echo "]"
