echo "[AI]: I am now upgrading the Heap Sort implementation to include a visualizer for 256 elements, adjustable speed, and a menu-driven 'button' interface."
echo "[AI]: Creating 'heapsort.cpp' with visualization logic, 1-256 array generation, and input handling..."

cat << 'EOF' > heapsort.cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <chrono>
#include <thread>
#include <iomanip>

using namespace std;

// Global settings
int delay_ms = 10;
bool is_sorting = false;

// Function to visualize the array
// We use a compact 16x16 grid (256 elements) to ensure it fits on any screen.
// Each cell's value (1-256) is represented by color/intensity if possible, 
// but for standard compatibility, we'll use a numeric grid with highlighting.
void visualize(const vector<int>& arr, int highlight1 = -1, int highlight2 = -1) {
    printf("\033[H"); // Move cursor to top of terminal
    cout << "=== HEAP SORT VISUALIZER (256 Elements) ===" << endl;
    cout << "Speed: " << delay_ms << "ms delay per swap | Values: 1-256" << endl;
    cout << "-------------------------------------------" << endl;

    for (int i = 0; i < 256; i++) {
        if (i == highlight1 || i == highlight2) {
            printf("\033[1;31m%3d \033[0m", arr[i]); // Red highlight for active elements
        } else {
            // Gradient-like effect using basic colors for different value ranges
            if (arr[i] < 64) printf("\033[0;34m%3d \033[0m", arr[i]);      // Blue
            else if (arr[i] < 128) printf("\033[0;36m%3d \033[0m", arr[i]); // Cyan
            else if (arr[i] < 192) printf("\033[0;32m%3d \033[0m", arr[i]); // Green
            else printf("\033[0;33m%3d \033[0m", arr[i]);                 // Yellow
        }

        if ((i + 1) % 16 == 0) cout << endl; // 16x16 grid
    }
    cout << "-------------------------------------------" << endl;
    if (is_sorting) {
        cout << "STATUS: SORTING... (Input disabled)        " << endl;
    } else {
        cout << "STATUS: IDLE                               " << endl;
    }
}

void heapify(vector<int>& arr, int n, int i) {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) largest = l;
    if (r < n && arr[r] > arr[largest]) largest = r;

    if (largest != i) {
        swap(arr[i], arr[largest]);
        visualize(arr, i, largest);
        this_thread::sleep_for(chrono::milliseconds(delay_ms));
        heapify(arr, n, largest);
    }
}

void heapSort(vector<int>& arr) {
    int n = arr.size();
    is_sorting = true;

    // Build heap
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }

    // Extract elements
    for (int i = n - 1; i > 0; i--) {
        swap(arr[0], arr[i]);
        visualize(arr, 0, i);
        this_thread::sleep_for(chrono::milliseconds(delay_ms));
        heapify(arr, i, 0);
    }
    
    is_sorting = false;
    visualize(arr);
    cout << "\nSort Complete! Press Enter to return to menu." << endl;
    cin.ignore();
    cin.get();
}

void shuffleArray(vector<int>& arr) {
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    shuffle(arr.begin(), arr.end(), default_random_engine(seed));
}

int main() {
    vector<int> arr(256);
    for (int i = 0; i < 256; i++) arr[i] = i + 1;
    shuffleArray(arr);

    while (true) {
        printf("\033[2J\033[H"); // Clear screen
        cout << "      HEAPSORT CONTROL PANEL" << endl;
        cout << "==================================" << endl;
        cout << "1. [START HEAP SORT]" << endl;
        cout << "2. SET SPEED (Current: " << delay_ms << "ms)" << endl;
        cout << "3. SHUFFLE ARRAY" << endl;
        cout << "4. EXIT" << endl;
        cout << "==================================" << endl;
        cout << "Enter Choice: ";

        int choice;
        if (!(cin >> choice)) {
            cin.clear();
            cin.ignore(10000, '\n');
            continue;
        }

        if (choice == 1) {
            // Button functionality: Start sort
            heapSort(arr);
        } else if (choice == 2) {
            cout << "Enter new delay in ms (1-500): ";
            cin >> delay_ms;
            if (delay_ms < 1) delay_ms = 1;
        } else if (choice == 3) {
            shuffleArray(arr);
            cout << "Array shuffled!" << endl;
            this_thread::sleep_for(chrono::milliseconds(500));
        } else if (choice == 4) {
            break;
        }
    }

    return 0;
}
EOF

echo "[AI]: Compilation started..."
g++ -O3 heapsort.cpp -o heapsort_visual
echo "[AI]: Compilation complete. Starting the application..."
echo "[AI]: Note: In the visualizer, 256 elements are displayed in a 16x16 grid for better visibility."
echo "[AI]: The 'Start' button is option 1 in the menu. It cannot be re-pressed while sorting."

./heapsort_visual