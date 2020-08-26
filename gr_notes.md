## Tuesday 2020-08-25

Went through licenses for Cortex and approved the OSI ones I recognized.

## Monday 2020-08-24

#### Metropolis
* Metropolis doesn't scan at the top level because it's a monorepo and needs --recursive
* Running recursive blows up for pip2 / python2.7 problems in the container:
```
root@1b78781a6879:/scan# license_finder --recursive -p
LicenseFinder::Pip: is active
LicenseFinder::Conda: is active
pip2 install: did not succeed.
pip2 install: DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
Invalid requirement: '"--editable=git+https://github.com/ConsultingMD/pygrounds.git@ebcb0e65e452079a21b7f5929072102da8ae050b#egg=pygrounds"'
It looks like a path. File '"--editable=git+https://github.com/ConsultingMD/pygrounds.git@ebcb0e65e452079a21b7f5929072102da8ae050b#egg=pygrounds"' does not exist.
You are using pip version 19.0.2, however version 20.2.2 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.

Traceback (most recent call last):
	14: from /usr/share/rvm/gems/ruby-2.7.1/bin/license_finder:23:in `<main>'
	13: from /usr/share/rvm/gems/ruby-2.7.1/bin/license_finder:23:in `load'
	12: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/bin/license_finder:6:in `<top (required)>'
	11: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor/base.rb:485:in `start'
	10: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor.rb:392:in `dispatch'
	 9: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor/invocation.rb:127:in `invoke_command'
	 8: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor/command.rb:27:in `run'
	 7: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/cli/main.rb:110:in `action_items'
	 6: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/license_aggregator.rb:15:in `any_packages?'
	 5: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/license_aggregator.rb:15:in `map'
	 4: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/license_aggregator.rb:16:in `block in any_packages?'
	 3: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/core.rb:62:in `prepare_projects'
	 2: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/core.rb:62:in `each'
	 1: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.8.1/lib/license_finder/core.rb:64:in `block in prepare_projects'
/usr/share/rvm/gems/ruby-2.7.
```
## Wednesday 2020-08-12

* Completed the reporting & scan for bobs / potluck. 4 components flagged, 3 bugs filed (one for 2 comps).
* Need to rescan banyan & jarvis b/c js licenses that should be approved aren't.

## Tuesday 2020-08-11

* Wrote maven\_dependencies.yml -> xml.pom filter, worked well enough on the
  `potluck` repo. Also ran on `bobs`.

## Friday 2020-08-07

