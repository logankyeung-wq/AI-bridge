echo "[AI]: I am now creating a Heap Sort implementation with a web-based visualizer for the Replit preview."

echo "[AI]: Generating index.html containing the Heap Sort algorithm and animation logic..."
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Heap Sort Visualizer</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            background: #1a1a2e; 
            color: #efefef;
            margin: 0;
            padding: 20px;
        }
        h1 { margin-bottom: 10px; color: #4cc9f0; }
        #container { 
            display: flex; 
            align-items: flex-end; 
            height: 400px; 
            width: 90%; 
            max-width: 800px;
            gap: 3px; 
            background: #16213e; 
            padding: 20px; 
            border-radius: 12px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            border: 1px solid #0f3460;
        }
        .bar { 
            flex: 1; 
            background-color: #4361ee; 
            transition: height 0.05s ease; 
            border-radius: 3px 3px 0 0; 
        }
        .highlight { background-color: #f72585 !important; }
        .comparing { background-color: #4cc9f0 !important; }
        .sorted { background-color: #4ade80 !important; }
        .controls { margin-top: 30px; display: flex; gap: 15px; }
        button { 
            padding: 12px 24px; 
            font-size: 16px; 
            font-weight: bold;
            cursor: pointer; 
            background: #4361ee; 
            border: none; 
            color: white; 
            border-radius: 8px;
            transition: transform 0.1s, background 0.2s;
        }
        button:hover { background: #3f37c9; transform: translateY(-2px); }
        button:active { transform: translateY(0); }
        button:disabled { background: #555; cursor: not-allowed; }
        #status { margin-top: 15px; font-style: italic; color: #aaa; }
    </style>
</head>
<body>
    <h1>Heap Sort Visualizer</h1>
    <div id="status">Press 'Start' to begin the sorting process</div>
    <div id="container"></div>
    <div class="controls">
        <button id="startBtn">Start Heap Sort</button>
        <button id="resetBtn">Shuffle Array</button>
    </div>

    <script>
        const container = document.getElementById('container');
        const startBtn = document.getElementById('startBtn');
        const resetBtn = document.getElementById('resetBtn');
        const statusText = document.getElementById('status');
        let array = [];
        const size = 50;
        let isSorting = false;

        function createArray() {
            if(isSorting) return;
            array = [];
            container.innerHTML = '';
            for (let i = 0; i < size; i++) {
                const val = Math.floor(Math.random() * 350) + 10;
                array.push(val);
                const bar = document.createElement('div');
                bar.className = 'bar';
                bar.style.height = `${val}px`;
                bar.id = `bar-${i}`;
                container.appendChild(bar);
            }
            statusText.innerText = "Array ready.";
        }

        async function sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        async function swap(i, j) {
            const barI = document.getElementById(`bar-${i}`);
            const barJ = document.getElementById(`bar-${j}`);
            
            barI.classList.add('highlight');
            barJ.classList.add('highlight');
            
            [array[i], array[j]] = [array[j], array[i]];
            barI.style.height = `${array[i]}px`;
            barJ.style.height = `${array[j]}px`;
            
            await sleep(40);
            barI.classList.remove('highlight');
            barJ.classList.remove('highlight');
        }

        async function heapify(n, i) {
            let largest = i;
            let left = 2 * i + 1;
            let right = 2 * i + 2;

            if (left < n) {
                document.getElementById(`bar-${left}`).classList.add('comparing');
                if (array[left] > array[largest]) largest = left;
            }
            if (right < n) {
                document.getElementById(`bar-${right}`).classList.add('comparing');
                if (array[right] > array[largest]) largest = right;
            }

            if (largest !== i) {
                await swap(i, largest);
                await heapify(n, largest);
            }

            if (left < n) document.getElementById(`bar-${left}`).classList.remove('comparing');
            if (right < n) document.getElementById(`bar-${right}`).classList.remove('comparing');
        }

        async function heapSort() {
            isSorting = true;
            startBtn.disabled = true;
            resetBtn.disabled = true;
            statusText.innerText = "Building Max Heap...";
            
            let n = array.length;

            // Build heap
            for (let i = Math.floor(n / 2) - 1; i >= 0; i--) {
                await heapify(n, i);
            }

            statusText.innerText = "Extracting elements from heap...";
            // Extract elements
            for (let i = n - 1; i > 0; i--) {
                await swap(0, i);
                document.getElementById(`bar-${i}`).classList.add('sorted');
                await heapify(i, 0);
            }
            
            document.getElementById(`bar-0`).classList.add('sorted');
            statusText.innerText = "Sort Complete!";
            isSorting = false;
            startBtn.disabled = false;
            resetBtn.disabled = false;
        }

        startBtn.addEventListener('click', heapSort);
        resetBtn.addEventListener('click', createArray);
        createArray();
    </script>
</body>
</html>
EOF

echo "[AI]: Creating a CLI version of Heap Sort in Python for reference..."
cat << 'EOF' > heapsort.py
import random

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
    for i in range(n-1, 0, -1):
        arr[i], arr[0] = arr[0], arr[i]
        heapify(arr, i, 0)

if __name__ == "__main__":
    data = [random.randint(1, 100) for _ in range(10)]
    print(f"Original array: {data}")
    heap_sort(data)
    print(f"Sorted array:   {data}")
EOF

echo "[AI]: Running the Python CLI version first..."
python3 heapsort.py

echo "[AI]: Starting the web server to show the visualization..."
echo "[AI]: Please click the 'Webview' tab or check the preview pane to interact with the Heap Sort visualizer."
python3 -m http.server 8080