include:
    - mongodb

extend:
    - /etc/mongod.conf:
        file:
            - context:
                replSet: set_a

extend:
    - /usr/libexec/mongo/repset_init.js:
        file:
            - context:
                replSet: set_a
                repSetMember1: minion01.example.com
                repSetMember2: minion02.example.com
                repSetMember3: minion03.example.com
