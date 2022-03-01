import xml.etree.ElementTree as et
import enum
import json


class Action(enum.IntEnum):
    LEFT = enum.auto()
    CTRL_LEFT = enum.auto()
    SHIFT_LEFT = enum.auto()
    CTRL_SHIFT_LEFT = enum.auto()
    RIGHT = enum.auto()
    CTRL_RIGHT = enum.auto()
    SHIFT_RIGHT = enum.auto()
    CTRL_SHIFT_RIGHT = enum.auto()
    UP = enum.auto()
    SHIFT_UP = enum.auto()
    DOWN = enum.auto()
    SHIFT_DOWN = enum.auto()
    HOME = enum.auto()
    SHIFT_HOME = enum.auto()
    END = enum.auto()
    SHIFT_END = enum.auto()
    BACKSPACE = enum.auto()
    SHIFT_BACKSPACE = enum.auto()
    DELETE = enum.auto()
    SHIFT_DELETE = enum.auto()
    DUPLICATE_LINE = enum.auto()
    DELETE_LINE = enum.auto()
    ENTER = enum.auto()
    COMMENT = enum.auto()
    EDIT_NEXT_MATCH = enum.auto()
    EDIT_PREV_MATCH = enum.auto()

commands_visualstudio = {
    Action.LEFT            : "Edit.CharLeft",
    Action.CTRL_LEFT       : "Edit.CharLeftExtend",
    Action.SHIFT_LEFT      : "Edit.WordPrevious",
    Action.CTRL_SHIFT_LEFT : "Edit.WordPreviousExtend",
    Action.RIGHT           : "Edit.CharRight",
    Action.CTRL_RIGHT      : "Edit.CharRightExtend",
    Action.SHIFT_RIGHT     : "Edit.WordNext",
    Action.CTRL_SHIFT_RIGHT: "Edit.WordNextExtend",
    Action.UP              : "Edit.LineUp",
    Action.SHIFT_UP        : "Edit.LineUpExtend",
    Action.DOWN            : "Edit.LineDown",
    Action.SHIFT_DOWN      : "Edit.LineDownExtend",
    Action.HOME            : "Edit.LineStart",
    Action.SHIFT_HOME      : "Edit.LineStartExtend",
    Action.END             : "Edit.LineEnd",
    Action.SHIFT_END       : "Edit.LineEndExtend",
    Action.BACKSPACE       : "Edit.DeleteBackwards",
    Action.SHIFT_BACKSPACE : "Edit.WordDeleteToStart",
    Action.DELETE          : "Edit.Delete",
    Action.SHIFT_DELETE    : "Edit.WordDeleteToEnd",
    Action.DUPLICATE_LINE  : None,
    Action.DELETE_LINE     : "Edit.LineDelete",
    Action.ENTER           : "Edit.BreakLine",
    Action.COMMENT         : "ReSharper.ReSharper_LineComment",
    Action.EDIT_NEXT_MATCH : None,
    Action.EDIT_PREV_MATCH : None,
}

