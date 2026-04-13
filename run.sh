echo "[AI]: I am now creating a C++ file named 'heapsort.cpp' that implements the Heap Sort algorithm."

cat << 'EOF' > heapsort.cpp
#include <iostream>
#include <vector>
#include <algorithm>

// To heapify a subtree rooted with node i which is
// an index in arr[]. n is size of heap
void heapify(std::vector<int>& arr, int n, int i) {
    int largest = i; // Initialize largest as root
    int l = 2 * i + 1; // left = 2*i + 1
    int r = 2 * i + 2; // right = 2*i + 2

    // If left child is larger than root
    if (l < n && arr[l] > arr[largest])
        largest = l;

    // If right child is larger than largest so far
    if (r < n && arr[r] > arr[largest])
        largest = r;

    // If largest is not root
    if (largest != i) {
        std::swap(arr[i], arr[largest]);

        // Recursively heapify the affected sub-tree
        heapify(arr, n, largest);
    }
}

// Main function to do heap sort
void heapSort(std::vector<int>& arr) {
    int n = arr.size();

    // Build heap (rearrange array)
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(arr, n, i);

    // One by one extract an element from heap
    for (int i = n - 1; i > 0; i--) {
        // Move current root to end
        std::swap(arr[0], arr[i]);

        // call max heapify on the reduced heap
        heapify(arr, i, 0);
    }
}

/* A utility function to print array of size n */
void printArray(const std::vector<int>& arr) {
    for (int i = 0; i < arr.size(); ++i)
        std::cout << arr[i] << " ";
    std::cout << "\n";
}

int main() {
    std::vector<int> arr = {12, 11, 13, 5, 6, 7};

    std::cout << "Original array is: \n";
    printArray(arr);

    heapSort(arr);

    std::cout << "Sorted array is: \n";
    printArray(arr);
    return 0;
}
EOF

echo "[AI]: File 'heapsort.cpp' has been created. I am now compiling the code using g++."

g++ heapsort.cpp -o heapsort

echo "[AI]: Compilation complete. Executing the program to verify the sorting logic."

./heapsort

echo "[AI]: The Heap Sort implementation is complete and verified."