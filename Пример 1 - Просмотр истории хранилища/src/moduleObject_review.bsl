// +++ Эти переменные потом пересоздаются локально в процедуре ЗагрузитьИсторию()
Перем мТЗHistory;
Перем мТЗUsers;
Перем мТЗVersions;
Перем мТЗObjects;
Перем мТЗИменаКлассов;
Перем мИмяКлассаОбъекта_Конфигурация;

// +++ Плохое название функции. Не следует начинать с Получить...
// +++ Не нашел использование этой функции из вне, возможно, не нужен Экспорт
Функция ПолучитьТЗИсторияХранилища(ДопПараметры) Экспорт
	
	ЗагрузитьИсторию();
	
	ТЗИсторияХранилищаСтруктура = ДопПараметры.ТЗИсторияХранилищаСтруктура;
	ТЗИзмененныеОбъектыСтруктура = ДопПараметры.ТЗИзмененныеОбъектыСтруктура;
	
	ТЗИсторияХранилища = ТЗИсторияХранилищаСтруктура.СкопироватьКолонки();
	
	// +++ Здесь и далее не каноничное написание ключевых слов Каждого, Из, Цикл, КонецЕсли и так далее.
	Для каждого СтрокаИсторияХранилища из ИсторияХранилища цикл
		пВерсия = СтрокаИсторияХранилища.Версия;
		
		СтрокаТЗИсторияХранилища = ТЗИсторияХранилища.Добавить();
		СтрокаТЗИсторияХранилища.Версия = пВерсия;
		// +++ Лучше использовать ЗаполнитьЗначениеСвойств()
		СтрокаТЗИсторияХранилища.ДатаВерсии = СтрокаИсторияХранилища.ДатаВерсии;
		СтрокаТЗИсторияХранилища.ПользовательХранилища = СтрокаИсторияХранилища.ПользовательХранилища;
		СтрокаТЗИсторияХранилища.Комментарий = СтрокаИсторияХранилища.Комментарий;
		
		// +++ Не хватает пробелов вокруг =
		ПараметрыОтбора=Новый Структура();
		// +++ Не хватает пробела после запятой
		ПараметрыОтбора.Вставить("Версия",пВерсия);
		НайденныеСтрокиИзмененныеОбъекты = ИзмененныеОбъекты.НайтиСтроки(ПараметрыОтбора);
		ВсегоНайденныеСтроки = НайденныеСтрокиИзмененныеОбъекты.Количество();
		ТекстОшибки = "";
		Если ВсегоНайденныеСтроки = 0 Тогда // +++ Возможно, лучше использовать НайденныеСтрокиИзмененныеОбъекты.Количество() сразу в условии
			// +++ Кажется, что нужна локализация строки НСтр()
			ТекстОшибки = "Ошибка! Не найдена строка";
		Конецесли;
		
		// +++ Кажется, что условие не нужно и все что находится в этом условии можно сделать выше, где проверяем на 0
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			// +++ Лучше использовать СтрШаблон вместо конкантенации строк.
			// ТекстОшибки = СтрШаблон("Ошибка! Не найдена строка в ""ИзмененныеОбъекты"" для Версия = %1", ПараметрыОтбора.Версия);
			ТекстОшибки = ТекстОшибки  
				+" в ""ИзмененныеОбъекты"" для ";
			Для каждого ЭлементОтбора из ПараметрыОтбора цикл
				ТекстОшибки = ТекстОшибки  
					+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
			Конеццикла;
			ВызватьИсключение ТекстОшибки;	
		Конецесли;
		
		// +++ То есть можно сделать вот так:
		// Если НайденныеСтрокиИзмененныеОбъекты.Количество() = 0 Тогда
		//		ТекстОшибки = СтрШаблон("Ошибка! Не найдена строка в ""ИзмененныеОбъекты"" для Версия = %1", ПараметрыОтбора.Версия);
		//		ВызватьИсключение ТекстОшибки;
		//		Продолжить;	
		// Конецесли;
		
		ТЗИзмененныеОбъекты = ТЗИзмененныеОбъектыСтруктура.СкопироватьКолонки();
		Для каждого СтрокаИзмененныеОбъекты из НайденныеСтрокиИзмененныеОбъекты цикл
			СтрокаТЗИзмененныеОбъекты = ТЗИзмененныеОбъекты.Добавить();
			// +++ Лучше использовать ЗаполнитьЗначениеСвойств()
			СтрокаТЗИзмененныеОбъекты.ВидИзменения = СтрокаИзмененныеОбъекты.ВидИзменения; 
			// +++ Слишком длинная строка
			СтрокаТЗИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных = СтрокаИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных;
		Конеццикла;
		СтрокаТЗИсторияХранилища.ТЗИзмененныеОбъекты = ТЗИзмененныеОбъекты;
	Конеццикла;
	
	Возврат ТЗИсторияХранилища;
