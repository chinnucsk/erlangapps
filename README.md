# Ideas as discussed on Skype #

* client should bootstrap the environment by creating a standard lib directory and store the path somewhere
* client should use the server to resolve the dependencies, then fetch those needed into the lib directory
* client should invoke rebar (or some other build tool) to build the dependencies once downloaded 

* Maintainer submits git/hg/* URLs to the server. Further metadata is pulled by server from the provided source.
* The list of URLs (and latest metadata) is stored in a git repo to ensure that the accumulated DB is accessible by other code/people.
* Server periodically polls the URLs for metadata and latest dependency data; this is used to construct the dependency tree.

# (Proposed) Client Usage #

* epps install APP
> This should install the latest version of the application and all its dependencies locally.

* epps search APP
> Search the application metadata-store for an application conforming to the given specification.

* epps uninstall APP
* Remove the given application from the local lib directory.
