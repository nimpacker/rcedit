import os,strutils

proc hasDockerEnv(): bool = 
  try:
    result = fileExists("/.dockerenv")
  except:
    result = false


proc hasDockerCGroup(): auto = 
  try:
    result = readFile("/proc/self/cgroup").contains("docker")
  except:
    result = false

proc isDocker*():bool = hasDockerEnv() or hasDockerCGroup()