КонецФункции

Процедура ЗагрузитьИсторию() Экспорт
	// +++ Следует использовать ТекущаяДатаСеанса(), вместо ТекущаяДата()
	ВремяНачала=ТекущаяДата();
	
	мТЗHistory = Неопределено;
	мТЗUsers = Неопределено;
	мТЗVersions = Неопределено;
	мТЗObjects = Неопределено;
	
	ЗагрузитьДанныеВТЗИзХранилища();
	
	ВывестиСообщение("Заполнение ТЧ Обработки"); // +++ Для логов можно писать больше информации и расшифровать ТЧ
	мТЗИменаКлассов = ПолучитьТЗИменаКлассов();
	
	// +++ Не нашел установку этой переменной. Возможно, перепутана с мЭтоОтладка
	Если ВывестиСлужебнуюТаблицу Тогда
		// +++ Из описания условия не понятно, почему не заполняем ТЧОбработки в этом случае
		СоединитьТаблицыТЗHistoryИТЗOBJECTS(мТЗHistory,мТЗObjects);		
	Иначе
		ЗаполнитьТЧОбработки();
	Конецесли;
	
	// +++ Очень смущает обнуление переменных после использования - не понятно ради чего это делается.
	// Если это очень важно, то возможно стоит написать комментарий.
	мТЗHistory = Неопределено;
	мТЗUsers = Неопределено;
	мТЗVersions = Неопределено;
	мТЗObjects = Неопределено;
	мТЗИменаКлассов = Неопределено;
	
	// +++ Следует использовать ТекущаяДатаСеанса(), вместо ТекущаяДата()
	ВремяКонца=ТекущаяДата();
	
	ВывестиСообщение("------------------------------------------------------------------");
	ВывестиСообщение("ВремяНачала -"+ВремяНачала);
	ВывестиСообщение("ВремяКонца  -"+ВремяКонца);
	ВывестиСообщение("Общее время выполнения - "+ОКР(((ВремяКонца-ВремяНачала)/60),2) +" мин."); // +++ Возможно лучше использовать РазностьДат()
	ВывестиСообщение("------------------------------------------------------------------");		
КонецПроцедуры 

Процедура ЗагрузитьДанныеВТЗИзХранилища()
	
	РезультатВыгрузки = ВыгрузитьТаблицыХранилищаВФайлы();
	
	// +++ Возможно стоит сделать массив("History, Users, Versions, OBJECTS"), а затем перебрать значения этого массива и выполнить все наши действия.
	// +++ МассивИменТаблиц = Новый Массив;
	//	   МассивИменТаблиц.Добавить("History");
	//	   МассивИменТаблиц.Добавить("Users");
	// Для Каждого ИмяТаблицы Из МассивИменТаблиц Цикл
	//	ДопПараметры.Вставить("ИмяПространстваИмен",СтрШаблон("http://localhost/уз%1XDTO", ИмяТаблицы));
	//  ДопПараметры.Вставить("ИмяТаблицы", ИмяТаблицы);
	// 
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узHISTORYXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","HISTORY");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаHISTORY);
	
	мТЗHistory = ПолучитьТЗИзФайла(ДопПараметры);
	
	// +++ Возможно, не нужно каждый раз создавать новую структуру. Можно использовать ту же, просто менять у нее значения.
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узUSERSXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","USERS");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаUSERS);
	
	мТЗUsers = ПолучитьТЗИзФайла(ДопПараметры);	
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узVERSIONSXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","VERSIONS");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаVERSIONS);
	
	мТЗVersions = ПолучитьТЗИзФайла(ДопПараметры);

	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ИмяПространстваИмен","http://localhost/узOBJECTSXDTO");
	ДопПараметры.Вставить("ИмяТаблицы","OBJECTS");
	ДопПараметры.Вставить("ИмяФайлаДляЗагрузки",РезультатВыгрузки.ИмяФайлаOBJECTS);
	
	мТЗObjects = ПолучитьТЗИзФайла(ДопПараметры);	
	
	УдалитьВременныеФайлы(РезультатВыгрузки);
