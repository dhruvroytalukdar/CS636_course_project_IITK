for i in {1..500}; do
    echo "Run $i"
    ./bzip2 -p64  bzip_input out_bzip 2>&1 | grep "WARNING: ThreadSanitizer: data race" && echo "RACE FOUND ON RUN $i" && break
done
