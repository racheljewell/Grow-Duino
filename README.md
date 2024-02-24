# Grow-Duino

## Initializing Go Packages

```bash
cd cmd
mkdir newPackageName
cd newPackageName
```

Make go file 'imapackage.go'
```Go
package newPackageName

// Capitalized items can be exported
func ExportableFunction() {
  // Something goes here
{

// Uncapitalized items cannot be exported
func iStayHere() {
  // private stuff
}
```

Make sure you're in 'newPackageName' directory. Then,

```bash
go build
```

To import local package:
```Go
import (
  // Pseudo can be a shortened version of the name that you can access from the code
  newPackageNamePseudo "growduino/main/newPackageName"
)
```

## Running Go Code
In cmd directory:
```bash
go build
.\main.exe
```
