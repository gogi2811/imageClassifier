#!/bin/bash
if [[ -z $(which convert) ]]; then
  echo 'imagemagick not found -- please make sure it is installed!'
  exit
fi
for l in $(find ./input/ -maxdepth 1 -mindepth 1 -type d | sed 's/.\/input\///g');do
  echo "$l"
  for i in ./input/$l/unprocessed/*; do
    if [[ ! -e $i ]]; then
      echo 'file does not exist'
      continue
    fi

    tmp='tmp.jpeg'
    # resize and strip metadata out
    convert "$i" -strip -resize '224x224' $tmp
    # use md5sum to protect minimally against duplicates
    name=$(md5sum $tmp)
    # echo $name
    mv -f $tmp "$name.jpeg"
    mv -f "$i" ./input/"$l"/processed/
  done

  # move all files to processed
  mkdir -p "./output/$l"
  mv -f *.jpeg "./output/$l/"
done
