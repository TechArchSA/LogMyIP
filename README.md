# Log My IP
A simple service to log consultant's IP address during engagements. 

The application contains 2 files:

* **logmyip.rb:** The core application
* **logmyipd.rb:** The daemon, which runs the core application as a service to avoid keep shell/cmd open all the time.

## Features 

* Runs as a daemon (support: start, stop, status command and Linux daemons)
* Support desktop notification

## Requirements 

```
gem install daemons libnotify
```



## Usage

**Run the service**

Notice the `--` used for `logmyip.rb` *mandatory* argument, which is the desired log directory path

```
ruby logmyipd.rb start -- /log/path/
```



**Check service status**

```
ruby logmyipd.rb status
```



**Stop the service**

```
ruby logmyipd.rb stop
```



## Changelog

* [Feature] Add run as a daemon 
* [Fix] Repeated IP in logs 
* [Feature] Adding desktop notification 
* [Fix] If a file path is given instead of directory path