КонецПроцедуры 

Функция ЗаполнитьТЧОбработки() 
	ИсторияХранилища.Очистить();
	ИзмененныеОбъекты.Очистить();
	
	// +++ Чем отличаются пВерсияПо и ВерсияПо?
	пВерсияПо = ВерсияПо;
	Если пВерсияПо = 0 Тогда
		пВерсияПо = 9999999999;	// +++ Возможно, стоит смотреть на мТЗVersions.Количество()
	Конецесли;
	
	Для каждого СтрокамТЗVersions из мТЗVersions цикл
		пVERNUM = СтрокамТЗVersions.VERNUM;
		Если ВерсияС <= пVERNUM
			И пVERNUM <= пВерсияПо Тогда
			// +++ Лучше обернуть это условие в Не и оставить только одну ветку с Продолжить
			// +++ Возможно, если версия еще не началась, то это Продолжить, а если версия уже превышает, то лучше использовать Прекратить()
		Иначе
			Продолжить;
		Конецесли;
		
		СтрокаИсторияХранилища = ИсторияХранилища.Добавить();
		// +++ Возможно, лучше создать Структуру словарь, чтобы один раз его наполнить и потом использовать
		// +++ Пример Словарь = Новый Структура("Версия, ДатаВерсии", "пVERNUM", "VERDATE");
		//               СтрокаИсторииХранилища.Версия = Объект[Словарь.Версия];
		//               СтрокаИсторииХранилища.ДатаВерсии = СтрокамТЗVersions[Словарь.ДатаВерсии];
		СтрокаИсторияХранилища.Версия = пVERNUM;
		СтрокаИсторияХранилища.ДатаВерсии = СтрокамТЗVersions.VERDATE;
		пUSERID = СтрокамТЗVersions.USERID;
		СтрокаИсторияХранилища.ПользовательХранилища = ПолучитьПользователяХранилища(пUSERID);
		СтрокаИсторияХранилища.Комментарий = СтрокамТЗVersions.COMMENT;
		СтрокаИсторияХранилища.ВерсияКонфигурации = СтрокамТЗVersions.CODE;
		
		ПараметрыОтбора=Новый Структура();
		ПараметрыОтбора.Вставить("VERNUM",пVERNUM);
		НайденныеСтрокимТЗHistory = мТЗHistory.НайтиСтроки(ПараметрыОтбора);
		ВсегоНайденныеСтроки = НайденныеСтрокимТЗHistory.Количество();
		// +++ Выше описывал как можно упростить вывод ошибки в 3 строчки, вместо этого кода.
		ТекстОшибки = "";
		Если ВсегоНайденныеСтроки = 0 тогда
			ТекстОшибки = "Ошибка! Не найдена строка";
			ТекстОшибки = ТекстОшибки  
				+" в ""мТЗHistory"" для ";
			Для каждого ЭлементОтбора из ПараметрыОтбора цикл
				ТекстОшибки = ТекстОшибки  
					+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
			Конеццикла;
			ВызватьИсключение ТекстОшибки;				
		Конецесли;
		
		Для каждого СтрокамТЗHistory из НайденныеСтрокимТЗHistory цикл
			ПолноеИмяМетаданных = "";
			// +++ Две точки запятых в конце
			ПолноеИмяМетаданных = ПолучитьПолноеИмяМетаданных(ПолноеИмяМетаданных,СтрокамТЗHistory);;			
			
			СтрокаИзмененныеОбъекты = ИзмененныеОбъекты.Добавить();
			СтрокаИзмененныеОбъекты.Версия = пVERNUM;
			СтрокаИзмененныеОбъекты.ВидИзменения = ПолучитьВидИзменения(СтрокамТЗHistory);						
			СтрокаИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных = ПолноеИмяМетаданных;
		Конеццикла;
		
	Конеццикла;
	ИсторияХранилища.Сортировать("Версия");
КонецФункции 

