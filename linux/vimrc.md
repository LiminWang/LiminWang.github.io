# vimrc相关

## How to install the Awesome version?
The awesome version includes a lot of great plugins, configurations and color schemes that make Vim a lot better. To install it simply do following from your terminal:

	git clone https://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_awesome_vimrc.sh

I also recommend using [the Hack font](http://sourcefoundry.org/hack/) (it's a free and awesome font designed for source code). The Awesome vimrc is already setup to try to use it.

## How to install the Basic version?
The basic version is just one file and no plugins. Just copy [basic.vim](https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim) and paste it into your vimrc.

The basic version is useful to install on remote servers where you don't need many plugins, and you don't do many edits.

	git clone git://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_basic_vimrc.sh

## 自己的配置记录
### 安装basic version
### 自动换行
: set tw=78 fo+=Mm 
也可以选择段落，按gq即可 

