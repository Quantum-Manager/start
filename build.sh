#!/bin/bash

# требования: zip, unzip, curl, jq, git, настроенный доступ ssh в гитхабе

rm -rf tmpbuild
mkdir tmpbuild
cd tmpbuild

# запускаем счет файла
while read line;do
  IFS=";"
  set -- $line

  # папка расширения
  FOLDER=$1

  # название репозитория
  REPO=$2

  # тип скачивания
  TYPE=$3

  # тип скачивания через git с указанием ветки
  if [[ "${TYPE}" == "git" ]]
  then
      BRANCH=$4

      if [[ "${BRANCH}" == "master" ]]
      then
        BRANCH=""
      fi

      if [[ "${BRANCH}" == "main" ]]
      then
        BRANCH=""
      fi

      git clone ${BRANCH} git@github.com:"${REPO}".git ${FOLDER}
      cd "${FOLDER}"
      rm -f README.md
      rm -f .gitignore
      rm -rf .git
      cd ..
  fi

done < ../exts.txt

cd pkg_quantummanager
mv * ..
cd ..
rm -rf pkg_quantummanager
zip -r pkg_quantummanager.zip *
mv pkg_quantummanager.zip ..
cd ..
rm -rf tmpbuild

clear