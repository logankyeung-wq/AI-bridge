echo "[AI]: I have analyzed the system console output. The command 'fuser' failed because it is not installed in this environment. This prevented me from clearing the previous web server process that was occupying port 8000."
echo "[AI]: I will now use 'lsof' to find the process ID and terminate it, ensuring port 8000 is available."
echo "[AI]: I will then recreate the 'index.html' file with a robust Heap Sort visualization and restart the server."

# Kill process on port 8000 using lsof if fuser is missing
PID=$(lsof -t -i:8000)
if [ -z "$PID" ]; then
    echo "[AI]: Port 8000 is already free or no process was found using lsof."
else
    echo "[AI]: Terminating process $PID on port 8000..."
    kill -9 $PID
fi

# Create the visualizer file
echo "[AI]: Creating the Heap Sort visualizer web interface..."
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Heap Sort Visualizer</title>
    <style>
        body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; background: #121212; color: white; }
        #visualizer { display: flex; align-items: flex-end; height: 300px; gap: 2px; margin-top: 50px; border-bottom: 2px solid #444; padding: 10px; }
        .bar { background-color: #3498db; transition: height 0.1s, background-color 0.1s; width: 15px; }
        .active { background-color: #e74c3c !important; }
        .sorted { background-color: #2ecc71 !important; }
        .heap { background-color: #f1c40f !important; }
        .controls { margin-top: 20px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; background: #3498db; color: white; border: none; border-radius: 4px; }
        button:hover { background: #2980b9; }
    </style>
</head>
<body>
    <h1>Heap Sort Visualizer</h1>
    <div id="visualizer"></div>
    <div class="controls">
        <button onclick="startSort()">Run Heap Sort</button>
        <button onclick="resetArray()">Generate New Array</button>
    </div>
    <p id="status">Click 'Run Heap Sort' to begin.</p>

    <script>
        let array = [];
        const container = document.getElementById('visualizer');
        const status = document.getElementById('status');
        const numElements = 30;

        function resetArray() {
            array = [];
            container.innerHTML = '';
            for (let i = 0; i < numElements; i++) {
                array.push(Math.floor(Math.random() * 250) + 10);
                const bar = document.createElement('div');
                bar.className = 'bar';
                bar.style.height = `${array[i]}px`;
                bar.id = `bar-${i}`;
                container.appendChild(bar);
            }
            status.innerText = "Array generated.";
        }

        async function swap(i, j) {
            let temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            
            const barI = document.getElementById(`bar-${i}`);
            const barJ = document.getElementById(`bar-${j}`);
            barI.style.height = `${array[i]}px`;
            barJ.style.height = `${array[j]}px`;
            
            barI.classList.add('active');
            barJ.classList.add('active');
            await new Promise(resolve => setTimeout(resolve, 50));
            barI.classList.remove('active');
            barJ.classList.remove('active');
        }

        async function heapify(n, i) {
            let largest = i;
            let left = 2 * i + 1;
            let right = 2 * i + 2;

            if (left < n && array[left] > array[largest]) largest = left;
            if (right < n && array[right] > array[largest]) largest = right;

            if (largest !== i) {
                await swap(i, largest);
                await heapify(n, largest);
            }
        }

        async function startSort() {
            status.innerText = "Building Max Heap...";
            for (let i = Math.floor(array.length / 2) - 1; i >= 0; i--) {
                await heapify(array.length, i);
            }

            status.innerText = "Extracting elements from heap...";
            for (let i = array.length - 1; i > 0; i--) {
                await swap(0, i);
                document.getElementById(`bar-${i}`).classList.add('sorted');
                await heapify(i, 0);
            }
            document.getElementById(`bar-0`).classList.add('sorted');
            status.innerText = "Sorting Complete!";
        }

        resetArray();
    </script>
</body>
</html>
EOF

echo "[AI]: index.html has been updated. Starting the web server..."

# Start the python server in the background
nohup python3 -m http.server 8000 > /dev/null 2>&1 &

echo "[AI]: The visualizer is now running. Please check the Replit Webview or Preview tab."
echo "[AI]: If you still see a blank page, ensure the 'Webview' is pointing to port 8000."

# Provide a reference CLI script as requested previously
cat << 'EOF' > heapsort.py
def heapify(arr, n, i):
    largest = i
    l = 2 * i + 1
    r = 2 * i + 2
    if l < n and arr[i] < arr[l]:
        largest = l
    if r < n and arr[largest] < arr[r]:
        largest = r
    if largest != i:
        arr[i], arr[largest] = arr[largest], arr[i]
        heapify(arr, n, largest)

def heap_sort(arr):
    n = len(arr)
    for i in range(n // 2 - 1, -1, -1):
        heapify(arr, n, i)
    for i in range(n - 1, 0, -1):
        arr[i], arr[0] = arr[0], arr[i]
        heapify(arr, i, 0)

if __name__ == "__main__":
    sample = [90, 12, 46, 50, 11, 92, 19, 42, 54, 71]
    print(f"Original: {sample}")
    heap_sort(sample)
    print(f"Sorted:   {sample}")
EOF

echo "[AI]: Python CLI reference script also created as 'heapsort.py'."