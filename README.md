
#  Дипломная работа по профессии «Системный администратор» - Дубинин Денис

<details> 
   
Содержание
==========
* [Задача](#Задача)
* [Инфраструктура](#Инфраструктура)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
    * [Резервное копирование](#Резервное-копирование)
    * [Дополнительно](#Дополнительно)
* [Выполнение работы](#Выполнение-работы)
* [Критерии сдачи](#Критерии-сдачи)
* [Как правильно задавать вопросы дипломному руководителю](#Как-правильно-задавать-вопросы-дипломному-руководителю) 

---------

## Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/) и отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. Используйте [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#get-credentials).

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

## Инфраструктура
Для развёртки инфраструктуры используйте Terraform и Ansible.  

Не используйте для ansible inventory ip-адреса! Вместо этого используйте fqdn имена виртуальных машин в зоне ".ru-central1.internal". Пример: example.ru-central1.internal  

Важно: используйте по-возможности **минимальные конфигурации ВМ**:2 ядра 20% Intel ice lake, 2-4Гб памяти, 10hdd, прерываемая. 

**Так как прерываемая ВМ проработает не больше 24ч, перед сдачей работы на проверку дипломному руководителю сделайте ваши ВМ постоянно работающими.**

Ознакомьтесь со всеми пунктами из этой секции, не беритесь сразу выполнять задание, не дочитав до конца. Пункты взаимосвязаны и могут влиять друг на друга.

### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.

Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.

Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

Протестируйте сайт
`curl -v <публичный IP балансера>:80` 

### Мониторинг
Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix. 

Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

### Сеть
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Настройте все security groups на разрешение входящего ssh из этой security group. Эта вм будет реализовывать концепцию bastion host. Потом можно будет подключаться по ssh ко всем хостам через этот хост.

### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

### Дополнительно
Не входит в минимальные требования. 

1. Для Zabbix можно реализовать разделение компонент - frontend, server, database. Frontend отдельной ВМ поместите в публичную подсеть, назначте публичный IP. Server поместите в приватную подсеть, настройте security group на разрешение трафика между frontend и server. Для Database используйте [Yandex Managed Service for PostgreSQL](https://cloud.yandex.com/en-ru/services/managed-postgresql). Разверните кластер из двух нод с автоматическим failover.
2. Вместо конкретных ВМ, которые входят в target group, можно создать [Instance Group](https://cloud.yandex.com/en/docs/compute/concepts/instance-groups/), для которой настройте следующие правила автоматического горизонтального масштабирования: минимальное количество ВМ на зону — 1, максимальный размер группы — 3.
3. В Elasticsearch добавьте мониторинг логов самого себя, Kibana, Zabbix, через filebeat. Можно использовать logstash тоже.
4. Воспользуйтесь Yandex Certificate Manager, выпустите сертификат для сайта, если есть доменное имя. Перенастройте работу балансера на HTTPS, при этом нацелен он будет на HTTP веб-серверов.

## Выполнение работы
На этом этапе вы непосредственно выполняете работу. При этом вы можете консультироваться с руководителем по поводу вопросов, требующих уточнения.

⚠️ В случае недоступности ресурсов Elastic для скачивания рекомендуется разворачивать сервисы с помощью docker контейнеров, основанных на официальных образах.

**Важно**: Ещё можно задавать вопросы по поводу того, как реализовать ту или иную функциональность. И руководитель определяет, правильно вы её реализовали или нет. Любые вопросы, которые не освещены в этом документе, стоит уточнять у руководителя. Если его требования и указания расходятся с указанными в этом документе, то приоритетны требования и указания руководителя.

## Критерии сдачи
1. Инфраструктура отвечает минимальным требованиям, описанным в [Задаче](#Задача).
2. Предоставлен доступ ко всем ресурсам, у которых предполагается веб-страница (сайт, Kibana, Zabbix).
3. Для ресурсов, к которым предоставить доступ проблематично, предоставлены скриншоты, команды, stdout, stderr, подтверждающие работу ресурса.
4. Работа оформлена в отдельном репозитории в GitHub или в [Google Docs](https://docs.google.com/), разрешён доступ по ссылке. 
5. Код размещён в репозитории в GitHub.
6. Работа оформлена так, чтобы были понятны ваши решения и компромиссы. 
7. Если использованы дополнительные репозитории, доступ к ним открыт. 

## Как правильно задавать вопросы дипломному руководителю
Что поможет решить большинство частых проблем:
1. Попробовать найти ответ сначала самостоятельно в интернете или в материалах курса и только после этого спрашивать у дипломного руководителя. Навык поиска ответов пригодится вам в профессиональной деятельности.
2. Если вопросов больше одного, присылайте их в виде нумерованного списка. Так дипломному руководителю будет проще отвечать на каждый из них.
3. При необходимости прикрепите к вопросу скриншоты и стрелочкой покажите, где не получается. Программу для этого можно скачать [здесь](https://app.prntscr.com/ru/).

Что может стать источником проблем:
1. Вопросы вида «Ничего не работает. Не запускается. Всё сломалось». Дипломный руководитель не сможет ответить на такой вопрос без дополнительных уточнений. Цените своё время и время других.
2. Откладывание выполнения дипломной работы на последний момент.
3. Ожидание моментального ответа на свой вопрос. Дипломные руководители — работающие инженеры, которые занимаются, кроме преподавания, своими проектами. Их время ограничено, поэтому постарайтесь задавать правильные вопросы, чтобы получать быстрые ответы :)

</details>

# Пояснение выполнения работы

(Файлы terraform и ansible, а также отдельно подготовленные файлы настроек и index прикреплены к репозиторию)


-----
1. Используя terraform, я подключился к провайдеру YndexCloude, поднял сеть, подсети, группы безопасности, определил output, поднял 6 ВМ: server1, server2, zabbix-server, elastic, kibana, bastion-host.

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/output.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/vm.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/subnet.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/security-group.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/network-map.png)

</details>

----
2. Подключившись к bastion-host запускаю ansible. 
С помощью ansible устанавливается nginx на server1 и server2, копируются заранее подготовленные сраницы index (на кажный сервер свою). 
Устанавливается zabbix-agent на все ВМ кроме bastion, в файлы настройки /etc/zabbix/zabbix_agentd.conf прописывается DNS имя zabbix-server. 
Роль zabbix устанавливает на ВМ "zabbix-server" postgres, zabbix-server и его компоненты, создаются пользователь БД и сама БД.
Роль elastic устанавливает на ВМ "elastic" elasticsearch, копируется заранее подготовленный файл настройки /etc/elasticsearch/elasticsearch.yml.
Роль kibana устанавливает на ВМ "kibana" собственно kibana, копируется заранее подготовленный файл настройки /etc/kibana/kibana.yml.
Роль filebeat, устанавливает на ВМ "server1" и "server2" filebeat, копирует заранее подготовленный файл настройки /etc/filebeat/filebeat.yml на обе машины.

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/ansible-ping.png)

</details>

----
3. Как автоматизировать поднятие балансировщика я разобраться не смог, по этому балансировщек настроен через консоль управления YandexCloud. Работа балансировщика проверена запросом `curl -v 158.160.137.182:80` и в браузере, обращением по внешнему адресу балансировщика  http://158.160.137.182/

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/target-group.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/backend-group.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/http-router.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/balanser.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/balanser-curl.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/balanser1.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/balanser2.png)

</details>

----
4. Для насройки zabbix-servera подключаюсь к нему через web-интерфейс http://158.160.136.57/zabbix (логин и пароль стандартные). Подключаю хосты для мониторинга, настраиваю dashboards.

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/zabbix1.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/zabbix2.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/zabbix3.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/zabbix4.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/zabbix5.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/zabbix6.png)

</details>

----
5. Проверяю доступность и работу elastic запросом curl elastic.ru-central1.internal:9200/_cluster/health?pretty

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/elastic.png)

</details>

----
6. Подключаюсь к web консоли kibana http://158.160.128.159:5601/ и подключаю filebeat.

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/kibana1.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/kibana2.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/kibana3.png)

</details>

----
7. Через консоль YandexCloud создаю планировщик резервного копирования и добавляю в него диски созданных ВМ.

<details>
   
![image](https://github.com/DubininDenis/diplom/screens/blob/main/snapshot.png)

</details>

----
9. Через консоль YandexCloud создаю группу безопасности для балансировщика и вношу изменения в группу безопасности web-серверов

<details>

![image](https://github.com/DubininDenis/diplom/screens/blob/main/security-group-balanser.png)

![image](https://github.com/DubininDenis/diplom/screens/blob/main/security-group-webservers.png)

</details>


-----
Если я правильно уяснил задание, то минимальные требования по задаче я выполнил.
