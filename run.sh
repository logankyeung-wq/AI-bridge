echo "Listing all files in the current directory"
ls -la
echo "Creating a bash script file named hello.sh"
cat << 'EOF' > hello.sh
echo "Hello World"
EOF
echo "Running the script hello.sh"
bash hello.sh