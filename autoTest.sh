#!/bin/bash
#export PATH="/usr/local/rbenv/bin:$PATH"
LINE="-------------------------------------------------------"

if test -n "git status --porcelain"; then
echo ${LINE}

     git status --porcelain | while read -r changedFile
     do
         filePath="${changedFile:2}"
         echo ${filePath} 

         if test ${filePath: -3} == '.rb' || test ${filePath: -4} == '.erb'; then   
            resultRubocop=$(bundle exec rubocop ${filePath} | tail -n1)

            if [[ "$resultRubocop" =~ no ]]; then 
               echo -e "\e[33mRubocop        Result :\e[32m${resultRubocop}\e[0m"
            else
               echo -e "\e[33mRubocop        Result :\e[31m${resultRubocop}\e[0m"
            fi

                #.erbファイルならBest Practiceの方のテストも実行
                if  test ${filePath: -4} == '.erb'; then
                resultBestPra=$(bundle exec rails_best_practices ${filePath} | tail -n1)

                    if [[ "$resultBestPra" =~ cool ]]; then 
                        echo -e "\e[33mBest Practice  Result :\e[31m${resultBestPra}\e[0m"
                    else
                        echo -e "\e[33mBest Practice  Result :\e[32m${resultBestPra}\e[0m"
                    fi
                fi

            else echo This is not .rb or .erb file. This file will be ignored.
         fi
         echo ${LINE}
     done

else
     echo All changes has been commited. Move on to your next task.
fi

echo
echo
echo $(git status --porcelain| wc -l) uncommited files has been detected.
echo Auto test has been finished.
