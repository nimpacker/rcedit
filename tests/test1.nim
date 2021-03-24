
import unittest, os, asyncdispatch, options, tables

import rcedit
# test "can add":
#   check add(5, 5) == 10
proc main(){.async.} =
  let dest = getTempDir() / "existential.exe"
  let exePath = currentSourcePath.parentDir / "fixtures" / "existential.exe"
  copyFile(exePath, dest)
  let icon = currentSourcePath.parentDir / "fixtures" / "app.ico"
  rcedit(none(string), dest, {"icon": icon}.toTable())

waitFor(main())
