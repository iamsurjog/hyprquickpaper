# HyprQuickPaper

Wallpaper selector made using quickshell. Inspired by : [ilyamiro's dots](https://github.com/ilyamiro/nixos-configuration)
PRs and contributions are appreciated.

> [!IMPORTANT]
> Make sure to read the entire config and usage section before using

## Demo

https://github.com/user-attachments/assets/375e3696-e62d-48bf-8af6-18d2be86b224


## Dependencies

- [quickshell](https://git.outfoxxed.me/quickshell/quickshell)

## Installation

### Arch

Get Quickshell with yay (or your AUR helper of choice)

```bash
yay -S quickshell
```

Now just clone this repo into Quickshell's config folder

```bash
git clone https://github.com/iamsurjog/hyprquickpaper ~/.config/quickshell/hyprquickpaper
```

## config

go to the `config.json` file and change the `"wallpaper_path"` and the `"cache_path"` variables

> [!IMPORTANT]
> Make sure to use absolute path (/home/...) for the path and put the trailing "/" at the end of the path

Example config.json
```{json}
{
    "wallpaper_path": "/home/<usrname>/Pictures/Wallpapers/",
    "cache_path": "/home/<usrname>/.cache/quickshell/thumbs/",
    "number_of_pictures": 7,
    "border_color": "#A98881"
}
```

Also add your wallpaper changing commands to the `commands.sh` file. Selecting a wallpaper runs the command with the path to the wallpaper passed as a parameter. An example on how to use it with swww is given.

```{bash}
swww img $1 -t grow --transition-duration 1
```

## Usage

Now you're ready to launch HyprQuickPaper from your terminal, or add it to your Hyprland config.

```bash
quickshell -c hyprquickpaper
```

Add this line to your `hyprland.conf` to bind HyprQuickPaper to Super + W.

```hypr
bind = $mainMod, w, exec, quickshell -c hyprquickshot
```

On using it for the first time it will not load anything. Press escape and then restart it and it should load the wallpapers.

### Keybinds:

- J/K to scroll to 1 left/right respectively
- D/U to scroll 1 screen worth left/right respectively
- Esc to quit out
- Space/Enter(or return) to select wallpaper
- Scrolling/click and dragging also works for scrolling
- Clicking also allows selection of a wallpaper


## Issues/TODOS

- [ ] Missing the trailing "/" in the paths in config.json breaks it
- [ ] Show a "Caching... " text when caching
- [ ] Initial caching takes up lot of resources
- [ ] Pressing J/K after using mouse to scroll takes a long time to scroll back
