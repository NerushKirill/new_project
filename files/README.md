### My new project

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
