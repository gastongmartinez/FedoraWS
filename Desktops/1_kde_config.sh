#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

if [ -z "$DISPLAY" ];
then
    echo -e "Debe ejecutarse dentro del entorno grafico.\n"
    echo "Saliendo..."
    exit 2
fi

############################################################################################################################################
# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
# unzip JetBrainsMono.zip -d ~/.local/share/fonts
# fc-cache -f -v
# rm JetBrainsMono.zip

############################################# Tema WhiteSur #################################################################################
git clone https://github.com/vinceliuice/WhiteSur-kde.git
cd WhiteSur-kde || return
./install.sh
cd ..

# git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
# cd WhiteSur-gtk-theme || return
# ./tweaks.sh -f
# cd ..

# git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
# cd WhiteSur-icon-theme || return
# ./install.sh -t grey
# cd ..
# 
# git clone https://github.com/vinceliuice/WhiteSur-cursors.git
# cd WhiteSur-cursors || return
# ./install.sh
# cd ..

rm -rf WhiteSur-kde
# rm -rf WhiteSur-icon-theme
# rm -rf WhiteSur-cursors
#############################################################################################################################################

# Autostart Apps
# if [ ! -d ~/.config/autostart ]; then
#     mkdir -p ~/.config/autostart
# fi
# cp /usr/share/applications/ulauncher.desktop ~/.config/autostart/

# Tema Ulauncher
# mkdir -p ~/.config/ulauncher/user-themes
# git clone https://github.com/Raayib/WhiteSur-Dark-ulauncher.git ~/.config/ulauncher/user-themes/WhiteSur-Dark-ulauncher


############################################## Config ##################################################################################
plasma-apply-desktoptheme WhiteSur-dark
plasma-apply-cursortheme WhiteSur-cursors
plasma-apply-wallpaperimage "/usr/share/backgrounds/wallpapers/Landscapes/landscapes 01.jpg"

# KVantum
kwriteconfig5 --file "$HOME"/.config/Kvantum/kvantum.kvconfig --group General --key theme "WhiteSurDark"

# KDEdefaults
kwriteconfig5 --file "$HOME"/.config/kdedefaults/kcminputrc --group Mouse --key cursorTheme "WhiteSur-cursors"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/kdeglobals --group General --key ColorScheme "WhiteSurDark"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/kdeglobals --group Icons --key Theme "WhiteSur-dark"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/kscreenlockerrc --group Greeter --key Theme "com.github.vinceliuice.WhiteSur-dark"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/ksplashrc --group KSplash --key Theme "com.github.vinceliuice.WhiteSur-dark"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/kwinrc --group org.kde.kdecoration2 --key library "org.kde.kwin.aurorae"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/kwinrc --group org.kde.kdecoration2 --key theme "__aurorae__svg__WhiteSur-dark"
kwriteconfig5 --file "$HOME"/.config/kdedefaults/plasmarc --group Theme --key name "WhiteSur-dark"

# General
kwriteconfig5 --file "$HOME"/.config/ksplashrc --group KSplash --key Theme "org.fedoraproject.fedora.desktop"
kwriteconfig5 --file "$HOME"/.config/plasmarc --group Wallpapers --key usersWallpapers "/usr/share/backgrounds/wallpapers/Landscapes/landscapes 01.jpg"
kwriteconfig5 --file "$HOME"/.config/kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "/usr/share/backgrounds/wallpapers/Landscapes/landscapes 01.jpg"
kwriteconfig5 --file "$HOME"/.config/kwinrc --group TabBox --key LayoutName "com.github.vinceliuice.WhiteSur-dark"
kwriteconfig5 --file "$HOME"/.config/powermanagementprofilesrc --group AC --group DPMSControl --key idleTime "1200"

