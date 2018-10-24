#!/bin/bash

# XML patterns for warning and error messages.
TEXT="<text><![CDATA[ %s ]]></text>\n"
TYPE="<type>%s</type>\n"
CLASS="<class>%s</class>\n"
MODULE="<module>%s</module>\n"

# Regular expressions to find modules (MOD_PTRN), njoy messages (MSG_PTRN) and errors (ERR_PTRN).
MOD_PTRN="^\ [a-z]+[\.]{3}[a-z]"
MSG_PTRN="-{3}message\ from\ [a-z0-9]+-{3}"
ERR_PTRN="\*{3}error\ in\ [a-z0-9]+\*{3}"

for file in "$@"
do
  while IFS= read -r line
  do
    ((iline++))
    if [[ $FLAG -eq 1 ]]
    then
      echo "<message>"
      printf "$TYPE" warning
      printf "$CLASS" NJOY
      printf "$MODULE" $module 
      if [[ "$line" =~ ^\ {26}[a-z]+ ]] # it is a message continuation if the line starts with 26 whitespaces
      then
        printf "$TEXT" "$(echo -e "$oldline\n$line"|tr -s " ")"
      else
        printf "$TEXT" "$(echo -e "$oldline"|tr -s " ")"
      fi
      echo "</message>"
      FLAG=0
    elif [[ $FLAG -eq 2 ]]
    then
      echo "<message>"
      printf "$TYPE" error
      printf "$CLASS" NJOY
      printf "$MODULE" $module 
      if [[ "$line" =~ ^\ {22}[a-z]+ ]] # it is an error continuation if the line starts with 22 whitespaces
      then
        printf "$TEXT" "$(echo -e "$oldline\n$line"|tr -s " ")"
      else
        printf "$TEXT" "$(echo -e "$oldline"|tr -s " ")"
      fi
      echo "</message>"
      FLAG=0
    else
      [[ "$line" =~ $MOD_PTRN ]] && module=$(echo "$line" | cut -d. -f1 | xargs)
      [[ "$line" =~ $MSG_PTRN ]] && FLAG=1
      [[ "$line" =~ $ERR_PTRN ]] && FLAG=2
    fi
    oldline="$line"
  done < $file
done
