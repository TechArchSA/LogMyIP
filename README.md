# Log My IP
A simple service to log consultant IP during engagements. 

The application contains 2 files:

* **logmyip.rb:** The core application
* **logmyipd.rb:** The daemon, which runs the core application as a service to avoid keep shell/cmd open all the time.

## Requirements 

```
gem install daemons
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

