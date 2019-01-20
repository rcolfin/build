hash1=$1
hash2=$2
path=$3

getChangedDirectories()
{
  local hash1=$1
  local hash2=$2
  local path=$3
  local cmd="git diff --stat ${hash1} ${hash2} --name-only $path 2>/dev/null | xargs --no-run-if-empty dirname";
  if [ "$path" != '' ]; then
    cmd="$cmd | sed s'/$path\///g'";
    path="/$path";
  fi
  cmd="$cmd | sed s'/\/.*//g' | sed s'/\.//g' | sort -u | xargs --no-run-if-empty -i echo \"$PWD$path/{}\"";
  local directories=`eval $cmd`;
  local result="";
  for directory in $directories; do
    if [ -d "$directory" ]; then
      result="$result $directory";
    fi
  done
  echo $result;
}

directories=$(getChangedDirectories $hash1 $hash2 $path);
echo $directories