Функция ПолучитьПолноеИмяМетаданных(ПолноеИмяМетаданных,СтрокамТЗHistory) 
	ИмяОбъекта = СтрокамТЗHistory.OBJNAME;	
	ИмяКлассаОбъекта = ПолучитьИмяКлассаОбъекта(СтрокамТЗHistory.OBJID);	
	
	// +++ Сложно понять, как работает эта функция. 
	// Либо ее упростить, либо добавить комментарии.

	Если ЗначениеЗаполнено(ПолноеИмяМетаданных) Тогда
		Если ИмяКлассаОбъекта <> мИмяКлассаОбъекта_Конфигурация Тогда
			ПолноеИмяМетаданных = ИмяКлассаОбъекта + "."+ИмяОбъекта +"."+ ПолноеИмяМетаданных;	
		Конецесли;
	Иначе
		Если ИмяКлассаОбъекта = мИмяКлассаОбъекта_Конфигурация Тогда
			ПолноеИмяМетаданных = ИмяОбъекта;
		Иначе
			ПолноеИмяМетаданных = ИмяКлассаОбъекта + "."+ИмяОбъекта; // +++ СтрШаблон	
		Конецесли;
	Конецесли;
	
	СтрокаРодителя = ПолучитьСтрокуРодителя(СтрокамТЗHistory);
	Если ЗначениеЗаполнено(СтрокаРодителя) Тогда
		// +++ Здесь функция используется как процедура - лучше использовать возвращаемое значение.
		ПолучитьПолноеИмяМетаданных(ПолноеИмяМетаданных,СтрокаРодителя) // +++ Не хватает точки с запятой	
	Конецесли;
	
	Возврат ПолноеИмяМетаданных;
КонецФункции 

Функция ПолучитьСтрокуРодителя(СтрокамТЗHistoryРебенок) 
	Перем СтрокаРодителя;
	
	РодительOBJID = СтрокамТЗHistoryРебенок.PARENTID;
	РебенокVERNUM = СтрокамТЗHistoryРебенок.VERNUM;	
	
	Если РодительOBJID = "00000000-0000-0000-0000-000000000000" Тогда
		Возврат СтрокаРодителя;
	Конецесли;	
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("OBJID",РодительOBJID);
	НайденныеСтроки = мТЗHistory.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтроки.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 Тогда
		СтрокаРодителя = НайденныеСтроки[0];
		// +++ Стоит добавить возврат, чтобы не читать дальше функцию	
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда		
		МаксVERNUM = 0;
		Для каждого СтрокамТЗHistory из НайденныеСтроки цикл
			Если СтрокамТЗHistory.VERNUM > РебенокVERNUM Тогда
				Прервать;
			Конецесли;
			// +++ ИначеЕсли?
			Если МаксVERNUM < СтрокамТЗHistory.VERNUM Тогда
				МаксVERNUM = СтрокамТЗHistory.VERNUM;	
				СтрокаРодителя = СтрокамТЗHistory;	
			Конецесли;
		КонецЦикла;
		// +++ НЕ написано не канонически
		Если НЕ ЗначениеЗаполнено(СтрокаРодителя) Тогда
			ТекстОшибки = "Ошибка! не удалось найти строку родителя";
		// +++ Возможно, следует сделать Иначе с выходом со СтрокойРодителя, чтобы не ждать конца кода
		Конецесли;		
	Иначе
		ТекстОшибки = "Ошибка! не удалось найти строку родителя";		
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗHistory"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		ВызватьИсключение ТекстОшибки;	
	Конецесли;
	
	Возврат СтрокаРодителя;
КонецФункции 

