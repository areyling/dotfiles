# dotfiles/powershell

PowerShell modules, scripts and my profile

## install

Still a work in progress. For now, `install.ps1` or `install.bat` can be run to install the profile and add the modules path. You can also specify which modules (or an empty array) to override the default using the -modules parameter.

## what's inside

My PowerShell profile, helper scripts and modules. See each sub-topic directory for more information.

The **profile** includes prompt customization based on [this blog post](http://winterdom.com/2008/08/mypowershellprompt) and [tomasr](https://github.com/tomasr)'s work. A few notes (see `profile.ps1` for the full detail):

- loads all *.ps1 scripts (excluding *.Tests.ps1) within the profile folder and its subdirectories
- automatically saves and restores at the start/end of each session
- replaces Get-ChildItem to list contents in a color-coded fashion similar to ls
- prompt shows user name, machine name, info and path (shortened like tabs in Vim)
- indicators show if running as admin

Example screenshot:

![custom prompt for PowerShell](https://raw.github.com/areyling/dotfiles/master/prompt.png)

## modules

The following modules are installed by default:

- **[PsGet](http://psget.net/)**: (always installed; used for searching/installing modules)
- **[Find-String](https://github.com/drmohundro/Find-String/)**: provides functionality similar to grep or ack with highlighting
- **[pscx](http://pscx.codeplex.com/)**: PowerShell Community Extensions
- **[posh-git](https://github.com/dahlbyk/posh-git)**: enhancements for working with git in PowerShell
- **[posh-npm](https://github.com/MSOpenTech/posh-npm)**: enhancements for working npm in PowerShell
- **[PsJson](https://github.com/chaliy/psjson)**: wrapper for the Daniel Crenna JSON library
- **[PsUrl](https://github.com/chaliy/psurl/)**: download stuff from the web; inspired by curl/wget

You can find available modules [here](http://psget.net/directory/) or search using PsGet itself from within PowerShell after having run the installer.