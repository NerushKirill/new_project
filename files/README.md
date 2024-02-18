## My new project

Windows
```shell
$CurrentDirectory = Split-Path -Path $PWD -Leaf
Write-Output $CurrentDirectory
cd $CurrentDirectory
make check
```

Linux
```bash
CurrentDirectory=$(basename "$(pwd)")
cd $CurrentDirectory
make check
```

For container development, correct the last line with quotes.
Remove quotes at the beginning and end of the line.

To assemble the container, use
```bash
make build
```

### For FastAPI

To use uvicorn
```bash
if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
```

Or add to Dockerfile
```bash
CMD ["poetry", "run", "uvicorn", "src.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
```

### Check Makefile