Функция ПолучитьИмяКлассаОбъекта(ЗНАЧ OBJID) 
	Перем CLASSID;
	Перем ИмяКласса;
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("OBJID",OBJID);
	НайденныеСтрокимТЗObjects = мТЗObjects.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтрокимТЗObjects.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗObjects = НайденныеСтрокимТЗObjects[0];	
		CLASSID = СтрокамТЗObjects.CLASSID;
	// +++ Сделать Иначе и туда уйти с описанием ошибки
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки";
	Иначе
		ТекстОшибки = "Ошибка! Не найдена строка";
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗObjects"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		ВызватьИсключение ТекстОшибки;	
	Конецесли;
	
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("CLASSID",CLASSID);
	НайденныеСтрокимТЗИменаКлассов = мТЗИменаКлассов.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтрокимТЗИменаКлассов.Количество();
	ТекстОшибки = "";
	// +++ см. те же замечания, что и выше.
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗИменаКлассов = НайденныеСтрокимТЗИменаКлассов[0];	
		ИмяКласса = СтрокамТЗИменаКлассов.ИмяКласса; 
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки";
	Иначе
		ТекстОшибки = "Ошибка! Не найдена строка";
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗИменаКлассов"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		// +++ Почему тут не делаем ВызватьИсключение(), а в других похожих местах делали
		Сообщить(ТекстОшибки);	
		ИмяКласса = "";
	Конецесли;
	
	Возврат ИмяКласса;	
КонецФункции 

Функция ПолучитьВидИзменения(СтрокамТЗHistory) 
	
	// +++ На сервере можно не использовать ПредопределенноеЗначение, а использовать прямое обращение
	пВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Изменен");
	
	// +++ Лучше использовать Если ... ИначеЕсли ... Иначе
	// Тогда будет понятно, что может быть только один конкретный вид изменений.
	Если СтрокамТЗHistory.SELFVERNUM = 1 Тогда
		пВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Добавлен");
	Конецесли;
	
	Если СтрокамТЗHistory.REMOVED  Тогда
		пВидИзменения = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Удален");
	Конецесли;	
	
	Возврат пВидИзменения;
КонецФункции 

Функция ПолучитьПользователяХранилища(пUSERID) 
	Перем пПользовательХранилища;
	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("USERID",пUSERID);
	НайденныеСтроки = мТЗUsers.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтроки.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗUsers = НайденныеСтроки[0];
		пПользовательХранилища = СтрокамТЗUsers.Name;
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки";
	Иначе
		ТекстОшибки = "Ошибка! Не найдена строка";
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗUsers"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		ВызватьИсключение ТекстОшибки;	
	Конецесли;
	
	Возврат пПользовательХранилища;
КонецФункции 

Функция ПолучитьТЗИменаКлассов() 
	Массив=Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ТипСтрока_150 = Новый ОписаниеТипов(Массив, , ,Новый КвалификаторыСтроки(150));		
	
	ТЗИменаКлассов = Новый ТаблицаЗначений;
	 // +++ Разное получение типов строки для колонок. Лучше оставить какой-то один.
	 // +++ Возможно, стоит использовать функцию с получением типа и длиной строки в качестве переменной.
	ТЗИменаКлассов.Колонки.Добавить("CLASSID",ПолучитьТипСтрока36());
	ТЗИменаКлассов.Колонки.Добавить("ИмяКласса",ТипСтрока_150);
	
	Макет = ПолучитьМакет("ИменаКлассов");

	Для НомерСтроки = 2 По Макет.ВысотаТаблицы Цикл
		CLASSID = СокрЛП(Макет.Область(НомерСтроки,1).Текст);
		ИмяКласса = СокрЛП(Макет.Область(НомерСтроки,2).Текст);
		// +++ Возможно, лучше заменить вот на этот код
		// ДанныеМакета = Новый Структура("CLASSID, ИмяКласса", СокрЛП(Макет.Область(НомерСтроки,1).Текст, ...);
		// ЗаполнитьЗначенияСвойств(ТЗИменаКлассов.Добавить(), ДанныеМакета);

		СтрокаТЗИменаКлассов = ТЗИменаКлассов.Добавить();
		СтрокаТЗИменаКлассов.CLASSID = CLASSID;
		СтрокаТЗИменаКлассов.ИмяКласса = ИмяКласса;
		
	КонецЦикла;
	
	Возврат ТЗИменаКлассов;	
КонецФункции 

