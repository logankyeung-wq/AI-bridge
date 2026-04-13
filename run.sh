echo "[AI]: I have received your request to delete 'hello.sh'. I am checking the current directory for the file."
if [ -f "hello.sh" ]; then
    rm hello.sh
    echo "[AI]: I have successfully deleted 'hello.sh'."
else
    echo "[AI]: I could not find a file named 'hello.sh' in the current directory."
fi
echo "[AI]: Here is the updated directory listing:"
ls -la