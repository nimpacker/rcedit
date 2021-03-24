# rcedit  

cross-platform rcedit wrapper in Nim.  

Nim module to edit resources of Windows executables.  

## Requirements  

On platforms other than Windows, you will need to have [Wine](https://winehq.org)
1.6 or later installed and in the system path.  

## Usage  

``` nim
import rcedit  

rcedit(none(string), exePath, {"icon": icon}.toTable())
```

suported `options`:  
`"application-manifest","file-version", "product-version", "icon", "requested-execution-level"`  

`pairedOptions`:  
Use this option to change any supported properties, as described in the MSDN documentation [here](https://msdn.microsoft.com/en-us/library/windows/desktop/aa381058(v=vs.85).aspx)