# Ideas as discussed on Skype #

* client should bootstrap the environment by creating a standard lib directory and store the path somewhere
* client should use the server to resolve the dependencies, then fetch those needed into the lib directory
* client should invoke rebar (or some other build tool) to build the dependencies once downloaded 

# (Proposed) Client Usage #

* epps install APP
> This should install the latest version of the application and all its dependencies locally.

* epps search APP
> Search the application metadata-store for an application conforming to the given specification.

* epps uninstall APP
* Remove the given application from the local lib directory.
