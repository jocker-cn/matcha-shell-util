# The Matcha Project

Matcha is a script scheduling tool written in Ruby that also provides some built-in functionality to simplify common
operations on Linux systems.

# Environment Require

This project is compatible only with environments running centos/redhat7+ and ruby version 3.0 or
higher.

| system        | version |
|---------------|---------|
| centos/redhat | 7/8/9   |
| ruby          | 3.0.0+  |



# Install matcha


```shell
version=v1.0.0 && 
curl -JLO https://github.com/jocker-cn/matcha-shell-util/releases/download/${version}/Installer && bash Installer
```


# Feature

View the supported features of the current version.

```shell
[root@localhost matcha]# matcha support all
[12:27:21][matcha][root] args: ["support", "all"] 
 Support:
      MODEL_NAME: schedule[sc]
      MODEL_DESC: scheduling module for commands and scripts [ssh]
             USE: u can use `matcha support sc` see the details

      MODEL_NAME: ssh
      MODEL_DESC: complete the SSH mutual trust work of the specified nodes in batches
             USE: u can use `matcha support ssh` see the details
``` 


# About issue
Please provide the server environment, execute script commands, and error messages
[issue](https://github.com/jocker-cn/matcha-shell-util/issues)

Example: issue commit

```
environment: centos-stream9
script: matcha ssh args
error messages: error message
```