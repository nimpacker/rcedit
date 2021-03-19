import options, strformat
import os
import ./rceditpkg/is_wsl
import tables
import strformat, osproc, strutils

const arch = $(sizeof(int)*8)

proc installInstructions(): string =
  when defined(windows):
    return "No wrapper necessary"
  elif defined(macosx):
    return "Run `brew install --cask wine-stable` to install 64-bit wine on macOS via Homebrew."
  elif defined(linux):
    return "Consult your Linux distribution's package manager to determine how to install Wine."
  else:
    return "Consult your operating system's package manager to determine how to install Wine."

proc determineWineWrapper(customWinePath = none(string)): string =
  ## Heuristically determine the path to `wine` to use.
  ## Method used to determine the path:
  ## 1. `customWinePath`, if provided to the function
  ## 2. The `WINE_BINARY` environment variable, if set and non-empty
  ## 3. If the host architecture is x86-64, `wine64` found by searching the directories in the `PATH`
  ## environment variable
  ## 4. `wine` found by searching the directories in the `PATH` environment variable

  if customWinePath.isSome():
    return customWinePath.get()
  if existsEnv("WINE_BINARY"):
    return getEnv("WINE_BINARY")
  if arch == "64":
    return "wine64"
  return "wine"

# proc determineDotNetWrapper(customDotNetPath = none(string)): string =
#   ## Heuristically determine the path to `mono` to use.
#   ## Method used to determine the path:
#   ## 1. `customDotNetPath`, if provided to the function
#   ## 2. The `MONO_BINARY` environment variable, if set and non-empty
#   ## 3. `mono` found by searching the directories in the `PATH` environment variable

#   if customDotNetPath.isSome:
#     return customDotNetPath.get()
#   if existsEnv("MONO_BINARY"):
#     return getEnv("MONO_BINARY")
#   return "mono"

let canRunWindowsExeNatively = defined(windows) or isWSL()

let pairSettings = @["version-string"]
let singleSettings = @["file-version", "product-version", "icon", "requested-execution-level"]
let noPrefixSettings = @["application-manifest"]

proc rcedit*(winePath: Option[string], exe: string, options: Table[string, string], pairedOptions: Table[string, string]) =
  # https://github.com/electron/rcedit
  let rceditExe = if arch == "64": "rcedit-x64.exe" else: "rcedit.exe"
  let rcedit = ".." / "rcedit" / "bin" / rceditExe
  var args: seq[string] = @[]
  for name in pairSettings:
    for key, value in pairedOptions:
      args.add(@[fmt"--set-{name}", key, value])
  for name in singleSettings:
    if options.hasKey(name):
      args.add([fmt"--set-{name}", options[name]])
  for name in noPrefixSettings:
    if options.hasKey(name):
      args.add([fmt"--{name}", options[name]])
  if not canRunWindowsExeNatively:
    putEnv("WINEDEBUG", "-all")
    doAssert execCmdEx(determineWineWrapper(winePath) & " " & exe & " " & args.join(" ")).exitCode == 0
  else:
    doAssert execCmdEx(exe & " " & args.join(" ")).exitCode == 0