Процедура СоединитьТаблицыТЗHistoryИТЗOBJECTS(ТЗHistory,ТЗOBJECTS)
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТЗHISTORY.OBJID КАК OBJID,
	|	ТЗHISTORY.OBJNAME КАК OBJNAME,
	|	ТЗHISTORY.PARENTID КАК PARENTID,
	|	ТЗHISTORY.REMOVED КАК REMOVED,
	|	ТЗHISTORY.SELFVERNUM КАК SELFVERNUM,
	|	ТЗHISTORY.VERNUM КАК VERNUM
	|ПОМЕСТИТЬ ТЗHISTORY
	|ИЗ
	|	&ТЗHISTORY КАК ТЗHISTORY
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗOBJECTS.OBJID, // +++ Нет псевдонима для полей
	|	ТЗOBJECTS.CLASSID
	|ПОМЕСТИТЬ ТЗOBJECTS
	|ИЗ
	|	&ТЗOBJECTS КАК ТЗOBJECTS
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗHISTORY.OBJID КАК OBJID,
	|	ТЗHISTORY.OBJNAME КАК OBJNAME,
	|	ТЗHISTORY.PARENTID КАК PARENTID,
	|	ТЗHISTORY.REMOVED КАК REMOVED,
	|	ТЗHISTORY.SELFVERNUM КАК SELFVERNUM,
	|	ТЗHISTORY.VERNUM КАК VERNUM,
	|	ТЗOBJECTS.OBJID КАК OBJID_ТЗOBJECTS,
	|	ТЗOBJECTS.CLASSID КАК CLASSID
	|ИЗ
	|	ТЗHISTORY КАК ТЗHISTORY
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗOBJECTS КАК ТЗOBJECTS
	|		ПО ТЗHISTORY.OBJID = ТЗOBJECTS.OBJID
	|");

	Запрос.УстановитьПараметр("ТЗHISTORY", ТЗHistory);
	Запрос.УстановитьПараметр("ТЗOBJECTS", ТЗOBJECTS);

	РезультатЗапроса = Запрос.Выполнить();
	// +++ Если не проверяем результат запроса, то кажется, можно сделать сразу Запрос.Выполнить().Выгрузить();
	ТЗРезультат = РезультатЗапроса.Выгрузить();
	
	ТабДок = Новый ТабличныйДокумент;
    
    Построитель = Новый ПостроительОтчета();

    Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТЗРезультат);
    Построитель.ВыводитьЗаголовокОтчета = Ложь;
    Построитель.Вывести(ТабДок);

	// +++ Лучше использовать СтрШаблон вместо конкантенации строк
	// +++ Следует использовать ПолучитьИмяВременногоФайла("xlsx");
    ИмяФайла = "" + КаталогВременныхФайлов() + "\History.xlsx";
    
    ТабДок.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.XLSX);	
	Сообщить("Сохранена служебная таблица: " + ИмяФайла);
		
КонецПроцедуры 

