echo "Listing files in the current directory"
ls -la
echo "Creating a Node.js script to serve 'Hello World' to the preview"
cat << 'EOF' > index.js
const http = require('http');
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World');
});
server.listen(8080, () => {
  console.log('Server running on port 8080');
});
EOF
echo "Reading index.js to verify the content"
cat index.js
echo "Executing index.js to display Hello World on the preview"
node index.js