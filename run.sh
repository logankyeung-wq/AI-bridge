echo "[AI]: I have analyzed the system console output. The error 'OSError: [Errno 98] Address already in use' occurred because a previous instance of the web server was still bound to port 8000, preventing a new one from starting."
echo "[AI]: I will now terminate the conflicting process, recreate the visualization files to ensure they are correct, and restart the server."

# Kill any process currently using port 8000
fuser -k 8000/tcp || pkill -f "python3 -m http.server" || true

echo "[AI]: Creating the Heap Sort visualizer web interface (index.html)..."

cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Heap Sort Visualizer</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; flex-direction: column; align-items: center; background-color: #2c3e50; color: white; }
        #container { display: flex; align-items: flex-end; height: 300px; gap: 4px; padding: 20px; border-bottom: 2px solid #ecf0f1; }
        .bar { width: 30px; background-color: #3498db; transition: height 0.1s, background-color 0.1s; }
        .bar.active { background-color: #e74c3c; }
        .bar.heap { background-color: #f1c40f; }
        .bar.sorted { background-color: #2ecc71; }
        .controls { margin-top: 20px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; background-color: #9b59b6; border: none; color: white; border-radius: 5px; }
        button:hover { background-color: #8e44ad; }
        h1 { margin-bottom: 10px; }
    </style>
</head>
<body>
    <h1>Heap Sort Visualizer</h1>
    <div id="container"></div>
    <div class="controls">
        <button onclick="startSort()">Start Heap Sort</button>
        <button onclick="resetArray()">Generate New Array</button>
    </div>

    <script>
        const container = document.getElementById('container');
        let array = [];
        const size = 15;

        function resetArray() {
            array = [];
            container.innerHTML = '';
            for (let i = 0; i < size; i++) {
                const val = Math.floor(Math.random() * 250) + 10;
                array.push(val);
                const bar = document.createElement('div');
                bar.classList.add('bar');
                bar.style.height = `${val}px`;
                bar.id = `bar-${i}`;
                container.appendChild(bar);
            }
        }

        async function sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        async function heapify(n, i) {
            let largest = i;
            let left = 2 * i + 1;
            let right = 2 * i + 2;

            updateClass(i, 'active');
            if (left < n) updateClass(left, 'heap');
            if (right < n) updateClass(right, 'heap');
            await sleep(200);

            if (left < n && array[left] > array[largest]) largest = left;
            if (right < n && array[right] > array[largest]) largest = right;

            if (largest !== i) {
                [array[i], array[largest]] = [array[largest], array[i]];
                render();
                await sleep(200);
                await heapify(n, largest);
            }
            
            updateClass(i, 'bar');
            if (left < n) updateClass(left, 'bar');
            if (right < n) updateClass(right, 'bar');
        }

        async function startSort() {
            let n = array.length;

            // Build max heap
            for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
                await heapify(n, i);
            }

            // Extract elements from heap
            for (let i = n - 1; i > 0; i--) {
                [array[0], array[i]] = [array[i], array[0]];
                render();
                updateClass(i, 'sorted');
                await sleep(200);
                await heapify(i, 0);
            }
            updateClass(0, 'sorted');
        }

        function render() {
            for (let i = 0; i < array.length; i++) {
                const bar = document.getElementById(`bar-${i}`);
                bar.style.height = `${array[i]}px`;
            }
        }

        function updateClass(idx, cls) {
            const bar = document.getElementById(`bar-${idx}`);
            if (bar) {
                bar.className = 'bar ' + cls;
            }
        }

        resetArray();
    </script>
</body>
</html>
EOF

echo "[AI]: index.html created. Starting the Python web server in the background..."

# Start the server and redirect output to suppress logs in the main console
python3 -m http.server 8000 > /dev/null 2>&1 &

echo "[AI]: Success. The Heap Sort visualizer is now running on port 8000."
echo "[AI]: Please open the 'Webview' or 'Preview' tab in Replit to interact with the visualizer."