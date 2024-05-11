# 1CodeReviewExample
Пример проведения код-ревью для 1С-ных проектов

Вот здесь было видео о том как мы проводим код-ревью - https://www.youtube.com/watch?v=BMAgiz2uEHA
А здесь хочу показать на практике как проводится код-ревью.
Удобнее было бы сделать Видео, но попробуем в формате статьи.

**Исходные данные:**
1. Случайная обработка с ГитХаб - https://github.com/BlizD/HistoryStorage/blob/master/src/cf/DataProcessors/узПросмотрИсторииХранилища/Ext/ObjectModule.bsl
Искал с помощью - OpenYellow 
2. VSCode с плагином 1C (bsl) и SonarQube
3. База со стандартами 1С - https://its.1c.ru/db/v8std

**Начало:**
1. Для начала давайте скормим наш модуль объекта SonarQube, чтобы отсеять часть замечаний.
2. 