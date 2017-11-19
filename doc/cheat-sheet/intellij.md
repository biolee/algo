profile: Mac OS X
- no tab
- must plugin
	- acejump
	- go
	- python
	- protobuf
	- nodejs
	- rust
	- live edit

# General

- Project Structure: cmd+;
- Setting: cmd+,
- intention actions: alt+return
- find action: cmd+shift+a
- Searching Everywhere: shift shift
- create: ctl+n


# edit
- 自动补全
	- ctl+space
	- ctl+shift+space
	- shift+cmd+return

- line
	- split line
		- cmd+return
	- new line
		- shift+return
	- duplicate 
		- cmd+d
	- delete 
		- cmd+y
		
- Reformat code
	- reformat
		- cmd+alt+l
	- indent
		- cmd+alt+i
	- Optimize imports
		- cmd+alt+o
- Indent/unindent selected lines
	- tab 
	- shift+tab
	
# View Doc

- Quick Definition
	- shift+cmd+i
- Quick Doc Lookup
	- ctl+j
- Viewing External Doc
	- shift+f1
- Parameter Info
	- cmd+p

## navigation

- file/tool
	- Ctrl+Tab
	- command+e
	- cmd+shift+e
	- Navigation Bar
    	- alt+home
    - goto to line
    	- cmd+G
- Test
	- cmd+Shift+T
- Code block
	- navigate to the borders of cb
		- cmd+[
		- cmd+]
	- select cb
		- shift+cmd+[
		- shift+cmd+]
	- expand select
		- cmd+w
		- shift+cmd+w
	- Expand/collapse
		- cmd++
		- cmd+shift++
		- cmd+shift+-
- tool window
	- cmd+n activate n tool window when dist window not activate
	- cmd+n hide tool window when dist window activate
	- f12 goto last tool window 
	- shift+esc hide active/last tool window
	- esc hide tool window when tool window activate
	- 
	- 1 dir
	- 2 bp bookmark
	- 3 find
	- 4 run
	- 5 debug
	- 8 Hierarchy
	- 9 version ctl
	- 
	- terminal: alt+f12
- Navigating by name
	- Class
		- cmd+N
	- File (directory)
		- cmd+shift+N
	- Symbol
		- cmd+shift+alt+n

- Next/Previous
	- view
		- cmd+alt+left
        - cmd+alt+right
	- windows
		- alt+cmd+[
		- alt+cmd+]
	- Change
		- shift+ctl+alt+up
        - shift+ctl+alt+down
        - cmd+shift+delete
    - Error
        - f2
        - shift+f2
    - method
    	- ctl+Up
    	- ctl+Down

- 层级
	- 文件对象结构
		- cmd+7
		- cmd+f12
	- 类结构
		- ctl+h
	- 方法层级
		- cmd+shift+h
	- 调用层级
		- ctl+alt+h
	- Navigating to Super Method or Implementation
		- ![](https://www.jetbrains.com/help/img/idea/2017.2/gutterIconImplements.gif) 点击得到此方法实现了那些接口
		- ![](https://www.jetbrains.com/help/img/idea/2017.2/gutterIconImplemented.gif) 点击获得那些class实现了此方法
		- ![](https://www.jetbrains.com/help/img/idea/2017.2/gutterIconOverriding.png) override
		- ![](https://www.jetbrains.com/help/img/idea/2017.2/gutterIconOverridden.gif)
		- Super Method
			- cmd+u
		- Implementation
			- cmd+alt+b
- Search/Replace
	- 文件内搜索
		- cmd+f
		- 搜索光标处symbol
			- cmd+f3
		- next 
			- f3
		- previous 
			- shift+f3
		- 文件内Replace
			- cmd+r
	- 文件夹内搜索
		- 先选中文件夹，如果没有选中，默认为整个项目
		- shift+ctl+f
		- shift+ctl+r
- Finding Usages and declaration
	- cmd+b
	- shift+ctl+b
	- 项目内
		- alt+f7
		- cmd+b
	- 文件内
		- cmd+f7
	- Highlighting Usages
		- cmd+shift+f7
- Bookmarks
	- Show
		- shift+f11
	- toggle with mnemonics
		- cmd+f11
	- Toggling
		- f11
	- ctl+n goto n bookmark
	
## Run Debug Test

- 一般
	- run -> f10
	- debug -> f9
- 选择RUN/Debug的config
	- shift+alt+f10
	- shift+alt+f9
- 运行/debug选中的config
	- shift+f10
	- shift+f9
- 运行/debug光标所在的main
	- shift+ctl+f10
	- shift+ctl+f9
- in run tab(cmd+4)
	- re-run
		- ctl+f5
	- stop
		- cmd+f2
	- close
		- cmd+shift+f4
- in debug tab(cmd+5)
	- re-run
        - ctl+f5
	- toogle break point(bp)
		- cmd+f8
	- view bp
		- shift+cmd+f8
	- resume
		- f9
	- current execution point
		- alt+f10
	- step over
		- f8
	- step into
		- f7
	- run to cursor
		- alt+f9
	- stop
		- f2
	- close
		- cmd+f4

- recently performed tests
	- shift+cmd+;

## Refactoring

- rename
	- shift+f6
- move
	- f6
- copy
	- f5
- Refactor This
	- shift+alt+cmd+t

## custom shortcut
- open project shift+ctl+cmd+o
- reopen project shift+ctl+cmd+r
- presentation shift+ctl+cmd+p
- extraction free shift+ctl+cmd+e
- spite vertical shift+ctl+cmd+v