// +++ Здесь и в других местах функции не стоит начинать с Получить, см. стандарт - https://its.1c.ru/db/v8std#content:647:hdoc
Функция ПолучитьТЗИзФайла(ДопПараметры) 
	Перем ТЗИзФайла;
	
	ИмяФайлаДляЗагрузки = ДопПараметры.ИмяФайлаДляЗагрузки; 
	ИмяПространстваИмен = ДопПараметры.ИмяПространстваИмен;
	ИмяПакетаXDTO = "Table";
	ИмяТаблицы = ДопПараметры.ИмяТаблицы;
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаДляЗагрузки ,КодировкаТекста.UTF16);               // XML документ не имеет атрибута
	СтрокаXML = ЧтениеТекста.Прочитать();                                                        // xmlns - URIПространстваИмен
	// +++ Удалить закомментированный код
	//СтрокаXML = СтрЗаменить(СтрокаXML,"<Records","<Records xmlns="""+ИмяПространстваИмен+""" ");	
	//СтрокаXML = СтрЗаменить(СтрокаXML,"<Table Name=""HISTORY""","<Table Name=""HISTORY"" xmlns="""+ИмяПространстваИмен+""" ");
	СтрокаXML = СтрЗаменить(СтрокаXML,"<Table Name="""+ИмяТаблицы+"""","<Table Name="""+ИмяТаблицы+""" xmlns="""+ИмяПространстваИмен+""" ");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ПакетХранилищаXDTO = ФабрикаXDTO.Тип(ИмяПространстваИмен,ИмяПакетаXDTO);
	Если ПакетХранилищаXDTO = Неопределено Тогда
		ВызватьИсключение "Ошибка! не удалось определить Тип пакета XDTO";
	Конецесли;
	ФайлХранилища = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,ПакетХранилищаXDTO);

	ТЗИзФайла = ПолучитьОписаниеТЗИзФайла(ИмяТаблицы);
	// +++ Кажется, что в рабочем коде это стоит убрать.
	#Если Тромбон тогда
		ТЗИзФайла = Новый ТаблицаЗначений;
	#Конецесли
	
	Для каждого СтрокаRecord из ФайлХранилища.Records.Record цикл
		СтрокаТЗИзФайла = ТЗИзФайла.Добавить();
		Для каждого Колонка из ТЗИзФайла.Колонки цикл
			ИмяКолонки = Колонка.Имя;
			ЗначениеИзФайла = СтрокаRecord[ИмяКолонки];
			
			СтрокаТЗИзФайла[ИмяКолонки] = ЗначениеИзФайла;
		Конеццикла;
	КонецЦикла;
	
	// +++ Непонятно зачем сбрасываем локальную переменную.
	ФайлХранилища = Неопределено;
	Возврат ТЗИзФайла;	
КонецФункции 

Функция ПолучитьТипСтрока36() 
	// +++ КвалификаторыСтроки лучше передавать как параметр.
	Массив=Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ТипСтрока_36 = Новый ОписаниеТипов(Массив, , ,Новый КвалификаторыСтроки(36));	
	
	Возврат ТипСтрока_36;
КонецФункции 

Функция ПолучитьОписаниеТЗИзФайла(ИмяТаблицы) 
	Перем ТЗИзФайла;
	
	ТипСтрока_36 = ПолучитьТипСтрока36();
	
	Если ИмяТаблицы = "HISTORY" Тогда
		ТЗИзФайла = Новый ТаблицаЗначений();
		// +++ Лучше использовать функции конструкторы
		ТЗИзФайла.Колонки.Добавить("OBJID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("VERNUM",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("SELFVERNUM",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("OBJVERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("PARENTID",ТипСтрока_36);	
		ТЗИзФайла.Колонки.Добавить("OWNERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("OBJNAME",Новый ОписаниеТипов("Строка"));
		ТЗИзФайла.Колонки.Добавить("OBJPOS",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("REMOVED",Новый ОписаниеТипов("Булево"));
		
		ТЗИзФайла.Индексы.Добавить("VERNUM,OBJID,PARENTID");
		
	ИначеЕсли ИмяТаблицы = "USERS" Тогда
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("USERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("NAME",Новый ОписаниеТипов("Строка"));
		
	ИначеЕсли ИмяТаблицы = "VERSIONS" Тогда
		
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("VERNUM",Новый ОписаниеТипов("Число"));
		ТЗИзФайла.Колонки.Добавить("USERID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("VERDATE",Новый ОписаниеТипов("Дата"));
		ТЗИзФайла.Колонки.Добавить("COMMENT",Новый ОписаниеТипов("Строка"));
		ТЗИзФайла.Колонки.Добавить("CODE",Новый ОписаниеТипов("Строка"));
		
	ИначеЕсли ИмяТаблицы = "OBJECTS" Тогда
		
		ТЗИзФайла = Новый ТаблицаЗначений();
		ТЗИзФайла.Колонки.Добавить("OBJID",ТипСтрока_36);
		ТЗИзФайла.Колонки.Добавить("CLASSID",ТипСтрока_36);
		 // +++ Стоит удалить закомментированный код
		//ТЗИзФайла.Колонки.Добавить("SELFVERNUM",Новый ОписаниеТипов("Число"));
	Иначе
		// +++ В каком случае мы попадем сюда? Вроде бы не должны, потому что мы сами определяем, что вызываем.
		ВызватьИсключение "Ошибка! Нет алгоритма описание ТЗИзФайла для ["+ИмяТаблицы+"]";
	Конецесли;
	
	Возврат ТЗИзФайла;
КонецФункции 

Функция ВыгрузитьТаблицыХранилищаВФайлы()
	ИмяФайлаХранилища = КаталогХранилища + "\1cv8ddb.1CD";
	
	ФайлХранилища = Новый Файл(ИмяФайлаХранилища);
	Если НЕ ФайлХранилища.Существует() Тогда
		ТекстОшибки = "Ошибка! Не удалось найти файл ["+ИмяФайлаХранилища+"]";
		ВывестиСообщение(ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	// +++ Кажется, не обязательно обнулять переменную. Если не хотим ее хранить, то может и не создавать?
	// То есть сделать так Если Не (Новый Файл(ИмяФайлаХранилища)).Существует() Тогда
	ФайлХранилища = Неопределено; 
	
	пКаталогВременныхФайлов = КаталогВременныхФайлов();
	мИмяФайлаДляTool_1CD = пКаталогВременныхФайлов + "cTool_1CD.exe";	
	
	Макет_cTool_1CD = ПолучитьМакет("cTool_1CD");
	Макет_cTool_1CD.Записать(мИмяФайлаДляTool_1CD);
	
	ВывестиСообщение("Создали файл: " + мИмяФайлаДляTool_1CD);
	
	ТекстКоманды = СоздатьКоманду(мИмяФайлаДляTool_1CD);
	
	ИмяФайлаХранилища = Экранировать(ИмяФайлаХранилища);
	
	КаталогВыгрузкиФайлов = Лев(пКаталогВременныхФайлов,СтрДлина(пКаталогВременныхФайлов)-1);
	
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,,ИмяФайлаХранилища);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,"-ne");
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,"-ex",КаталогВыгрузкиФайлов);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды,"USERS,HISTORY,VERSIONS,OBJECTS");
	
	ВывестиСообщение("ТекстКоманды: " + ТекстКоманды);
	ВывестиСообщение("Выгрузка хранилища в файлы");
	КодВозврата = ВыполнитьКоманду(ТекстКоманды);
	Если КодВозврата <> 0 Тогда
		ОписаниеОшибки = "При выгрузке хранилища в файлы XML произошла ошибка";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;	
	
	ВывестиСообщение("Завершена выгрузка хранилища в файлы");
	
	УдалитьФайлы(мИмяФайлаДляTool_1CD);
	
	ВывестиСообщение("Удалили временный файл: " + мИмяФайлаДляTool_1CD);
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ИмяФайлаUSERS",КаталогВыгрузкиФайлов + "\USERS.xml");
	РезультатФункции.Вставить("ИмяФайлаHISTORY",КаталогВыгрузкиФайлов + "\HISTORY.xml");
	РезультатФункции.Вставить("ИмяФайлаVERSIONS",КаталогВыгрузкиФайлов + "\VERSIONS.xml");
	РезультатФункции.Вставить("ИмяФайлаOBJECTS",КаталогВыгрузкиФайлов + "\OBJECTS.xml");
	
	Возврат РезультатФункции;
КонецФункции

Функция СоздатьКоманду(Приложение)
	
	ТекстКоманды = """" + Приложение + """";
	Возврат ТекстКоманды;
	
КонецФункции

Функция ВыполнитьКоманду(ТекстКоманды)
	КодВозврата = Неопределено;
	ЗапуститьПриложение(ТекстКоманды,, Истина, КодВозврата);
	Возврат КодВозврата;
	
КонецФункции

Процедура ДобавитьВКомандуКлючЗначение(ТекстКоманды, Ключ, Значение = Неопределено)
	
	Если Значение = Неопределено Тогда
		ТекстКоманды = ТекстКоманды + " " + Ключ;
	Иначе	
		ТекстКоманды = ТекстКоманды + " " + Ключ + " """ + Экранировать(Значение) + """";
	КонецЕсли;
		
КонецПроцедуры

Функция Экранировать(Значение)
	
	Возврат СтрЗаменить(Значение, """", """""");	
	
КонецФункции

Процедура ВывестиСообщение(ТекстСообщения)
	// +++ Не нашел определение этой переменной
	Если НЕ ВыводитьОтладочныеСообщения Тогда
		Возврат;
	Конецесли;
	
	Сообщить("ОТЛАДКА "+ТекущаяДата() + ": "+ТекстСообщения);
КонецПроцедуры 

Процедура УдалитьВременныеФайлы(РезультатВыгрузки)
	Для каждого СтрокаРезультатВыгрузки из РезультатВыгрузки цикл
		ИмяФайла = СтрокаРезультатВыгрузки.Значение;
		УдалитьФайлы(ИмяФайла);		
		ВывестиСообщение("Удалили временный файл: " + ИмяФайла);
	Конеццикла;	
КонецПроцедуры 

мЭтоОтладка = Ложь; // +++ Удалить неиспользуемую переменную
мИмяКлассаОбъекта_Конфигурация = "Конфигурация";