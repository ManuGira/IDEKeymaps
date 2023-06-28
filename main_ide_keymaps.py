import xml.etree.ElementTree as et
import xml.dom.minidom
import enum
import json
import zipfile
import os
import shutil

TMP_FOLDER = os.path.join(os.path.dirname(os.path.realpath(__file__)), "tmp")
OUT_FOLDER = os.path.join(os.path.dirname(os.path.realpath(__file__)), "out")

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
    NEW_CARET_UP = enum.auto()
    NEW_CARET_DOWN = enum.auto()
    MOVE_LINE_UP = enum.auto()
    MOVE_LINE_DOWN = enum.auto()
    SCROLL_UP = enum.auto()
    SCROLL_DOWN = enum.auto()

commands_visualstudio = {
    Action.LEFT            : "Edit.CharLeft",
    Action.CTRL_LEFT       : "Edit.WordPrevious",
    Action.SHIFT_LEFT      : "Edit.CharLeftExtend",
    Action.CTRL_SHIFT_LEFT : "Edit.WordPreviousExtend",
    Action.RIGHT           : "Edit.CharRight",
    Action.CTRL_RIGHT      : "Edit.WordNext",
    Action.SHIFT_RIGHT     : "Edit.CharRightExtend",
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
    Action.NEW_CARET_UP    : None,
    Action.NEW_CARET_DOWN  : None,
    Action.MOVE_LINE_UP    : None,
    Action.MOVE_LINE_DOWN  : None,
    Action.SCROLL_UP       : None,
    Action.SCROLL_DOWN     : None,
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
    Action.NEW_CARET_UP    : None,
    Action.NEW_CARET_DOWN  : None,
    Action.MOVE_LINE_UP    : None,
    Action.MOVE_LINE_DOWN  : None,
    Action.SCROLL_UP       : None,
    Action.SCROLL_DOWN     : None,
}

commands_pycharm = {
    Action.LEFT            : "EditorLeft",
    Action.CTRL_LEFT       : "EditorPreviousWord",
    Action.SHIFT_LEFT      : "EditorLeftWithSelection",
    Action.CTRL_SHIFT_LEFT : "EditorPreviousWordWithSelection",
    Action.RIGHT           : "EditorRight",
    Action.CTRL_RIGHT      : "EditorNextWord",
    Action.SHIFT_RIGHT     : "EditorRightWithSelection",
    Action.CTRL_SHIFT_RIGHT: "EditorNextWordWithSelection",
    Action.UP              : "EditorUp",
    Action.SHIFT_UP        : "EditorUpWithSelection",
    Action.DOWN            : "EditorDown",
    Action.SHIFT_DOWN      : "EditorDownWithSelection",
    Action.HOME            : "EditorLineStart",
    Action.SHIFT_HOME      : "EditorLineStartWithSelection",
    Action.END             : "EditorLineEnd",
    Action.SHIFT_END       : "EditorLineEndWithSelection",
    Action.BACKSPACE       : None,
    Action.SHIFT_BACKSPACE : None,
    Action.DELETE          : None,
    Action.SHIFT_DELETE    : None,
    Action.DUPLICATE_LINE  : None,
    Action.DELETE_LINE     : None,
    Action.ENTER           : None,
    Action.COMMENT         : "CommentByLineComment",
    Action.EDIT_NEXT_MATCH : None,
    Action.EDIT_PREV_MATCH : None,
    Action.NEW_CARET_UP    : None,
    Action.NEW_CARET_DOWN  : None,
    Action.MOVE_LINE_UP    : None,
    Action.MOVE_LINE_DOWN  : None,
    Action.SCROLL_UP       : None,
    Action.SCROLL_DOWN     : None,
}
# "Back",
# "Forward",
# "EditorScrollDown",
# "EditorScrollUp",
# "SelectAllOccurrences",
# "SelectNextOccurrence",
# "UnselectPreviousOccurrence",
# "MoveLineDown",
# "MoveLineUp",
#
# "Arrangement.Rule.Match.Condition.Move.Down",
# "Arrangement.Rule.Match.Condition.Move.Up",
# "AutoIndentLines",
# "CodeInspection.OnEditor",
# "ExportToTextFile",
# "List-selectNextColumn",
# "MethodDown",
# "MethodUp",
# "ReformatCode",
# "ShowContent",
# "ShowReformatFileDialog",
# "ShowSearchHistory",
# "SurroundWithLiveTemplate",
# "Table-selectNextColumn",
# "Vcs.ReformatCommitMessage",

