# Пример проведения код-ревью

## Результат

## Исходные данные

- Решение - <https://github.com/vpozdnyakov/1CYandexDiskExchange>
- Автор - <https://github.com/vpozdnyakov>

## Процесс работы

1. В репозитории есть обработка **ОбменЯндексДиск**
2. Начинаем с [Формы](https://github.com/vpozdnyakov/1CYandexDiskExchange/blob/master/YandexDiskExchangeXML/DataProcessors/ОбменЯндексДиск/Forms/Форма/Ext/Form/Module.bsl)
3. Копируем файл формы в [Отдельный файл](src/form_raw.bsl)
4. Скормим файл нейросети, чтобы она написала какие-то замечания.
Результат в [файле](src/form_review_by_khoj.md)
5. Начинаем ревью кода в [Файле](src/form_review.bsl)
6. Переходим к модулю объекта [Файл](src/ObjectModule_raw.bsl)
7. Скормим файл нейросети. Результат в файле - 
