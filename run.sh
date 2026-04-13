echo "Listing current files in the project directory..."
ls -la
echo "Creating a new file index.js to host the Hello World message..."
cat << 'EOF' > index.js
const http = require('http');

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World');
});

server.listen(8080, '0.0.0.0', () => {
  console.log('Server is running and serving Hello World');
});
EOF
echo "Reading the contents of index.js to verify correctness..."
cat index.js
echo "Starting the Node.js server to display 'Hello World' on the project preview..."
node index.js