def split_filename(filename):
    folder = os.path.dirname(filename)
    name_ext = os.path.basename(filename)
    name = ".".join(name_ext.split(".")[:-1])
    ext = name_ext.split(".")[-1]
    return folder, name, ext

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
        xml_1line_str = et.tostring(root).decode("utf-8")
        dom = xml.dom.minidom.parseString(xml_1line_str)
        shortcut_prettyxml_str = dom.toprettyxml()

        with open(f"{OUT_FOLDER}/Altitude.vssettings", 'w') as file:
            file.write(shortcut_prettyxml_str)


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


class PyCharm:
    def __init__(self, pycharm_settings_zipfile):
        FOLDER_SRC, self.name, ext = split_filename(pycharm_settings_zipfile)
        self.FOLDER_EXTRACTED = os.path.join(TMP_FOLDER, self.name)
        self.FOLDER_DST = os.path.join("out", self.name)

        with zipfile.ZipFile(pycharm_settings_zipfile, 'r') as zip_ref:
            zip_ref.extractall(self.FOLDER_EXTRACTED)

        self.KEYMAP_FILE = os.path.join(self.FOLDER_EXTRACTED, "keymaps", "Altitude.xml")

        self.shortcuts = PyCharm.load(self.KEYMAP_FILE)


    @staticmethod
    def load(pycharm_keymap_file):
        with open(pycharm_keymap_file, 'r') as file:
            pycharm_str = file.read()
        root = et.fromstring(pycharm_str)
        str1 = et.tostring(root).decode("utf-8")
        pycharm_dict = xml2dict(root)
        return pycharm_dict

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
        keys = [k.lower() for k in keys]
        return " ".join(keys)

    def print_debug_info(self):
        for gen1 in self.shortcuts["children"]:
            print(gen1)
        print()
        for gen1 in self.shortcuts["children"]:
            sc_name = gen1["attrib"]["id"]
            for keymap in gen1["children"]:
                if keymap["tag"] == "keyboard-shortcut":
                    sc_keymap = keymap["attrib"]["first-keystroke"]
                    print(sc_name, ":", sc_keymap)

    def clear_usershortcut(self):
        for gen1 in self.shortcuts["children"]:
            gen1["children"] = [gen2 for gen2 in gen1["children"] if gen2["tag"] != "keyboard-shortcut"]

    def add(self, action, shortcut_str):
        shortcut_str = PyCharm.format_shortcut(shortcut_str)
        cmd = commands_pycharm[action]
        if cmd is None:
            return

        found = False
        for gen1 in self.shortcuts["children"]:
            if gen1["attrib"]["id"] == cmd:
                found = True
                break
        if not found:
            gen1 = {
                'tag': 'action',
                'tail': '\nt1',
                'text': '\ntxt1',
                'attrib': {'id': cmd},
                'children': []
            }
            self.shortcuts["children"].append(gen1)

        gen2 = {
            'tag': 'keyboard-shortcut',
            'tail': '\nt2',
            'text': None,
            'attrib': {'first-keystroke': shortcut_str},
            'children': []
        }
        gen1["children"].append(gen2)

    def save(self):
        t = self.shortcuts.copy()
        t["children"] = []
        t["children"].append(self.shortcuts["children"][9]["children"][0])
        t["children"].append(self.shortcuts["children"][9]["children"][0].copy())
        print(et.tostring(dict2xml(t)).decode("utf-8"))

        root = dict2xml(self.shortcuts)
        shortcuts_str = et.tostring(root).decode("utf-8")

        with open(self.KEYMAP_FILE, 'w') as file:
            file.write(shortcuts_str)

        shutil.make_archive(self.FOLDER_DST, 'zip', self.FOLDER_EXTRACTED)

        # with zipfile.ZipFile(self.FOLDER_DST, mode="w") as zf:
        #     for filename in os.listdir(self.FOLDER_EXTRACTED):
        #         file_src = os.path.join(self.FOLDER_EXTRACTED, filename)
        #         zf.write(file_src, filename, compress_type=zipfile.ZIP_DEFLATED)


class Shortcut:
    def __init__(self, visualstudio_file, pycharm_settings_zipfile):
        self.visualstudio = VisualStudio(visualstudio_file)
        self.vscode = VSCode()
        self.pycharm = PyCharm(pycharm_settings_zipfile)

    def add(self, action, shortcut_str):
        if shortcut_str is None:
            return
        self.visualstudio.add(action, shortcut_str)
        self.vscode.add(action, shortcut_str)
        self.pycharm.add(action, shortcut_str)

    def save(self):
        self.visualstudio.save()
        self.vscode.save()
        self.pycharm.save()


