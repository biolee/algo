# work flow

## code and data

- all code store in ${WORKSPACE}
- ${WORKSPACE} layout
```
${WORKSPACE}
	bin/
	    runable.bin                    # command executable
	    todo                           # command executable
	pkg/
	src/
	    github.com/biolee/
	        algo/                      # one project
	            .git/                  # git repository metadata
	            hooks/                 # git hooks
	            bin/
	            conf/
	        PockemongMaster            # another project
	    gitlab.com/biolee/
	        JeffDb                     # another project on another VCS
```
- all data store in ${DATA_PATH}
- ${DATA_PATH} layout
```
${DATA_PATH}
	mysql/
		data/                          # mysql data files 
		conf/                          # mysql conf.d
	prome/
		conf/
			prometheus.yml             # promethus conf yml
```
- `source ${REPO_PATH_ALGO}/configs/bashrc` on target machine
