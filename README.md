portage
=======

My Gentoo portage overlay, with mainline fixes and custom ebuilds.

Simply paste the following to `/etc/portage/repos.conf/hhoffstaette.conf`:

```
location = /var/db/repos/hhoffstaette
sync-type = git
sync-uri = https://github.com/hhoffstaette/portage.git
```
If you don't want to update the repository on every `emerge --sync` simply add

```
auto-sync = no
```