def main():
    # delete tmp folder
    for folder in [TMP_FOLDER, OUT_FOLDER]:
        try:
            shutil.rmtree(folder)
        except FileNotFoundError:
            pass
        os.mkdir(folder)

    shct = Shortcut("VisualStudio/Exported-2022-02-23.vssettings", "PyCharm/pycharm_settings.zip")
    shct.add(Action.LEFT            , "Alt+J               ")
    shct.add(Action.CTRL_LEFT       , "Ctrl+Alt+J          ")
    shct.add(Action.SHIFT_LEFT      , "Shift+Alt+J         ")
    shct.add(Action.CTRL_SHIFT_LEFT , "Ctrl+Shift+Alt+J    ")
    shct.add(Action.RIGHT           , "Alt+L               ")
    shct.add(Action.CTRL_RIGHT      , "Ctrl+Alt+L          ")
    shct.add(Action.SHIFT_RIGHT     , "Shift+Alt+L         ")
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
    shct.add(Action.NEW_CARET_UP    , None)
    shct.add(Action.NEW_CARET_DOWN  , None)
    shct.add(Action.MOVE_LINE_UP    , "Alt+P               ")
    shct.add(Action.MOVE_LINE_DOWN  , "Alt+é               ")
    shct.add(Action.SCROLL_UP       , None)
    shct.add(Action.SCROLL_DOWN     , None)
    shct.save()

    try:
        shutil.rmtree(TMP_FOLDER)
    except FileNotFoundError:
        pass

if __name__ == '__main__':
    main()

# TODO: don't forget shortcut deletion. Are they needed?
# {'command': '-workbench.action.openEditorAtIndex7'}
# {'command': '-editor.action.addSelectionToNextFindMatch', 'when': 'editorFocus'}
# {'command': '-editor.action.copyLinesDownAction', 'when': 'editorTextFocus && !editorReadonly'}
# {'command': '-editor.action.deleteLines', 'when': 'textInputFocus && !editorReadonly'}
# {'command': '-notebook.cell.copyDown', 'when': 'notebookEditorFocused && !inputFocus'}



"""
PYCHARM KEYMAPS

Back : ctrl alt left
Back : alt comma
CommentByLineComment : ctrl slash
CommentByLineComment : ctrl divide
CommentByLineComment : alt 7
EditorDown : down
EditorDown : alt k
EditorDownWithSelection : shift down
EditorDownWithSelection : shift alt k
EditorLeft : left
EditorLeft : alt j
EditorLeftWithSelection : shift left
EditorLeftWithSelection : shift alt j
EditorLineEnd : end
EditorLineEnd : alt o
EditorLineEndWithSelection : shift end
EditorLineEndWithSelection : shift alt o
EditorLineStart : home
EditorLineStart : alt u
EditorLineStartWithSelection : shift home
EditorLineStartWithSelection : shift alt u
EditorNextWord : ctrl right
EditorNextWord : ctrl alt l
EditorNextWordWithSelection : shift ctrl right
EditorNextWordWithSelection : shift ctrl alt l
EditorPreviousWord : ctrl left
EditorPreviousWord : ctrl alt j
EditorPreviousWordWithSelection : shift ctrl left
EditorPreviousWordWithSelection : shift ctrl alt j
EditorRight : right
EditorRight : alt l
EditorRightWithSelection : shift right
EditorRightWithSelection : shift alt l
EditorScrollDown : ctrl down
EditorScrollDown : ctrl alt k
EditorScrollUp : ctrl up
EditorScrollUp : ctrl alt i
EditorUp : up
EditorUp : alt i
EditorUpWithSelection : shift up
EditorUpWithSelection : shift alt i
Forward : ctrl alt right
Forward : alt period
List-selectNextColumn : right
MoveLineDown : alt down
MoveLineDown : alt #10000e9
MoveLineUp : alt up
MoveLineUp : alt p
Table-selectNextColumn : right


{'tag': 'action', 'tail': '\n  ', 'text': '\n    ', 'attrib': {'id': 'Back'}, 'children': [{'tag': 'keyboard-shortcut', 'tail': '\n    ', 'text': None, 'attrib': {'first-keystroke': 'ctrl alt left'}, 'children': []}, {'tag': 'mouse-shortcut', 'tail': '\n    ', 'text': None, 'attrib': {'keystroke': 'button4'}, 'children': []}, {'tag': 'keyboard-shortcut', 'tail': '\n  ', 'text': None, 'attrib': {'first-keystroke': 'alt comma'}, 'children': []}]}

"""