commands_vscode = {
    Action.LEFT            : {'command': 'cursorLeft', 'when': 'textInputFocus'},
    Action.CTRL_LEFT       : {'command': 'cursorWordLeft', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.SHIFT_LEFT      : {'command': 'cursorLeftSelect', 'when': 'textInputFocus'},
    Action.CTRL_SHIFT_LEFT : {'command': 'cursorWordLeftSelect', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.RIGHT           : {'command': 'cursorRight', 'when': 'textInputFocus'},
    Action.CTRL_RIGHT      : {'command': 'cursorWordRight', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.SHIFT_RIGHT     : {'command': 'cursorRightSelect', 'when': 'textInputFocus'},
    Action.CTRL_SHIFT_RIGHT: {'command': 'cursorWordRightSelect', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.UP              : {'command': 'cursorUp', 'when': 'textInputFocus'},
    Action.SHIFT_UP        : {'command': 'cursorUpSelect', 'when': 'textInputFocus'},
    Action.DOWN            : {'command': 'cursorDown', 'when': 'textInputFocus'},
    Action.SHIFT_DOWN      : {'command': 'cursorDownSelect', 'when': 'textInputFocus'},
    Action.HOME            : {'command': 'cursorHome', 'when': 'textInputFocus'},
    Action.SHIFT_HOME      : {'command': 'cursorHomeSelect', 'when': 'textInputFocus'},
    Action.END             : {'command': 'cursorEnd', 'when': 'textInputFocus'},
    Action.SHIFT_END       : {'command': 'cursorEndSelect', 'when': 'textInputFocus'},
    Action.BACKSPACE       : {'command': 'deleteLeft', 'when': 'textInputFocus'},
    Action.SHIFT_BACKSPACE : None,
    Action.DELETE          : {'command': 'deleteRight', 'when': 'textInputFocus'},
    Action.SHIFT_DELETE    : None,
    Action.DUPLICATE_LINE  : {'command': 'editor.action.copyLinesDownAction', 'when': 'editorTextFocus && !editorReadonly'},
    Action.DELETE_LINE     : {'command': 'editor.action.deleteLines', 'when': 'textInputFocus && !editorReadonly'},
    Action.ENTER           : {'command': 'extension.multiCommand.execute', 'args': {'sequence': ['lineBreakInsert', 'cursorDown', 'cursorEnd', 'cursorHome']}, 'when': 'editorTextFocus && !editorReadonly'},
    Action.COMMENT         : {'command': 'editor.action.commentLine', 'when': 'editorTextFocus && !editorReadonly'},
    Action.EDIT_NEXT_MATCH : {'command': 'editor.action.addSelectionToNextFindMatch', 'when': 'editorFocus'},
    Action.EDIT_PREV_MATCH : {'command': 'editor.action.addSelectionToPreviousFindMatch', 'when': 'editorFocus'},
}

def xml2dict(elem):
    children = []
    for child in elem:
        children.append(xml2dict(child))

    out = {
        "tag": elem.tag,
        "tail": elem.tail,
        "text": elem.text,
        "attrib": elem.attrib,
        "children": children,
    }
    return out


def dict2xml(dic):
    elem = et.Element(dic["tag"])
    elem.text = dic["text"]
    elem.tail = dic["tail"]
    for att in dic["attrib"]:
        elem.set(att, dic["attrib"][att])

    for child in dic["children"]:
        elem.append(dict2xml(child))

    return elem

class VisualStudio:
    def __init__(self, visualstudio_file):
        self.visualstudio_file = visualstudio_file
        self.shortcuts = VisualStudio.load(self.visualstudio_file)
        self.clear_usershortcut()

    @staticmethod
    def load(visualstudio_file):
        with open(visualstudio_file, 'r') as file:
            visualstudio_str = file.read()
        root = et.fromstring(visualstudio_str)
        str1 = et.tostring(root).decode("utf-8")
        visualstudio_dict = xml2dict(root)
        return visualstudio_dict

    @staticmethod
    def format_shortcut(shortcut_str):
        def strip(s):
            l0 = len(s)
            s = s.replace(" +", "+").replace("+ ", "+")
            if s[0] == " ":
                s = s[1:]
            if s[-1] == " ":
                s = s[:-1]

            if len(s) < l0:
                return strip(s)
            else:
                return s

        shortcut_str = strip(shortcut_str + "")
        keys = shortcut_str.strip().split("+")
        keys = [k[0].upper() + k[1:].lower() for k in keys]
        return "+".join(keys)

    def clear_usershortcut(self):
        usershortcuts = self.shortcuts['children'][2]['children'][0]['children'][1]['children'][3]["children"]
        self.shortcuts['children'][2]['children'][0]['children'][1]['children'][3]["children"] = []

    def add(self, action, shortcut_str):
        shortcut_str = VisualStudio.format_shortcut(shortcut_str)
        cmd = commands_visualstudio[action]
        if cmd is None:
            return

        shortcut_dict = {
            "tag": "Shortcut",
            "tail": None,
            "text": shortcut_str,
            "attrib": {
                "Command": cmd,
                "Scope": "Text Editor",
            },
            "children": [],
        }
        self.shortcuts['children'][2]['children'][0]['children'][1]['children'][3]["children"].append(shortcut_dict)

    def save(self):
        root = dict2xml(self.shortcuts)
        shortcuts_str = et.tostring(root).decode("utf-8")
        with open("out/Altitude.vssettings", 'w') as file:
            file.write(shortcuts_str)


class VSCode:
    def __init__(self):
        self.shortcuts = []

    @staticmethod
    def format_shortcut(shortcut_str):
        def strip(s):
            l0 = len(s)
            s = s.replace(" +", "+").replace("+ ", "+")
            if s[0] == " ":
                s = s[1:]
            if s[-1] == " ":
                s = s[:-1]

            if len(s) < l0:
                return strip(s)
            else:
                return s

        shortcut_str = strip(shortcut_str).lower()
        return shortcut_str

    def add(self, action, shortcut_str):
        shortcut_str = VSCode.format_shortcut(shortcut_str)
        cmd = commands_vscode[action]
        if cmd is None:
            return

        shortcut_dict = {"key": shortcut_str}
        shortcut_dict.update(cmd)
        self.shortcuts.append(shortcut_dict)

    def save(self):
        with open("out/keybindings_altitude.json", 'w') as file:
            file.write(json.dumps(self.shortcuts, indent=4))


class Shortcut:
    def __init__(self, visualstudio_file):
        self.visualstudio = VisualStudio(visualstudio_file)
        self.vscode = VSCode()

    def add(self, action, shortcut_str):
        self.visualstudio.add(action, shortcut_str)
        self.vscode.add(action, shortcut_str)

    def save(self):
        self.visualstudio.save()
        self.vscode.save()


def main():
    shct = Shortcut("VisualStudio/Exported-2022-02-23.vssettings")
    shct.add(Action.LEFT            , "Alt+J               ")
    shct.add(Action.CTRL_LEFT       , "Shift+Alt+J         ")
    shct.add(Action.SHIFT_LEFT      , "Ctrl+Alt+J          ")
    shct.add(Action.CTRL_SHIFT_LEFT , "Ctrl+Shift+Alt+J    ")
    shct.add(Action.RIGHT           , "Alt+L               ")
    shct.add(Action.CTRL_RIGHT      , "Shift+Alt+L         ")
    shct.add(Action.SHIFT_RIGHT     , "Ctrl+Alt+L          ")
    shct.add(Action.CTRL_SHIFT_RIGHT, "Ctrl+Shift+Alt+L    ")
    shct.add(Action.UP              , "Alt+I               ")
    shct.add(Action.SHIFT_UP        , "Shift+Alt+I         ")
    shct.add(Action.DOWN            , "Alt+K               ")
    shct.add(Action.SHIFT_DOWN      , "Shift+Alt+K         ")
    shct.add(Action.HOME            , "Alt+U               ")
    shct.add(Action.SHIFT_HOME      , "Shift+Alt+U         ")
    shct.add(Action.END             , "Alt+O               ")
    shct.add(Action.SHIFT_END       , "Shift+Alt+O         ")
    shct.add(Action.BACKSPACE       , "Alt+N               ")
    shct.add(Action.SHIFT_BACKSPACE , "Ctrl+Alt+N          ")
    shct.add(Action.DELETE          , "Shift+Alt+N         ")
    shct.add(Action.SHIFT_DELETE    , "Ctrl+Shift+Alt+N    ")
    shct.add(Action.DUPLICATE_LINE  , "Ctrl+D              ")
    shct.add(Action.DELETE_LINE     , "Alt+D               ")
    shct.add(Action.ENTER           , "Alt+M               ")
    shct.add(Action.COMMENT         , "Ctrl+Num /          ")
    shct.add(Action.COMMENT         , "Alt+7               ")
    shct.add(Action.EDIT_NEXT_MATCH , "Alt+W               ")
    shct.add(Action.EDIT_PREV_MATCH , "Sift+Alt+W          ")
    shct.save()

if __name__ == '__main__':
    main()

# TODO: don^t forget shortcut deletion. Are they needed?
# {'command': '-workbench.action.openEditorAtIndex7'}
# {'command': '-editor.action.addSelectionToNextFindMatch', 'when': 'editorFocus'}
# {'command': '-editor.action.copyLinesDownAction', 'when': 'editorTextFocus && !editorReadonly'}
# {'command': '-editor.action.deleteLines', 'when': 'textInputFocus && !editorReadonly'}
# {'command': '-notebook.cell.copyDown', 'when': 'notebookEditorFocused && !inputFocus'}































