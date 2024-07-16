Tutos-Replication-Master-Slave
Ce tuto nous montre comment faire la replication entre deux bases des données master slave et master master . nous allons commencé par master slave, pour ce faire il faut avoir deux instances bien créé depuis amazon ec2 linux 2 et le ssh avec mobaxterm .Ensuite, nous allons configurer la réplication entre le serveur maître et le serveur esclave en modifiant les fichiers de configuration MySQL et en redémarrant les instances. Suivez attentivement les étapes pour vous assurer que la réplication se déroule correctement et que les données sont synchronisées entre les deux bases de données.
Étapes pour l'installation de MariaDB sur les deux instances;
sudo yum install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
Secure MariaDB installation dans les deux serveurs;
sudo mysql_secure_installation
Ouvrez le fichier de configuration ;
sudo nano /etc/my.cnf.d/server.cnf
Vous devrez avoir cette configuration;
 
Ensuite rédemarer mariadb;
sudo systemctl restart mariadb
Ensuite créer un user et donner les privillèges;
CREATE USER 'replication_user'@'%' IDENTIFIED BY 'your_password';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
FLUSH PRIVILEGES;
NB: Remplace 'replication_user' par ton nom et 'your_password' par ton mot de passe choisi. Voici un exemple :
 
Ensuite, vérifiez le statut du master;
SHOW MASTER STATUS;
 
Arrêtez le serveur avant de configurer la réplication;
STOP SLAVE ;
Configurer la réplication avec la seconde instances;
CHANGE MASTER TO
   MASTER_HOST='second_instance_ip',
   MASTER_USER='repl',
   MASTER_PASSWORD='your_password',
   MASTER_LOG_FILE='second_master_log_file',
   MASTER_LOG_POS=second_master_log_pos;
NB: Pour la section MASTER_HOST : mettre l'adresse IP du maître, MASTER_USER : mettre le nom de l'utilisateur créé, MASTER_PASSWORD : mettre le mot de passe créé pour l'utilisateur, MASTER_PASSWORD : mettre le fichier journal et le MASTER_LOG_POS : mettre la position.
 
mysql-bin.000009 : MASTER_LOG_FILE
783: MASTER_LOG_POS
Ensuite, allumer le slave;
START SLAVE;
Pour vérifier si la réplication a fonctionné, il faut exécuter cette commande :
SHOW SLAVE STATUS\G;
 
Dans cette image, la connexion fonctionne. Veuillez prendre en compte le statut des sections que j'ai indiquées dans la photo. Si ce n'est pas le cas, cela signifie que votre réplication n'a pas fonctionné. Dans ce cas, ne paniquez pas, mais vérifiez plutôt si vous avez autorisé le port 3306 en entrant, puis réessayez.
Tutos-Replication-Master-master
Ici chaque opération est effectuée dans les deux instances car il s'agit de la réplication master-master.Cela signifie que les deux instances sont capables à la fois de lire et d'écrire des données, ce qui permet une meilleure disponibilité et une meilleure tolérance aux pannes. En cas de défaillance d'une instance, l'autre peut prendre le relais sans interruption de service. Cette architecture offre une grande flexibilité et une meilleure répartition de la charge, ce qui en fait un choix populaire pour les applications nécessitant une haute disponibilité et une grande capacité de traitement.
Étapes pour l'installation de MariaDB sur les deux serveurs :
sudo yum install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
Secure MariaDB installation dans les deux serveurs;
sudo mysql_secure_installation
Ouvrez le fichier de configuration ;
sudo nano /etc/my.cnf.d/server.cnf
Vous devrez avoir cette configuration;
 
Ensuite rédemarer mariadb;
sudo systemctl restart mariadb
Ensuite créer un user et donner les privillèges;
CREATE USER 'replication_user'@'%' IDENTIFIED BY 'your_password';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
FLUSH PRIVILEGES;
NB: Remplace 'replication_user' par ton nom et 'your_password' par ton mot de passe choisi. Voici un exemple :
 
Ensuite, vérifiez le statut du master;
SHOW MASTER STATUS;
 
Arrêtez le serveur avant de configurer la réplication;
STOP SLAVE ;
Configurer la réplication dans les deux instances;
CHANGE MASTER TO
   MASTER_HOST='second_instance_ip',
   MASTER_USER='repl',
   MASTER_PASSWORD='your_password',
   MASTER_LOG_FILE='second_master_log_file',
   MASTER_LOG_POS=second_master_log_pos;
NB: Pour la section MASTER_HOST : mettre l'adresse IP du maître, MASTER_USER : mettre le nom de l'utilisateur créé, MASTER_PASSWORD : mettre le mot de passe créé pour l'utilisateur, MASTER_PASSWORD : mettre le fichier journal et le MASTER_LOG_POS : mettre la position.
 
mysql-bin.000009 : MASTER_LOG_FILE
783: MASTER_LOG_POS
Ensuite, allumer le slave;
START SLAVE;
Pour vérifier si la réplication a fonctionné, il faut exécuter cette commande :
SHOW SLAVE STATUS\G;

