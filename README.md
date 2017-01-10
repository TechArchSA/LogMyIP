# LogMyIP
A simple service to log consultant IP during engagements 

## Requirements 

```
gem install daemons
```



## Usage

**Run the service**

Notice the `--` used for `logmyip.rb` argument, which is the desired log directory path

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

