[![CircleCI](https://circleci.com/gh/koshigoe/ftp_multipart_download/tree/master.svg?style=svg)](https://circleci.com/gh/koshigoe/ftp_multipart_download/tree/master)

# FtpMultipartDownload

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ftp_multipart_download'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ftp_multipart_download

## Usage

```ruby
$ bin/console
downloader = FtpMultipartDownload::Downloader.new('ftp.riken.go.jp', username: 'anonymous', debug_mode: true)
downloader.download('/Linux/centos/7/isos/x86_64/CentOS-7-x86_64-NetInstall-1804.iso')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Run FTP server for RSpec examples

The test cases depends:

- Host: `localhost`
- User: `user`
- Pass: `password`

e.g.

```
$ docker run -it --rm \
            -p 21:21 \
            -e FTP_USER=user -e FTP_PASS=password -e HOST=localhost \
            -p 65000-65004:65000-65004 \
            mcreations/ftp
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/koshigoe/ftp_multipart_download.
