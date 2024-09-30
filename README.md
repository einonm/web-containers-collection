# Basic containers for a multi-site proxied host

A set of docker containers used to provide web infrastructure

## Installation and usage

A linux host capabile of runing docker is required.

Requires: Docker (Docker version 26.1.3 used), Docker-compose (docker-compose-plugin-2.27.0-1 used).

To start a service, in any container stack directory (e.g. mediawiki/monitoring/portainer/nginx-proxy), run:

 `$ docker compose up -d`

### Docker container stacks

This repository contains several container stacks that work together to provide a containerised version of some web infrastructure. The stack directories are:

#### nginx-proxy

* https://github.com/jwilder/docker-letsencrypt-nginx-proxy-companion

This is a reverse proxy and Let's Encrypt companion. It enables multiple containerised services/sites to be hosted on the same host, where the proxy directs traffic to the relevant service depending on the
incoming address/IP. Optionally, the LE companion requests an SSL cert for sites that require one.

To enable, allow a container/stack to access the `proxy-net` docker network (this may have to be created if not already existing with `$ docker create network proxy-net`), and in the container's compose.yml, set an environment variable of `VIRTUAL_HOST`, e.g. `VIRTUAL_HOST="site.example.com"` to direct site.example.com traffic to that host to an exported port. An additional `VIRTUAL_PORT` can be declared if nginx-proxy fails to autodetect the correct port. Optionally, a `LETSENCRYPT_HOST` can be defined for the same host address that allows the LE companion to attempt to gain an LE SSL cert for that domain.

The script nginx-proxy/setup_local_network.sh is used to apply a set of macvlans to a network device (currently set up for eno1 on the local host - change this to match yours). A macvlan is a virtual network device assigned to, in this case, a physical NIC - allowing the NIC to have multiple MAC addresses and hence multiple IPs assigned. The IP/MAC combinations can be assigned by local DHCP/DNS configurations.

#### mediawiki

* https://hub.docker.com/_/mediawiki/#!
* https://mariadb.com/kb/en/container-backup-and-restoration/

This hosts a mediawiki instance with backend mariadb database, configured according to the provided `LocalSettings.php` file.

Note: Backup cron tasks must be entered manually on the container host currently, e.g.:

```
@daily /root/wikibackup.sh > /dev/null
0 3 * * 0-5 cp -a /backup/wiki/* /backup/server-backups/wiki.example.com > /dev/null
```

##### Updaing from a legacy wiki backup

* The databaser schema must be updated, and a jump from 1.31 to 1.40 is no possible in one go, so first we must update to 1.35, then to 1.40. So edit the `compose.yml` file line (7):
        `image: mediawiki:1.40.1`
  to read:
        `image: mediawiki:1.35.1`

* Run the container as usual - `$ docker compose up -d`
* Place a recent backup to the directory `./mediawiki/backups/`, creating the backups directory if needed. e.g. `scp root@wiki:/backup/wiki/wikibackup-05-22-2024.tgz ./mediawiki/backups/`
* Restore the backup - `cd mediawiki; sudo ./backup-scripts/restore-wiki-latest.sh`
* Restore the committed LocalSettings.php (as overwritten by backup) - `git checkout LocalSettings.php`
* Install the 1.35 vector skin (REL1_35 in git clone from skins/README)
* Connect to the mediawiki container - `$ docker exec -it mediawiki-mediawiki-1 bash`
    * In the container terminal, run the update script, e.g. - `# ./maintenance/update.php`
* Confirm that the wiki is serving pages (using version 1.35.1)
* Stop the containers - `$ docker compose down`
* Install the 1.40 vector skin (REL1_40 in git clone from skins/README)
* Edit `compose.yml` line 7 back to `image: mediawiki:1.40.1`. Run the containers again - `$ docker compose up -d`
* Connect to the mediawiki container again - `$ docker exec -it mediawiki-mediawiki-1 bash`
    * In the container terminal, run the (new version of the) update script, e.g. - `# php ./maintenance/run ./maintenance/update.php`
* The updated wiki should now be running on mediawiki version 1.40.1. Continue to schedule backups as usual.


#### portainer

* https://github.com/portainer/portainer

Portainer is a lightweight web GUI used to visualise and manage docker / kubernetes environments.

#### monitoring

This container stack provides redis, cAdvisor, prometheus and grafana containers to monitor the host's container environment, currently with only grafana being proxied.

#### devops1

Uses the contents of a static website devops1.example.com to provide a static nginx-hosted site

#### devops2

Uses the contents of a static + bokeh website devops2.example.com to provide a static nginx-hosted site with bokeh app

## Contributing
Contributing issues, feature proposals or code is actively welcomed - please see the [CONTRIBUTING.md](CONTRIBUTING.md) file for more details.

## Code of Conduct
We want to create a welcoming environment for everyone who is interested in contributing. Please see the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md) file to learn more about our commitment to an open and welcoming environment.

## Copyright and Licence Information

Copyright Mark Einon
For licensing information, see the [LICENSE file](LICENSE).

