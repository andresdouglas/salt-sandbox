apt:
  pkg:
    - latest

dselect:
  pkg:
    - latest

apt-update:                                                                                                                                                                       
  cmd:                                                                                                                                                                            
    - wait                                                                                                                                                                         
    - name: /usr/bin/apt-get update   