# KDEglobals
{
    echo '[$Version]'
    echo 'update_info=filepicker.upd:filepicker-remove-old-previews-entry,fonts_global.upd:Fonts_Global,fonts_global_toolbar.upd:Fonts_Global_Toolbar,icons_remove_effects.upd:IconsRemoveEffects,kwin.>'
    echo -e '\n[ColorEffects:Disabled]'
    echo 'ChangeSelectionColor='
    echo 'Color=56,56,56'
    echo 'ColorAmount=0'
    echo 'ColorEffect=0'
    echo 'ContrastAmount=0.65'
    echo 'ContrastEffect=1'
    echo 'Enable='
    echo 'IntensityAmount=0.1'
    echo 'IntensityEffect=2'
    echo -e '\n[ColorEffects:Inactive]'
    echo 'ChangeSelectionColor=true'
    echo 'Color=112,111,110'
    echo 'ColorAmount=0.025'
    echo 'ColorEffect=2'
    echo 'ContrastAmount=0.1'
    echo 'ContrastEffect=2'
    echo 'Enable=false'
    echo 'IntensityAmount=0'
    echo 'IntensityEffect=0'
    echo -e '\n[Colors:Button]'
    echo 'BackgroundAlternate=77,77,77'
    echo 'BackgroundNormal=101,101,101'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=61,174,233'
    echo 'ForegroundInactive=189,195,199'
    echo 'ForegroundLink=41,128,185'
    echo 'ForegroundNegative=218,68,83'
    echo 'ForegroundNeutral=246,116,0'
    echo 'ForegroundNormal=252,252,252'
    echo 'ForegroundPositive=39,174,96'
    echo 'ForegroundVisited=127,140,141'
    echo -e '\n[Colors:Complementary]'
    echo 'BackgroundAlternate=66,66,66'
    echo 'BackgroundNormal=51,51,51'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=246,116,0'
    echo 'ForegroundInactive=160,160,160'
    echo 'ForegroundLink=49,91,239'
    echo 'ForegroundNegative=237,21,21'
    echo 'ForegroundNeutral=201,206,59'
    echo 'ForegroundNormal=252,252,252'
    echo 'ForegroundPositive=17,209,22'
    echo 'ForegroundVisited=49,91,239'
    echo -e '\n[Colors:Header]'
    echo 'BackgroundAlternate=66,66,66'
    echo 'BackgroundNormal=54,54,54'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=246,116,0'
    echo 'ForegroundInactive=160,160,160'
    echo 'ForegroundLink=49,91,239'
    echo 'ForegroundNegative=237,21,21'
    echo 'ForegroundNeutral=201,206,59'
    echo 'ForegroundNormal=252,252,252'
    echo 'ForegroundPositive=17,209,22'
    echo 'ForegroundVisited=49,91,239'
    echo -e '\n[Colors:Header][Inactive]'
    echo 'BackgroundAlternate=66,66,66'
    echo 'BackgroundNormal=51,51,51'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=246,116,0,150'
    echo 'ForegroundInactive=160,160,160,150'
    echo 'ForegroundLink=49,91,239'
    echo 'ForegroundNegative=237,21,21'
    echo 'ForegroundNeutral=201,206,59'
    echo 'ForegroundNormal=252,252,252,150'
    echo 'ForegroundPositive=17,209,22'
    echo 'ForegroundVisited=49,91,239'
    echo -e '\n[Colors:Selection]'
    echo 'BackgroundAlternate=79,127,239'
    echo 'BackgroundNormal=49,91,239'
    echo 'DecorationFocus=255,255,255'
    echo 'DecorationHover=255,255,255'
    echo 'ForegroundActive=252,252,252'
    echo 'ForegroundInactive=130,156,239'
    echo 'ForegroundLink=253,188,75'
    echo 'ForegroundNegative=218,68,83'
    echo 'ForegroundNeutral=246,116,0'
    echo 'ForegroundNormal=255,255,255'
    echo 'ForegroundPositive=39,174,96'
    echo 'ForegroundVisited=128,152,239'
    echo -e '\n[Colors:Tooltip]'
    echo 'BackgroundAlternate=77,77,77'
    echo 'BackgroundNormal=51,51,51'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=49,91,239'
    echo 'ForegroundInactive=189,195,199'
    echo 'ForegroundLink=49,91,239'
    echo 'ForegroundNegative=218,68,83'
    echo 'ForegroundNeutral=246,116,0'
    echo 'ForegroundNormal=252,252,252'
    echo 'ForegroundPositive=39,174,96'
    echo 'ForegroundVisited=127,140,141'
    echo -e '\n[Colors:View]'
    echo 'BackgroundAlternate=48,48,48'
    echo 'BackgroundNormal=36,36,36'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=49,91,239'
    echo 'ForegroundInactive=160,160,160'
    echo 'ForegroundLink=49,91,239'
    echo 'ForegroundNegative=218,68,83'
    echo 'ForegroundNeutral=246,116,0'
    echo 'ForegroundNormal=252,252,252'
    echo 'ForegroundPositive=39,174,96'
    echo 'ForegroundVisited=120,120,120'
    echo -e '\n[Colors:Window]'
    echo 'BackgroundAlternate=66,66,66'
    echo 'BackgroundNormal=54,54,54'
    echo 'DecorationFocus=49,91,239'
    echo 'DecorationHover=49,91,239'
    echo 'ForegroundActive=49,91,239'
    echo 'ForegroundInactive=160,160,160'
    echo 'ForegroundLink=49,91,239'
    echo 'ForegroundNegative=218,68,83'
    echo 'ForegroundNeutral=246,116,0'
    echo 'ForegroundNormal=252,252,252'
    echo 'ForegroundPositive=39,174,96'
    echo 'ForegroundVisited=120,120,120'
    echo -e '\n[General]'
    echo 'ColorSchemeHash=79296561e8832ef612d7c1138272b1e03e6ba66d'
    echo 'XftHintStyle=hintslight'
    echo 'XftSubPixel=rgb'
    echo 'fixed=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0'
    echo 'font=Noto Sans,11,-1,5,50,0,0,0,0,0'
    echo 'menuFont=Noto Sans,11,-1,5,50,0,0,0,0,0'
    echo 'toolBarFont=Noto Sans,11,-1,5,50,0,0,0,0,0'
    echo -e '\n[Icons]'
    echo 'Theme=WhiteSur-grey-dark'
    echo -e '\n[KDE]'
    echo 'LookAndFeelPackage=com.github.vinceliuice.WhiteSur-dark'
    echo 'widgetStyle=kvantum-dark'
    echo -e '\n[KFileDialog Settings]'
    echo 'Allow Expansion=false'
    echo 'Automatically select filename extension=true'
    echo 'Breadcrumb Navigation=true'
    echo 'Decoration position=2'
    echo 'LocationCombo Completionmode=5'
    echo 'PathCombo Completionmode=5'
    echo 'Show Bookmarks=false'
    echo 'Show Full Path=false'
    echo 'Show Inline Previews=true'
    echo 'Show Preview=false'
    echo 'Show Speedbar=true'
    echo 'Show hidden files=false'
    echo 'Sort by=Name'
    echo 'Sort directories first=true'
    echo 'Sort reversed=false'
    echo 'Speedbar Width=145'
    echo 'View Style=DetailTree'
    echo -e '\n[WM]'
    echo 'activeBackground=51,51,51'
    echo 'activeBlend=171,171,171'
    echo 'activeFont=Noto Sans,11,-1,5,50,0,0,0,0,0'
    echo 'activeForeground=252,252,252'
    echo 'inactiveBackground=66,66,66'
    echo 'inactiveBlend=85,85,85'
    echo 'inactiveForeground=170,170,170'
} > "$HOME"/.config/kdeglobals

