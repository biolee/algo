# create a java lib
[OSSRH Guide](http://central.sonatype.org/pages/ossrh-guide.html)
[Requirements](http://central.sonatype.org/pages/requirements.html) 
[Apache Maven](http://central.sonatype.org/pages/apache-maven.html)

# ubuntu gpu driver
```bash
# 查看显卡信息
lspci | grep -i vga 
lspci -v -s ${GPU_ADDR}

# 禁用nouveau
sudo vim /etc/modprobe.d/blacklist.conf

blacklist amd76x_edac 
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv


sudo apt-get remove --purge nvidia-*
sudo update-initramfs -u
sudo reboot -h now

sudo service lightdm stop

sudo ./NVIDIA-Linux-x86-260.19.44.run

sudo service lightdm start
```

# brew 
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# zsh
```bash
brew install zsh

chsh
/bin/zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ZSH_THEME="agnoster"
plugins=(git zsh-completions kubectl)

```

# ts import export
```typescript
import 'jquery';                        // import a module without any import bindings
import $ from 'jquery';                 // import the default export of a module
import { $ } from 'jquery';             // import a named export of a module
import { $ as jQuery } from 'jquery';   // import a named export to a different name
import * as crypto from 'crypto';       // import an entire module instance object

export var x = 42;                      // export a named variable
export function foo() {};               // export a named function

export default 42;                      // export the default export
export default function foo() {};       // export the default export as a function

export { encrypt };                     // export an existing variable
export { decrypt as dec };              // export a variable as a new name
export { encrypt as en } from 'crypto'; // export an export from another module
export * from 'crypto';                 // export all exports from another module
                                        // (except the default export)
```

# npm package.json

[doc](https://docs.npmjs.com/files/package.json)

- name
- version
- description
- keywords
- homepage
- bugs
- license
- files
- main
- bin
- man
- directories
	- directories.lib
	- directories.bin
	- directories.man
	- directories.doc
	- directories.example
	- directories.test
- repository
- scripts
- config
- dependencies
	- ```json
			{ "dependencies" :
			  { "foo" : "1.0.0 - 2.9999.9999"
			  , "bar" : ">=1.0.2 <2.1.2"
			  , "baz" : ">1.0.2 <=2.3.4"
			  , "boo" : "2.0.1"
			  , "qux" : "<1.0.0 || >=2.3.1 <2.4.5 || >=2.5.2 <3.0.0"
			  , "asd" : "http://asdf.com/asdf.tar.gz"
			  , "til" : "~1.2"
			  , "elf" : "~1.2.3"
			  , "two" : "2.x"
			  , "thr" : "3.3.x"
			  , "lat" : "latest"
			  , "dyl" : "file:../dyl"
			  }
			}
	  ```
	- tarball URL
	- <protocol>://[<user>[:<password>]@]<hostname>[:<port>][:][/]<path>[#<commit-ish> | #semver:<semver>]
		- git+ssh://git@github.com:npm/npm.git#v1.0.27
		- git+ssh://git@github.com:npm/npm#semver:^5.0
		- git+https://isaacs@github.com/npm/npm.git
		- git://github.com/npm/npm.git#v1.0.27	 

