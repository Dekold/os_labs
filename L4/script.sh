#!/bin/bash
#Создаю список групп 
Group_List()
{
	rm -f group_list
	ls labfiles/students/groups > group_list
}
#Основное задание - найти фамилии студентов с меньшим количеством переписываний
Least_Rewrites()
{
	rm -f tl1
	rm -f tl2
	rm -f res
	rm -f tf
	Group_List
	# tl1 - список всех студентов в формате <Группа>;<Студент> (Защита от совпадающих фамилий в разных группах)
	while read -r STR_GROUP;
	do
		while read -r STR_NAME;
		do
			printf "%s;%s\n" $STR_GROUP $STR_NAME >> tl1
		done < labfiles/students/groups/$STR_GROUP
	done < group_list
	BEST=999999999999999
	#echo "$(ls labfiles/Пивоварение/tests | sed 's/^/Пивоварение\/tests\//')" > tf
	#echo "$(ls labfiles/Криптозоология/tests | sed 's/^/Криптозоология\/tests\//')" >> tf
	while read -r STR;
	do
		COUNT=0
		# Если мы нашли одно или больше упоминание о студенте в файле тестов значит его надо прибавить к счетчику переписываний и вычесть 1 (первый раз за переписывание не считается)
		## Этот вариант кода должен быть в целом лучше (я ищу файлы тестов делаю из них список по которому далее прохожу в цикле), но он не работает
		##while read -r STR_TESTFILES < tf;
		##do
		##	COUNT_TEMP=$(grep -c "$STR" "labfiles/$STR_TESTFILES")
		##	if [[ $((COUNT_TEMP)) -ge 1 ]];
		##	then COUNT=$COUNT+$((COUNT_TEMP))-1 
		##	fi			
		##done
		FILE=labfiles/Пивоварение/tests/TEST-1
		if [ -r $FILE ] && [ -s $FILE ];
		then
			COUNT_TEMP=$(grep -c "$STR" $FILE)
                	if [[ $((COUNT_TEMP)) -ge 1 ]];
                	then 
				COUNT=$COUNT+$((COUNT_TEMP))-1 
                	fi
		fi
		FILE=labfiles/Пивоварение/tests/TEST-2
		if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then 
                                COUNT=$COUNT+$((COUNT_TEMP))-1 
                        fi
                fi
		FILE=labfiles/Пивоварение/tests/TEST-3
		if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then 
                                COUNT=$COUNT+$((COUNT_TEMP))-1 
                        fi
                fi
		FILE=labfiles/Пивоварение/tests/TEST-4
		if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then 
                                COUNT=$COUNT+$((COUNT_TEMP))-1 
                        fi
                fi
		FILE=labfiles/Криптозоология/tests/TEST-1
		if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then
                                COUNT=$COUNT+$((COUNT_TEMP))-1
                        fi
                fi
		FILE=labfiles/Криптозоология/tests/TEST-2
                if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then
                                COUNT=$COUNT+$((COUNT_TEMP))-1
                        fi
                fi
		FILE=labfiles/Криптозоология/tests/TEST-3
                if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then
                                COUNT=$COUNT+$((COUNT_TEMP))-1
                        fi
                fi
		FILE=labfiles/Криптозоология/tests/TEST-4
                if [ -r $FILE ] && [ -s $FILE ];
                then
                        COUNT_TEMP=$(grep -c "$STR" $FILE)
                        if [[ $((COUNT_TEMP)) -ge 1 ]];
                        then
                                COUNT=$COUNT+$((COUNT_TEMP))-1
                        fi
                fi
                printf "%s;%d\n" $STR $((COUNT)) >> tl2
		#Если меньшее количество равно текущему записываем текущее в результат
		if [ $((COUNT)) -eq $((BEST)) ];
		then 
			echo $STR | sed 's/^[AА]-[0-9]*-[0-9]*;//' >> res;
		# Если же оно меньше  обновляем меньшее и переписываем результат
		elif [ $((COUNT)) -lt $((BEST)) ]; 
		then 
			BEST=$((COUNT))
	       		echo $BEST > res
	       		echo $STR | sed 's/^[AА]-[0-9]*-[0-9]*;//' >> res;	

		fi	
	done < tl1
	LEAST_REWRITES=$(let $(head -n 1 res))
	printf "Минимальное количество переписываний: %d\n" $LEAST_REWRITES
	#Если у нас лишь две строки - только один лучший студент то выписываем лишь его
	if [ $(wc -l < res) -eq 2 ];
	then
		printf "Фамилия студента: %s\n" $(tail -n 1 res);
	#Если больше выписываем всех лучших
	else
		printf "Фамилии студентов:\n"
		sed '1d' res | while read -r STR;
		do
			printf "%s\n" $STR;
		done;
	fi
}
Students_List()
{
	#Если нет аттрибута из вне запрашиваем имя группы
	if [ -z $1 ];
	then
		printf "Выберете группу:\n"
		Group_List
		#Кошку тут использовать целесобразно так как нам надо вывести на экран файл списка (не абьюз!)
		cat group_list
		printf "\n"
		GROUP=''
		read -r GROUP;
	else
		GROUP=$1;
	fi
	printf "\nГруппа %s:\n" $GROUP 
	#Если не нашли файл с введенным именем группы говорим об этом
	if [ -z $(find -name $GROUP) ];
	then
		printf "Группа %s не найдена\n" $GROUP 
		return;
	fi
	# Здесь тоже! Мы просто выводим список группы на экран
	cat labfiles/students/groups/$GROUP
}
Students_Notes()
{
	#Если нет аттрибута из вне запрашиваем имя студента
	if [ -z $1 ]
	then
		printf "Введите имя студента:\n"
		NAME=''
		read -r NAME;
	else
		NAME=$1;
	fi
	printf "\nИмя студента: %s\n" $NAME
	#Ищем файл с первой буквой введенной фамилии если он есть продолжаем иначе сразу говорим что ввод неверен
	NOTEFILE="$(echo $NAME | head -c 1)Names.log"
	RES=$(find -name $NOTEFILE)
	if [ -z $RES ]
	then
		printf "Студент %s не найден\n" $NAME
		return;
	fi
	#Если нашли 1 упоминание выводим лишь один студент иначе говорим юзеру количество найденных студентов
	COUNT=$(grep -c $NAME < $RES) 
	if [ $((COUNT)) -eq 1 ]
	then
		printf "Найденный студент:\n"
	else
		printf "Найденно %d студентов:\n" $COUNT
	fi
	grep -A 1 $NAME < $RES
}
Menu()
{
	#Меню взаимодействия
	CHAR=''
	printf "Выберете команду:\n B - найти студента(ов) с меньшим количеством переписываний.\n L - вывести лист данной группы.\n N - вывести досье на данного студента.\n T - убрать временные файлы\n========\n"
	while read -r CHAR
	do
		if [ -z $CHAR ]
		then
			return;
		elif [ $CHAR == 'B' ] || [ $CHAR == 'b' ]
		then
			Least_Rewrites;
		elif [ $CHAR == 'L' ] || [ $CHAR == 'l' ]
		then
			Students_List;
		elif [ $CHAR == 'N' ] || [ $CHAR == 'n' ]
		then
			Students_Notes;
		elif [ $CHAR == 'T' ] || [ $CHAR == 't' ]
		then
			rm -f group_list
        		rm -f tl1
        		rm -f tl2
        		rm -f tf
		        rm -f res;
		else
			echo "Неизвесная команда";
		fi
		printf "========\nВыберете команду:\n B - найти студента(ов) с меньшим количеством переписываний.\n L - вывести лист данной группы.\n N - вывести досье на данного студента.\n T - убрать временные файлы\n========\n"
	done
}

#Если скрипт вводится без параметров кидаем юзеру меню иначе сразу переходим к выбранной команде по аттрибуту
printf "Parametr 1: %s Parametr 2: %s\n" $1 $2
if [ -z $1 ]
then
	Menu;
elif [ $1 == '--best' ] || [ $1 == '-b' ]
then
	Least_Rewrites;
elif [ $1 == '--list' ] || [ $1 == '-l' ]
then
	Students_List $2;
elif [ $1 == '--notes' ] || [ $1 == '-n' ]
then
	Students_Notes $2;
elif [ $1 =='--temp' ] || [ $1 == '-t' ]
then
	rm -f group_list
	rm -f tl1
	rm -f tl2
	rm -f tf
	rm -f res;
else
	echo "Неизвесная команда. Попробуйте запустить скрипт без флагов."
fi