# {
#     echo '@define-color borders_breeze #686868;'
#     echo '@define-color content_view_bg_breeze #242424;'
#     echo '@define-color error_color_backdrop_breeze #da4453;'
#     echo '@define-color error_color_breeze #da4453;'
#     echo '@define-color error_color_insensitive_backdrop_breeze #5f2d32;'
#     echo '@define-color error_color_insensitive_breeze #5f2d32;'
#     echo '@define-color insensitive_base_color_breeze #222222;'
#     echo '@define-color insensitive_base_fg_color_breeze #6a6a6a;'
#     echo '@define-color insensitive_bg_color_breeze #333333;'
#     echo '@define-color insensitive_borders_breeze #444444;'
#     echo '@define-color insensitive_fg_color_breeze #767676;'
#     echo '@define-color insensitive_selected_bg_color_breeze #333333;'
#     echo '@define-color insensitive_selected_fg_color_breeze #767676;'
#     echo '@define-color insensitive_unfocused_bg_color_breeze #333333;'
#     echo '@define-color insensitive_unfocused_fg_color_breeze #767676;'
#     echo '@define-color insensitive_unfocused_selected_bg_color_breeze #333333;'
#     echo '@define-color insensitive_unfocused_selected_fg_color_breeze #767676;'
#     echo '@define-color link_color_breeze #315bef;'
#     echo '@define-color link_visited_color_breeze #787878;'
#     echo '@define-color success_color_backdrop_breeze #27ae60;'
#     echo '@define-color success_color_breeze #27ae60;'
#     echo '@define-color success_color_insensitive_backdrop_breeze #235036;'
#     echo '@define-color success_color_insensitive_breeze #235036;'
#     echo '@define-color theme_base_color_breeze #242424;'
#     echo '@define-color theme_bg_color_breeze #363636;'
#     echo '@define-color theme_button_background_backdrop_breeze #656565;'
#     echo '@define-color theme_button_background_backdrop_insensitive_breeze #606060;'
#     echo '@define-color theme_button_background_insensitive_breeze #606060;'
#     echo '@define-color theme_button_background_normal_breeze #656565;'
#     echo '@define-color theme_button_decoration_focus_backdrop_breeze #315bef;'
#     echo '@define-color theme_button_decoration_focus_backdrop_insensitive_breeze #4f5d8e;'
#     echo '@define-color theme_button_decoration_focus_breeze #315bef;'
#     echo '@define-color theme_button_decoration_focus_insensitive_breeze #4f5d8e;'
#     echo '@define-color theme_button_decoration_hover_backdrop_breeze #315bef;'
#     echo '@define-color theme_button_decoration_hover_backdrop_insensitive_breeze #4f5d8e;'
#     echo '@define-color theme_button_decoration_hover_breeze #315bef;'
#     echo '@define-color theme_button_decoration_hover_insensitive_breeze #4f5d8e;'
#     echo '@define-color theme_button_foreground_active_backdrop_breeze #fcfcfc;'
#     echo '@define-color theme_button_foreground_active_backdrop_insensitive_breeze #767676;'
#     echo '@define-color theme_button_foreground_active_breeze #ffffff;'
#     echo '@define-color theme_button_foreground_active_insensitive_breeze #767676;'
#     echo '@define-color theme_button_foreground_backdrop_breeze #fcfcfc;'
#     echo '@define-color theme_button_foreground_backdrop_insensitive_breeze #939393;'
#     echo '@define-color theme_button_foreground_insensitive_breeze #939393;'
#     echo '@define-color theme_button_foreground_normal_breeze #fcfcfc;'
#     echo '@define-color theme_fg_color_breeze #fcfcfc;'
#     echo '@define-color theme_hovering_selected_bg_color_breeze #ffffff;'
#     echo '@define-color theme_selected_bg_color_breeze #315bef;'
#     echo '@define-color theme_selected_fg_color_breeze #ffffff;'
#     echo '@define-color theme_text_color_breeze #fcfcfc;'
#     echo '@define-color theme_titlebar_background_backdrop_breeze #424242;'
#     echo '@define-color theme_titlebar_background_breeze #333333;'
#     echo '@define-color theme_titlebar_background_light_breeze #363636;'
#     echo '@define-color theme_titlebar_foreground_backdrop_breeze #aaaaaa;'
#     echo '@define-color theme_titlebar_foreground_breeze #fcfcfc;'
#     echo '@define-color theme_titlebar_foreground_insensitive_backdrop_breeze #aaaaaa;'
#     echo '@define-color theme_titlebar_foreground_insensitive_breeze #aaaaaa;'
#     echo '@define-color theme_unfocused_base_color_breeze #242424;'
#     echo '@define-color theme_unfocused_bg_color_breeze #363636;'
#     echo '@define-color theme_unfocused_fg_color_breeze #fcfcfc;'
#     echo '@define-color theme_unfocused_selected_bg_color_alt_breeze #263c88;'
#     echo '@define-color theme_unfocused_selected_bg_color_breeze #263c88;'
#     echo '@define-color theme_unfocused_selected_fg_color_breeze #fcfcfc;'
#     echo '@define-color theme_unfocused_text_color_breeze #fcfcfc;'
#     echo '@define-color theme_unfocused_view_bg_color_breeze #222222;'
#     echo '@define-color theme_unfocused_view_text_color_breeze #6a6a6a;'
#     echo '@define-color theme_view_active_decoration_color_breeze #315bef;'
#     echo '@define-color theme_view_hover_decoration_color_breeze #315bef;'
#     echo '@define-color tooltip_background_breeze #333333;'
#     echo '@define-color tooltip_border_breeze #656565;'
#     echo '@define-color tooltip_text_breeze #fcfcfc;'
#     echo '@define-color unfocused_borders_breeze #686868;'
#     echo '@define-color unfocused_insensitive_borders_breeze #444444;'
#     echo '@define-color warning_color_backdrop_breeze #f67400;'
#     echo '@define-color warning_color_breeze #f67400;'
#     echo '@define-color warning_color_insensitive_backdrop_breeze #683d16;'
#     echo '@define-color warning_color_insensitive_breeze #683d16;'
# } > "$HOME"/.config/gtk-3.0/colors.css

