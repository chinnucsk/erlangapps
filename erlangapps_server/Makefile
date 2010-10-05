.PHONY: rel

all: compile

compile:
	./rebar compile

clean:
	./rebar clean

distclean: clean devclean relclean

test: 
	./rebar eunit

##
## Release targets
##
rel:
	./rebar compile generate 

relclean:
	rm -rf rel/erlangapps_server

##
## Developer targets
##
stagedevrel: dev1
	$(foreach dev,$^,\
	  rm -rf dev/$(dev)/lib/$(shell basename `pwd`)-* && ln -sf `pwd` dev/$(dev)/lib/;)

devrel: dev1 

dev1: compile
	mkdir -p dev
	(cd rel && ../rebar generate target_dir=../dev/$@ overlay_vars=vars/$@_vars.config)

devclean: clean
	rm -rf dev

##
## Doc targets
##
docs:
	@erl -noshell -run edoc_run application erlangapps_server '"apps/erlangapps_server"' '[]' 

dialyzer: compile
	@dialyzer -Wno_return -c ebin


