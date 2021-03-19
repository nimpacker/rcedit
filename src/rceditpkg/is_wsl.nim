import strutils
import ./is_docker

when defined(posix):
  import posix_utils

proc isWsl*():bool =
  when not defined(linux):
    result = false
  let release = uname().release
  if "microsoft" in release or "Microsoft" in release:
    if isDocker():
      result = false
    result = true

  try:
    if readFile("/proc/version").toLower().contains("microsoft"):
      result = not isDocker()
    else:
      result = false
  except :
    result = false;
  