sed -i "s/gtk-icon-theme-name=breeze-dark/gtk-icon-theme-name=WhiteSur-grey-dark/g" "$HOME/.config/gtk-3.0/settings.ini"
sed -i "s/gtk-font-name=Noto Sans,  10/gtk-font-name=Noto Sans,  11/g" "$HOME/.config/gtk-3.0/settings.ini"
sed -i "s/gtk-icon-theme-name=breeze-dark/gtk-icon-theme-name=WhiteSur-grey-dark/g" "$HOME/.config/gtk-4.0/settings.ini"
sed -i "s/gtk-font-name=Noto Sans,  10/gtk-font-name=Noto Sans,  11/g" "$HOME/.config/gtk-4.0/settings.ini"
sed -i "s/org.kde.breezedark.desktop/com.github.vinceliuice.WhiteSur-dark/g" "$HOME/.config/kdedefaults/package"
# sed -i "s/\"theme-name\": \"light\"/\"theme-name\": \"WhiteSur-Dark\"/g" "$HOME/.config/ulauncher/settings.json"
sed -i "s/Net\/IconThemeName \"breeze-dark\"/Net\/IconThemeName \"WhiteSur-grey-dark\"/g" "$HOME/.config/xsettingsd/xsettingsd.conf"
sed -i "s/Gtk\/FontName \"Noto Sans,  10\"/Gtk\/FontName \"Noto Sans,  11\"/g" "$HOME/.config/xsettingsd/xsettingsd.conf"
#############################################################################################################################################

sleep 2

reboot