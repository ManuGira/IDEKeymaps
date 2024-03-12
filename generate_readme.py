import enum
class TAGS(enum.IntEnum):
    KEYMAPS_ARRAY=enum.auto()


MODEL = f"""_(This readme has been generated with generate_readme.py)_
# IDEKeymaps
<<<{TAGS.KEYMAPS_ARRAY.name}>>>

## Import keymaps
#### PyCharm

1. File > Manage IDE Settings > Import Settings  
1. Select file ./PyCharm/pycharm_settings.zip  

#### VSCode

1. Open file ./out/keybindings_altitude.json and copy its content
1. File > Preferences > Keyboard shortcuts
1. Open Keyboard Shortcut as JSON by clicking on the ![](images/vscode_open_json.png) icon in top right corner
1. Paste the json content here


## Future Works
#### New actions:
* Extend selection (IntelliJ ctrl+w)
* Duplicate cursor to similar word (VSCode ctrl+w)
* Enter (on alt+m)
* backspace (on alt+n)

"""

def write(keymaps_array: str):
    with open("README.md", "w") as file:
        file.write(MODEL.replace(f"<<<{TAGS.KEYMAPS_ARRAY.name}>>>", keymaps_array))