echo "I am starting the task: Creating a C++ sorting algorithm with a web-based visualization."

echo "Action: Checking existing files in the current project directory."
ls -la

echo "Action: Creating the C++ source file 'sort.cpp' which implements Bubble Sort and logs each step."
cat << 'EOF' > sort.cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <chrono>

void log_state(const std::vector<int>& arr) {
    for (size_t i = 0; i < arr.size(); ++i) {
        std::cout << arr[i] << (i == arr.size() - 1 ? "" : ",");
    }
    std::cout << std::endl;
}

int main() {
    const int n = 40;
    std::vector<int> arr(n);
    for(int i = 0; i < n; ++i) arr[i] = i + 1;
    
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::shuffle(arr.begin(), arr.end(), std::default_random_engine(seed));

    // Log the initial random state
    log_state(arr);

    // Perform Bubble Sort and log after every swap
    for (int i = 0; i < n - 1; ++i) {
        bool swapped = false;
        for (int j = 0; j < n - i - 1; ++j) {
            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
                swapped = true;
                log_state(arr);
            }
        }
        if (!swapped) break;
    }
    return 0;
}
EOF

echo "Action: Compiling 'sort.cpp' into an executable named 'sort_bin' using g++."
g++ -O3 sort.cpp -o sort_bin

echo "Action: Running 'sort_bin' and redirecting the sorting steps into 'data.csv'."
./sort_bin > data.csv

echo "Action: Reading the first few lines of 'data.csv' to ensure the sorting trace was generated correctly."
cat data.csv | head -n 5

echo "Action: Creating 'index.html' to provide a visual interface for the sorting algorithm on the preview screen."
cat << 'EOF' > index.html
<!DOCTYPE html>
<html>
<head>
    <title>Sort Visualizer</title>
    <style>
        body { background: #111; color: #0f0; font-family: monospace; text-align: center; margin: 0; }
        #container { display: flex; align-items: flex-end; justify-content: center; height: 70vh; width: 90vw; margin: 20px auto; border: 1px solid #333; }
        .bar { background: #0f0; margin: 0 1px; flex: 1; }
        .controls { margin-top: 20px; font-size: 1.2em; }
    </style>
</head>
<body>
    <h1>C++ Bubble Sort Visualizer</h1>
    <div id="container"></div>
    <div class="controls" id="status">Initializing...</div>
    <script>
        async function visualize() {
            const status = document.getElementById('status');
            const container = document.getElementById('container');
            const response = await fetch('data.csv');
            const text = await response.text();
            const steps = text.trim().split('\n');

            for (let i = 0; i < steps.length; i++) {
                const values = steps[i].split(',').map(Number);
                container.innerHTML = '';
                values.forEach(v => {
                    const bar = document.createElement('div');
                    bar.className = 'bar';
                    bar.style.height = (v * 100 / values.length) + '%';
                    container.appendChild(bar);
                });
                status.innerText = `Step ${i + 1} of ${steps.length}`;
                await new Promise(r => setTimeout(r, 20));
            }
            status.innerText = "Sorting Complete.";
        }
        visualize();
    </script>
</body>
</html>
EOF

echo "Action: Reading 'index.html' to verify content."
cat index.html

echo "Action: Checking project directory state before launching server."
ls -la

echo "Action: Starting a Python HTTP server on port 8080 to display the visualization."
echo "The sorting visual should now be visible in the Replit preview window."
python3 -m http.server 8080