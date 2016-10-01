# Run Jekyll
echo -e "Running Jekyll"
jekyll build

# Upload to S3!
echo -e "Uploading to S3"


# Sync media files first (Cache: expire in 1weeks)
echo -e "Syncing media files..."
s3cmd sync --acl-public --exclude '*.*' --include '*.png' --include '*.jpg' --include '*.ico' --add-header="Cache-Control: max-age=604800"  _site/ s3://imkarthikk.com

# Sync Javascript and CSS assets next (Cache: expire in 1 week)
echo -e "Syncing .js and .css files..."
s3cmd sync --acl-public --exclude '*.*' --include  '*.css' --include '*.js' --add-header="Cache-Control: max-age=604800"  _site/ s3://imkarthikk.com

# Sync html files (Cache: 2 hours)
echo -e "Syncing .html"
s3cmd sync --acl-public --exclude '*.*' --include  '*.html' --add-header="Cache-Control: max-age=7200, must-revalidate"  _site/ s3://imkarthikk.com

# Sync everything else, but ignore the assets!
echo -e "Syncing everything else"
s3cmd sync --acl-public --exclude '.DS_Store' --exclude 'assets/'  _site/ s3://imkarthikk.com

# Sync: remaining files & delete removed
s3cmd sync --acl-public --delete-removed  _site/ s3://imkarthikk.com

echo -e "Done pushing!"
