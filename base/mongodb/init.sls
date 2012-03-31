mongodb:
    pkg:
        - name: mongodb-10gen
        - installed
    service:
        - running
        - require:
            - file: mongo-dirs
            - file: /usr/libexec/mongo/repset_init.js
            - file: /etc/mongodb.conf
            - file: /var/log/mongodb
    user:
      - present
      - uid: 70002
      - gid: 70002
      - require:
        - group: mongodb
    group:
      - present
      - gid: 70002

mongo-dirs:
  file:
    - directory
    - user: mongodb
    - group: mongodb
    - mode: 755
    - names:
      - /var/log/mongodb
      - /usr/libexec
      - /usr/libexec/mongo
    - require:
      - user: mongodb
      - group: mongodb

/etc/mongodb.conf:
  file:
    - managed
    - user: mongodb
    - group: mongodb
    - mode: 644
    - source: salt://mongodb/files/mongodb.conf
    - template: jinja
    - context:
        replSet: set_a
    - require:
      - pkg: mongodb

/usr/libexec/mongo/repset_init.js:
  file:
    - managed
    - source: salt://mongodb/files/repset_init.js
    - template: jinja
    - context:
        replSet: set_a
        repSetMember1: 172.16.42.11
        repSetMember2: 172.16.42.12
        repSetMember3: 172.16.42.13
    - require:
      - file: mongo-dirs

/usr/libexec/mongo/check_mongo_status.sh:
  file:
    - managed
    - source: salt://mongodb/files/check_mongo_status.sh
    - mode: 755
    - require:
      - file: mongo-dirs

# restart mongo to make sure it picks up the replicaSet flag, otherwise can't
# configure
restart mongodb:
  cmd:
    - run
    - user: root
    - group: root
    - require:
        - service: mongodb

mongo --quiet /usr/libexec/mongo/repset_init.js:
  cmd:
    - run
    - unless: /usr/libexec/mongo/check_mongo_status.sh
    - user: root
    - group: root
    - require:
      - service: mongodb
      - file: /usr/libexec/mongo/check_mongo_status.sh

virtualenv:
    pkg:
        - name: python-virtualenv
        - installed

/var/venv/mongo:
    virtualenv:
        - manage
        - name: /var/venv/mongo
        - requirements: salt://mongodb/requirements.txt

