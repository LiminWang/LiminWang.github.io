# Mac高效工作配置

## Table of Content
1 [常用工具](#1-常用工具)
   - [Homebrew](#homebrew)
   - [Homebrew Cask](#homebrew-cask)
   - [iTerm2](#iterm2)
   - [Oh My Zsh](#oh-my-zsh)
   - [Git 常用别名](#git-常用别名)
   - [CheatSheet](#cheatsheet)
   - [VirtualBox](#virtualbox)


## 1. 常用工具

### [Homebrew](http://brew.sh)

包管理工具，官方称之为`The missing package manager for OS X`。

安装步骤见官网。

有了 brew 以后，要下载工具，比如 MySQL、Gradle、Maven、Node.js 等工具，就不需要去网上下载了，只要一行命令就能搞定：

```sh
brew install mysql gradle maven node
```

PS：安装 brew 的时候会自动下载和安装 Apple 的 Command Line Tools。

brew 的替代品有 [MacPorts](https://www.macports.org/)，现在基本没人用它。

### [Homebrew Cask](https://caskroom.github.io)

brew-cask 允许你使用命令行安装 OS X 应用。比如你可以这样安装 Chrome：`brew cask install google-chrome`。还有 Evernote、Skype、Sublime Text、VirtualBox 等都可以用 brew-cask 安装。

brew-cask 是社区驱动的，如果你发现 brew-cask 上的应用不是最新版本，或者缺少你某个应用，你可以自己提交 pull request。

安装步骤见官网。

应用也可以通过 App Store 安装，而且有些应用只能通过 App Store 安装，比如 Xcode 等一些 Apple 的应用。App Store 没有对应的命令行工具，还需要 Apple ID。倒是更新起来很方便。

几乎所有常用的应用都可以通过 brew-cask 安装，而且是从应用的官网上下载，所以你要安装新的应用时，建议用 brew-cask 安装。如果你不知道应用在 brew-cask 中的 ID，可以先用`brew cask search`命令搜索。

### [iTerm2](https://www.iterm2.com/)

iTerm2 是最常用的终端应用，是 Terminal 应用的替代品。提供了诸如`Split Panes`等[一群实用特性](https://www.iterm2.com/features.html)。它默认的黑色背景让我毫不犹豫的抛弃了 Terminal。

安装：

```sh
brew cask install iterm2
```

感谢 brew-cask，我们可以通过命令行自动安装 iTerm2 了。

在终端里，除了可以用`⌃E`等快捷键（详见[其他快捷键](#其他快捷键)）之外，还可以使用`⌥B`、`⌥F`等快捷键（具体可以参考[这里](http://ss64.com/bash/syntax-keyboard.html)）。前提是这样设置一下：

选择`Iterm`菜单 > `Preferences` > `Profiles`，选择你在使用的 Profile（默认是`Default`），在`Keys`标签页中把`Left option (⌥) key acts as`和`Right option (⌥) key acts as`都设置成`+ESC`。

在打开新的窗口/标签页的时候，默认情况下新窗口总是 HOME 目录，还需要我每次敲命令才能进入工作目录。如果想要这个新窗口在打开的时候就自动进入工作目录，需要如下设置：

选择`Iterm`菜单 > `Preferences` > `Profiles`，选择你在使用的 Profile（默认是Default），在`General`标签页中的`Working Directory`部分中选择`Reuse previous seesion's directory`。

至此，Terminal 应用已经出色的完成了其历史使命。后面命令行就交给 iTerm2 啦。

在 iTerm2 中双击会自动选中对应的词，三击会选中对应的整行。选中的内容会自动进入剪贴板，不需要再按`⌘C`复制。

### [Oh My Zsh](http://ohmyz.sh)

默认的 Bash 是黑白的，没有色彩。而 Oh My Zsh 可以带你进入彩色时代。Oh My Zsh 同时提供一套插件和工具，可以简化命令行操作。后面我们会看到很多介绍，你会看到我爱死这家伙了。

安装方法见官网。

目前我使用的插件有：`git z sublime history rbenv bundler rake`

Oh My Zsh 使用了 Z shell（zsh），一个和 Bash 相似的 Shell，而非 Bash。

在 Z shell 中，`~/.zshrc`是最重要的配置文件。Oh My Zsh 在安装的时候会把当前环境的`$PATH`写入`~/.zshrc`中。这并不是我期望的行为，因为使用了 brew，我们基本不再需要去定制`$PATH`，而 Oh My Zsh 提供的默认`$PATH`值`$HOME/bin:/usr/local/bin:$PATH`是非常合适的一个值，它把`$HOME/bin`加入了`$PATH`，可以让我们把自己用的脚本放到`$HOME/bin`下。

所以建议把`~/.zshrc`重置：

```sh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```
Oh My Zsh 还有很多[有价值的插件](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview)。

### Git 常用别名

几乎每个人都会使用一些方法比如 Git 别名来提高效率，几乎所有人都会把使用`git st`来代替`git status`。然而这需要手动设置，每个人也都不完全一样。

Oh My Zsh 提供了一套系统别名（alias），来达到相同的功能。比如`gst`作为`git status`的别名。而且 Git 插件是 Oh My Zsh 默认启用的，相当于你使用了 Oh My Zsh，你就拥有了一套高效率的别名，而且还是全球通用的。是不是棒棒哒？下面是一些我常用的别名：

Alias | Command
----- | -------
gapa  | `git add --patch`
gc!   | `git commit -v --amend`
gcl   | `git clone --recursive`
gclean| `git reset --hard && git clean -dfx`
gcm   | `git checkout master`
gcmsg | `git commit -m`
gco   | `git checkout`
gd    | `git diff`
gdca  | `git diff --cached`
glola | `git log --graph --pretty = format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all`
gp    | `git push`
grbc  | `git rebase --continue`
gst   | `git status`
gup   | `git pull --rebase`
gwip  | `git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--"`


完整列表请参考：<https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git>


### z

在打开终端后，你是怎么进入项目的工作目录？是`cd xxx`，`⌃R`还是用别名？

[z](https://github.com/rupa/z) 工具可以帮你快速进入目录。比如在我的 Mac 上运行`z cask`就会进入`/usr/local/Library/Taps/caskroom/homebrew-cask/Casks`目录。

这货的安装非常方便，甚至都不需要下载任何东西，因为它已经整合在了 Oh My Zsh 中。编辑`~/.zshrc`文件，在`plugins=(git)`这行中加上`z`变成`plugins=(git z)`，然后运行`source ~/.zshrc`重新加载配置文件，就可以使用 z 了。

替代品有 autojump。autojump 需要使用 brew 安装。

### [CheatSheet](http://www.mediaatelier.com/CheatSheet/)

CheatSheet 能够显示当前程序的快捷键列表，默认的快捷键是长按`⌘`。

```sh
$ brew cask install cheatsheet
```

### VirtualBox

VirtualBox是一款开源的虚拟化工具，用户可以通过它在新窗口中运行多种电脑操作系统，功能类似与vmWare Fusion和Parallels应用程序。

```bash
$ brew cask install virtualbox
```

