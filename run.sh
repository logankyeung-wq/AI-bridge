echo Listing current files
ls -la
echo Creating index.html with the text Hello World
cat << 'EOF' > index.html
Hello World
EOF
echo Reading index.html to verify content
cat index.html
echo Starting Python HTTP server on port 8080 to display the preview
python3 -m http.server 8080