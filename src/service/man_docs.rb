# frozen_string_literal: true


ALL_MAN="Support:
      MODEL_NAME: schedule[sc]
      MODEL_DESC: scheduling module for commands and scripts [ssh]
             USE: u can use `matcha support sc` see the details

      MODEL_NAME: ssh
      MODEL_DESC: complete the SSH mutual trust work of the specified nodes in batches
             USE: u can use `matcha support ssh` see the details "


SCHEDULE_MAN="Support:
MODEL_NAME:         schedule
MODEL_DESCRIPTION:  Used for scheduling jobs for commands or executable scripts.
                    This operation schedules the content of your command or script on the specified machine and executes it.
                    The IP address and username of the target machine must be specified during scheduling, and the target username@ip
                    must have completed SSH interconnection with the current machine.This operation supports two
                    execution modes: command-line and YAML file.
             use:   matcha sc [args]

             args:  -c  (Optional: One of -c, -e must exist)
                        Specify the command that needs to be scheduled for execution.
                        Example: -c 'touch /tmp/sc'
                    -s  Specify the IP address(es) of the target machine(s) (can be multiple, separated by ',',
                        but the username and password for multiple machines must be the same).
                        Example: -s 127.0.0.1,127.0.0.2
                    -e  (Optional: One of -c, -e must exist)
                        Specify the executable file (can be an absolute path or a relative path from the current location).
                        Example: -e '../test.sh'
                    -u  Specify the username of the target machine.
                        Example: -u root
                    -p  Specify the password of the target machine user.
                        Example: -p 123456
                    -f  Specify the YAML file (use matcha yaml sc to get the configurable content of the YAML file).
                        The contents of the YAML file can be mixed with command-line parameters.
                        Example: -f sc.yaml.

             example: matcha sc -c 'touch /tmp/sc' -u root -p root -s 192.168.111.10,192.168.111.11,192.168.111.12"


SSH_MAN="Support:
MODEL_NAME:         ssh
MODEL_DESCRIPTION:  Establishes SSH key exchange between specified machines.
                    This operation first generates a key on the local machine using ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N '' -q.
                    Then, it uses `ssh-copy-id` to establish SSH key exchange between the specified machines and the target machine.
             use:   matcha ssh [args]

             args:  -i  (optional)
                        Specifies the IP address of the initiating machine (optional, defaults to the current user on the local machine).
                        Example: -i 127.0.0.1 / -i 111.11.111.11
                    -s  Specifies the IP addresses of the target machines (can be multiple, separated by commas, but the user and password for multiple machines must be the same).
                        Example: -s 127.0.0.1,127.0.0.2
                    -u  Specifies the username of the target machine.
                        Example: -u root
                    -p  Specifies the password of the target machine.
                        Example: -p 123456
                    -f  (optional)
                        Specifies a YAML file (to see the configurable content of the YAML file, use `matcha yaml ssh`). The contents of the YAML file can be mixed with command line arguments.

             example: matcha ssh -s 192.168.112.1,192.168.112.2,192.168.112.3 -u test -p 123456"