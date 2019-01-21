hash1=$1
hash2=$2
path=$3

getChangedDirectories()
{
  local hash1=$1
  local hash2=$2
  local path=$3
  local startLocation=$PWD;
 
  if [ "$path" != '' ]; then 
    cd $path;
  fi
  escape_path=`echo $PWD | sed s'/\//\\\\\//g'`;
  local gitRoot=`git rev-parse --show-toplevel`;
  local cmd="git diff --stat ${hash1} ${hash2} --name-only $PWD 2>/dev/null | xargs --no-run-if-empty dirname";
  cmd="$cmd | xargs --no-run-if-empty -i echo \"${gitRoot}/{}\"";
  cmd="$cmd | sed \"s/$escape_path\/\?//\" | sed s'/\/.*//g' | sort -u";
  local directories=`eval $cmd`;
  local result="";
  for directory in $directories; do
    if [ -d "$directory" ]; then
      result="$result $directory";
    fi
  done
  echo $result;
  cd $startLocation; 
}

directories=$(getChangedDirectories $hash1 $hash2 $path);
echo $directories