* LicenseFinder repro repo (disaster, don't know enough to) *done*
* Try LF in a FHIR repo
* Try a Conda -> Pip hack

## Thursday 2020-08-06

Hiroshima Day.  No big bombs here yet. No victory, either.
* LicenseFinder -> see issue https://github.com/pivotal/LicenseFinder/issues/772 .
  I think the answer is to use the Gem in the .circle-ci workflow to avoid version
  differences with the measured system.  Since I've filed the issue, however,
  I should create a repro repo for the LF team to test with.
* POA: Specifically call out the NOTIFY workflow and how `licensed` is native
  for it, vs. we would need enhancements for LF.
* `licensed`: Need to followup on the issue filed there, too, for good
  citizenship. I suspect it's caused by LF wanting to rebundle in its own
  bundle path.

## Thursday 2020-07-30

Focused on embedding `license_finder` again, after writing PRD/POA yesterday.
Successfully embedded in `black`, with modern LF and .circle-ci calling to the
inherited dependency file.

* Slow: `check_licenses` takes ~3:30 where the `build_tng` is only 1:30 (probably because of layer caching, really)
* Does not solve the inventory problem.

## Tuesday  2020-07-28

Extended the `gr_license` hack for Jarvis to clean up the problem with
`composer`: one module has invalid author properties.

Not sure the best way to handle .git user & token.  I think we are
doing OK as long as we run this stuff locally on workstations (since
then it gets my creds), but we did have an npm error trying to run with
`license_finder -p` in Jarvis.  To get around, could:

* Volume mount creds
* Require ENV arguments to the Dockerfile, *and* figure out how to use
  them in .npmrc & .git config, and modify `dlf` to pass them in (and
  require them before running).

When we get to running this thing in the repos (which looks harder every
day), gotta solve that arg stuff.

## Monday 2020-07-27

Extending Friday's results slightly, updating `sidekiq-unique-jobs` did not
resolve the conflict; the latest compatible version (6.0.20) still requires
thor ~> 0.

Based on that, I'm going to enhance the LF container until
it can work in the rest of the Rails repos.

I'd *rather* be pushing on the "in-repo" tester, but because of the
`thor` incompatibility, I think that will take more time than completing
the scans using the solution we made work last time.

To get to "in-repo" testing, we should evaluate other tools first. See
the FRID-205(?) epic description for what I think we want.

Updating `gr_license` to have special Jarvis handling. Seems to be missing
most of the javascript stuff without using --recursive. With --recursive,
I get:

```
Traceback (most recent call last):
	22: from /usr/share/rvm/gems/ruby-2.7.1/bin/license_finder:23:in `<main>'
	21: from /usr/share/rvm/gems/ruby-2.7.1/bin/license_finder:23:in `load'
	20: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/bin/license_finder:6:in `<top (required)>'
	19: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor/base.rb:485:in `start'
	18: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor.rb:392:in `dispatch'
	17: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor/invocation.rb:127:in `invoke_command'
	16: from /usr/share/rvm/gems/ruby-2.7.1/gems/thor-1.0.1/lib/thor/command.rb:27:in `run'
	15: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/cli/main.rb:151:in `report'
	14: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/license_aggregator.rb:11:in `dependencies'
	13: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/license_aggregator.rb:49:in `aggregate_packages'
	12: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/license_aggregator.rb:49:in `flat_map'
	11: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/license_aggregator.rb:49:in `each'
	10: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/license_aggregator.rb:51:in `block in aggregate_packages'
	 9: from /usr/share/rvm/rubies/ruby-2.7.1/lib/ruby/2.7.0/forwardable.rb:229:in `acknowledged'
	 8: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/core.rb:78:in `decision_applier'
	 7: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/core.rb:83:in `current_packages'
	 6: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/scanner.rb:36:in `active_packages'
	 5: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/scanner.rb:36:in `flat_map'
	 4: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/scanner.rb:36:in `each'
	 3: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/package_manager.rb:101:in `current_packages_with_relations'
	 2: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/package_managers/composer.rb:14:in `current_packages'
	 1: from /usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/package_managers/composer.rb:48:in `dependency_list'
/usr/share/rvm/gems/ruby-2.7.1/gems/license_finder-6.6.2/lib/license_finder/package_managers/composer.rb:54:in `composer_json': Command 'composer licenses --format=json' failed to execute:  (RuntimeError)

  [Composer\\Json\\JsonValidationException]
  "./composer.json" does not match the expected JSON schema:
   - authors[0] : The property web is not defined and the definition does not allow additional properties

```

## Friday 2020-07-24

Tim:
* With modern LicenseFinder and a pre-bundled tree, was able to get  a run with dlf. OTOH, not --prepare.

Jarvis:
* Tried `apt-get ruby-license-manager`, but trying to run in Jarvis ran into a complaint about `go`.
* Trying to run license manager as a gem installed within the Jarvis repo...
  * Older runs had left cruft in .bundle/config; rm'ed.
  * Upgraded to Arrow 0.17 to get a sensible build on my workstation.
  * Worked as long as I'd prebundled.  `-p` fails.
  * It installed 6.0.0, which is the last version that ran on Thor
    pre-1.0. OTOH, that doesn't support inherited decision files, so doesn't
    solve our use case. And later versions of thor cause sidekiq-unique-jobs
    to mismatch. Trying to upgrade sidekiq-unique-jobs, but it smells bad
    for our older repos.



