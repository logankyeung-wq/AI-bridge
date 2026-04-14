echo "[AI]: The previous error occurred because I attempted to read binary files (the compiled 'heapsort' and 'heapsort_vis' executables) as UTF-8 text. This caused the decoder to crash when encountering non-text bytes."
echo "[AI]: I will now delete the Python implementation, read the existing files safely, and create a new C++ implementation that supports 256 elements, customizable speed, and a visualization for the Replit preview tab."

# 1. Delete the python heapsort
if [ -f "heapsort.py" ]; then
    rm heapsort.py
    echo "[AI]: Deleted 'heapsort.py'."
fi

# 2. Read every file (safely checking for binary)
echo "[AI]: Reading existing files to gather context..."
for f in heapsort.py heapsort.cpp heapsort heapsort_visual heapsort_vis; do
    if [ -f "$f" ]; then
        echo "--- File: $f ---"
        if file "$f" | grep -q "text"; then
            cat "$f"
        else
            echo "[AI]: Skipping binary file content to avoid encoding errors."
        fi
        echo "-------------------"
    fi
done

# 3. Create the C++ Heapsort with a built-in web server for the preview tab
echo "[AI]: Creating 'heapsort.cpp' with 256 elements and visualization server..."
cat << 'EOF' > heapsort.cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <thread>
#include <chrono>
#include <string>
#include <sstream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <random>

using namespace std;

// Global state for visualization
vector<int> arr;
int arr_size = 256;
double delay_sec = 0.01;
string current_status = "Initializing...";

void heapify(vector<int>& a, int n, int i) {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && a[l] > a[largest]) largest = l;
    if (r < n && a[r] > a[largest]) largest = r;

    if (largest != i) {
        swap(a[i], a[largest]);
        this_thread::sleep_for(chrono::milliseconds((int)(delay_sec * 1000)));
        heapify(a, n, largest);
    }
}

void heapSort(vector<int>& a) {
    int n = a.size();
    current_status = "Building Heap...";
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(a, n, i);

    current_status = "Extracting Elements...";
    for (int i = n - 1; i > 0; i--) {
        swap(a[0], a[i]);
        heapify(a, i, 0);
    }
    current_status = "Sorted!";
}

string generate_html() {
    stringstream ss;
    ss << "<html><head><meta http-equiv='refresh' content='0.1'><style>";
    ss << "body { background: #1a1a1a; color: #00ff00; font-family: monospace; }";
    ss << ".bar { display: inline-block; background: #00ff00; margin-right: 1px; vertical-align: bottom; }";
    ss << "</style></head><body>";
    ss << "<h1>C++ Heapsort Visualization (256 Elements)</h1>";
    ss << "<div>Status: " << current_status << " | Delay: " << delay_sec << "s</div><br>";
    ss << "<div style='height: 300px; display: flex; align-items: flex-end;'>";
    for (int val : arr) {
        ss << "<div class='bar' style='height: " << (val * 1) << "px; width: 4px;'></div>";
    }
    ss << "</div></body></html>";
    return ss.str();
}

void start_server() {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    
    struct sockaddr_in address;
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(8080);
    
    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 3);
    
    cout << "[AI]: Visualization server started on port 8080 (Preview Tab)." << endl;
    
    while (true) {
        int new_socket = accept(server_fd, NULL, NULL);
        string response = "HTTP/1.1 200 OK\nContent-Type: text/html\n\n" + generate_html();
        send(new_socket, response.c_str(), response.length(), 0);
        close(new_socket);
    }
}

int main(int argc, char* argv[]) {
    if (argc > 1) delay_sec = stod(argv[1]);

    // Initialize array
    for (int i = 1; i <= arr_size; i++) arr.push_back(i);
    auto rd = mt19937{random_device{}()};
    shuffle(arr.begin(), arr.end(), rd);

    // Start server in background thread
    thread server_thread(start_server);
    server_thread.detach();

    cout << "[AI]: Starting Heapsort on 256 elements with delay " << delay_sec << "..." << endl;
    heapSort(arr);
    cout << "[AI]: Sorting complete." << endl;

    // Keep main thread alive for the server
    while (true) {
        this_thread::sleep_for(chrono::seconds(1));
    }

    return 0;
}
EOF

# 4. Compile the C++ code
echo "[AI]: Compiling 'heapsort.cpp'..."
g++ -O3 heapsort.cpp -o heapsort_new -pthread

# 5. Execute
echo "[AI]: Running heapsort with speed 0.01. Access the 'Preview' tab to see the visualization."
# Run in background so the script can finish, or foreground if you want to see logs. 
# We'll run it in the background so the user gets control back.
./heapsort_new 0.01 &

echo "[AI]: Task complete. The C++ heapsort is running. You can view the live sorting process in the Replit Preview tab (Port 8080)."
echo "[AI]: To run with a different speed, use: ./heapsort_new [delay_in_seconds]"