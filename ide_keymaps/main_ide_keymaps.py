import abc
import enum
import json
import os
import shutil
import xml.dom.minidom
import xml.etree.ElementTree as et
import zipfile

BUILD_FOLDER = os.path.join(os.path.dirname(os.path.realpath(__file__)), "build")
TMP_FOLDER = os.path.join(BUILD_FOLDER, "tmp")

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
    NEW_CARET_ABOVE = enum.auto()
    NEW_CARET_BELOW = enum.auto()
    MOVE_LINE_UP = enum.auto()
    MOVE_LINE_DOWN = enum.auto()
    SCROLL_UP = enum.auto()
    SCROLL_DOWN = enum.auto()
    BACK = enum.auto()
    FORWARD = enum.auto()
    REVEAL_IN_EXPLORER = enum.auto()
    REFORMAT_CODE = enum.auto()
    COMPARE_SELECTION_WITH_CLIPBOARD = enum.auto()

commands_visualstudio = {
    Action.LEFT                 : "Edit.CharLeft",
    Action.CTRL_LEFT            : "Edit.WordPrevious",
    Action.SHIFT_LEFT           : "Edit.CharLeftExtend",
    Action.CTRL_SHIFT_LEFT      : "Edit.WordPreviousExtend",
    Action.RIGHT                : "Edit.CharRight",
    Action.CTRL_RIGHT           : "Edit.WordNext",
    Action.SHIFT_RIGHT          : "Edit.CharRightExtend",
    Action.CTRL_SHIFT_RIGHT     : "Edit.WordNextExtend",
    Action.UP                   : "Edit.LineUp",
    Action.SHIFT_UP             : "Edit.LineUpExtend",
    Action.DOWN                 : "Edit.LineDown",
    Action.SHIFT_DOWN           : "Edit.LineDownExtend",
    Action.HOME                 : "Edit.LineStart",
    Action.SHIFT_HOME           : "Edit.LineStartExtend",
    Action.END                  : "Edit.LineEnd",
    Action.SHIFT_END            : "Edit.LineEndExtend",
    Action.BACKSPACE            : "Edit.DeleteBackwards",
    Action.SHIFT_BACKSPACE      : "Edit.WordDeleteToStart",
    Action.DELETE               : "Edit.Delete",
    Action.SHIFT_DELETE         : "Edit.WordDeleteToEnd",
    Action.DUPLICATE_LINE       : None,
    Action.DELETE_LINE          : "Edit.LineDelete",
    Action.ENTER                : "Edit.BreakLine",
    Action.COMMENT              : "ReSharper.ReSharper_LineComment",
    Action.EDIT_NEXT_MATCH      : None,
    Action.EDIT_PREV_MATCH      : None,
    Action.NEW_CARET_ABOVE      : None,
    Action.NEW_CARET_BELOW      : None,
    Action.MOVE_LINE_UP         : "Edit.MoveSelectedLinesUp",
    Action.MOVE_LINE_DOWN       : "Edit.MoveSelectedLinesDown",
    Action.SCROLL_UP            : None,
    Action.SCROLL_DOWN          : None,
    Action.BACK                 : "View.NavigateBackward",
    Action.FORWARD              : "View.NavigateForward",
    Action.REVEAL_IN_EXPLORER   : None,
    Action.REFORMAT_CODE        : "Edit.FormatDocument",  # TODO: test it
    Action.COMPARE_SELECTION_WITH_CLIPBOARD: None,
}

commands_vscode = {
    Action.LEFT                 : {'command': 'cursorLeft', 'when': 'textInputFocus'},
    Action.CTRL_LEFT            : {'command': 'cursorWordLeft', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.SHIFT_LEFT           : {'command': 'cursorLeftSelect', 'when': 'textInputFocus'},
    Action.CTRL_SHIFT_LEFT      : {'command': 'cursorWordLeftSelect', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.RIGHT                : {'command': 'cursorRight', 'when': 'textInputFocus'},
    Action.CTRL_RIGHT           : {'command': 'cursorWordRight', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.SHIFT_RIGHT          : {'command': 'cursorRightSelect', 'when': 'textInputFocus'},
    Action.CTRL_SHIFT_RIGHT     : {'command': 'cursorWordRightSelect', 'when': 'textInputFocus && !accessibilityModeEnabled'},
    Action.UP                   : {'command': 'cursorUp', 'when': 'textInputFocus'},
    Action.SHIFT_UP             : {'command': 'cursorUpSelect', 'when': 'textInputFocus'},
    Action.DOWN                 : {'command': 'cursorDown', 'when': 'textInputFocus'},
    Action.SHIFT_DOWN           : {'command': 'cursorDownSelect', 'when': 'textInputFocus'},
    Action.HOME                 : {'command': 'cursorHome', 'when': 'textInputFocus'},
    Action.SHIFT_HOME           : {'command': 'cursorHomeSelect', 'when': 'textInputFocus'},
    Action.END                  : {'command': 'cursorEnd', 'when': 'textInputFocus'},
    Action.SHIFT_END            : {'command': 'cursorEndSelect', 'when': 'textInputFocus'},
    Action.BACKSPACE            : {'command': 'deleteLeft', 'when': 'textInputFocus'},
    Action.SHIFT_BACKSPACE      : None,
    Action.DELETE               : {'command': 'deleteRight', 'when': 'textInputFocus'},
    Action.SHIFT_DELETE         : None,
    Action.DUPLICATE_LINE       : {'command': 'editor.action.copyLinesDownAction', 'when': 'editorTextFocus && !editorReadonly'},
    Action.DELETE_LINE          : {'command': 'editor.action.deleteLines', 'when': 'textInputFocus && !editorReadonly'},
    Action.ENTER                : {'command': 'extension.multiCommand.execute', 'args': {'sequence': ['lineBreakInsert', 'cursorDown', 'cursorEnd', 'cursorHome']}, 'when': 'editorTextFocus && !editorReadonly'},
    Action.COMMENT              : {'command': 'editor.action.commentLine', 'when': 'editorTextFocus && !editorReadonly'},
    Action.EDIT_NEXT_MATCH      : {'command': 'editor.action.addSelectionToNextFindMatch', 'when': 'editorFocus'},
    Action.EDIT_PREV_MATCH      : {'command': 'editor.action.addSelectionToPreviousFindMatch', 'when': 'editorFocus'},
    Action.NEW_CARET_ABOVE      : {'command': 'editor.action.insertCursorAbove', 'when': 'editorFocus'},
    Action.NEW_CARET_BELOW      : {'command': 'editor.action.insertCursorBelow', 'when': 'editorFocus'},
    Action.MOVE_LINE_UP         : None,
    Action.MOVE_LINE_DOWN       : None,
    Action.SCROLL_UP            : None,
    Action.SCROLL_DOWN          : None,
    Action.BACK                 : None,
    Action.FORWARD              : None,
    Action.REVEAL_IN_EXPLORER   : {'command': 'editor.action.revealFileInOS', 'when': 'editorFocus'},
    Action.REFORMAT_CODE        : {'command': 'editor.action.formatDocument', 'when': 'editorTextFocus'},  # TODO: test it
    Action.COMPARE_SELECTION_WITH_CLIPBOARD: {'command': 'editor.action.compareWithClipboard', 'when': 'editorTextFocus'},  # Todo: test it
}

commands_pycharm = {
    Action.LEFT                 : "EditorLeft",
    Action.CTRL_LEFT            : "EditorPreviousWord",
    Action.SHIFT_LEFT           : "EditorLeftWithSelection",
    Action.CTRL_SHIFT_LEFT      : "EditorPreviousWordWithSelection",
    Action.RIGHT                : "EditorRight",
    Action.CTRL_RIGHT           : "EditorNextWord",
    Action.SHIFT_RIGHT          : "EditorRightWithSelection",
    Action.CTRL_SHIFT_RIGHT     : "EditorNextWordWithSelection",
    Action.UP                   : "EditorUp",
    Action.SHIFT_UP             : "EditorUpWithSelection",
    Action.DOWN                 : "EditorDown",
    Action.SHIFT_DOWN           : "EditorDownWithSelection",
    Action.HOME                 : "EditorLineStart",
    Action.SHIFT_HOME           : "EditorLineStartWithSelection",
    Action.END                  : "EditorLineEnd",
    Action.SHIFT_END            : "EditorLineEndWithSelection",
    Action.BACKSPACE            : None,
    Action.SHIFT_BACKSPACE      : None,
    Action.DELETE               : None,
    Action.SHIFT_DELETE         : None,
    Action.DUPLICATE_LINE       : None,
    Action.DELETE_LINE          : "EditorDeleteLine",
    Action.ENTER                : None,
    Action.COMMENT              : "CommentByLineComment",
    Action.EDIT_NEXT_MATCH      : None,
    Action.EDIT_PREV_MATCH      : None,
    Action.NEW_CARET_ABOVE      : "EditorCloneCaretAbove",
    Action.NEW_CARET_BELOW      : "EditorCloneCaretBelow",
    Action.MOVE_LINE_UP         : "MoveLineUp",
    Action.MOVE_LINE_DOWN       : "MoveLineDown",
    Action.SCROLL_UP            : None,
    Action.SCROLL_DOWN          : None,
    Action.BACK                 : "Back",
    Action.FORWARD              : "Forward",
    Action.REVEAL_IN_EXPLORER   : "ShowFilePath",
    Action.REFORMAT_CODE        : "ReformatCode",
    Action.COMPARE_SELECTION_WITH_CLIPBOARD: "CompareSelectionWithClipboard",
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
    for att in sorted(dic["attrib"].keys()):
        elem.set(att, dic["attrib"][att])

    for child in dic["children"]:
        elem.append(dict2xml(child))

    return elem

# def repair_special_characters(txt):
#     translation_pairs = [
#         ("&#233;", "é"),
#     ]
#     for broken_utf8, special_character in translation_pairs:
#         txt = txt.replace(broken_utf8, special_character)
#     return txt

class IDEKeymapInterface(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def add(self, action, shortcut_str):
        raise NotImplementedError

    @abc.abstractmethod
    def save(self):
        raise NotImplementedError

    @abc.abstractmethod
    def get_name(self):
        raise NotImplementedError

    @abc.abstractmethod
    def is_capable_of(self, action: Action):
        raise NotImplementedError


class VisualStudio(IDEKeymapInterface):
    commands = commands_visualstudio

    def __init__(self, visualstudio_file, suffix=""):
        self.visualstudio_file = visualstudio_file
        self.visualstudio_xml = VisualStudio.load(self.visualstudio_file)
        self.suffix = suffix
        self.clear_usershortcut()

    @staticmethod
    def load(visualstudio_file):
        with open(visualstudio_file, 'r') as file:
            visualstudio_str = file.read()
        visualstudio_xml = et.fromstring(visualstudio_str)
        return visualstudio_xml

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
        keys = [k[0].upper() + k[1:].lower() if k not in ["é"] else k for k in keys]
        return "+".join(keys)

    def clear_usershortcut(self):
        self.visualstudio_xml.find("Category/Category/KeyboardShortcuts/UserShortcuts").clear()

    def clear_usershortcut_resharper(self):
        shortcut_path = "Category/Category/KeyboardShortcuts/UserShortcuts"

        # filter out all resharper shortcuts
        children = xml2dict(self.visualstudio_xml.find(shortcut_path))["children"]
        children = [child for child in children if "ReSharper" not in child["attrib"]["Command"]]

        # clear all children and re-add only the non-resharper ones
        self.visualstudio_xml.find(shortcut_path).clear()
        for child in children:
            self.visualstudio_xml.find(shortcut_path).append(dict2xml(child))

    def add(self, action, shortcut_str):
        shortcut_str = VisualStudio.format_shortcut(shortcut_str)
        cmd = self.commands[action]
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
        self.visualstudio_xml.find("Category/Category/KeyboardShortcuts/UserShortcuts").append(dict2xml(shortcut_dict))

    def save(self):
        # save 2 version of the vsssetings. One with resharper shortcuts and one without

        # create all foldr and subfolder if they doesn't exists
        folder = f"{BUILD_FOLDER}/{self.get_name()}"
        os.makedirs(folder, exist_ok=True)

        shortcuts_str = et.tostring(self.visualstudio_xml).decode("cp1252")
        # shortcuts_str = repair_special_characters(shortcuts_str)
        shortcuts_str = xml.dom.minidom.parseString(shortcuts_str).toprettyxml()

        with open(f"{folder}/Altitude.vssettings", 'w') as file:
            file.write(shortcuts_str)

        self.clear_usershortcut_resharper()
        shortcuts_str = et.tostring(self.visualstudio_xml).decode("cp1252")
        # shortcuts_str = repair_special_characters(shortcuts_str)
        shortcuts_str = xml.dom.minidom.parseString(shortcuts_str).toprettyxml()
        with open(f"{folder}/Altitude_NoReSharper.vssettings", 'w') as file:
            file.write(shortcuts_str)

    def get_name(self):
        return self.__class__.__name__ + self.suffix

    def is_capable_of(self, action: Action):
        return action in self.commands and self.commands[action] is not None

class VSCode(IDEKeymapInterface):
    commands = commands_vscode

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
        cmd = self.commands[action]
        if cmd is None:
            return

        shortcut_dict = {"key": shortcut_str}
        shortcut_dict.update(cmd)
        self.shortcuts.append(shortcut_dict)

    def save(self):
        # create all foldr and subfolder if they doesn't exists
        folder = f"{BUILD_FOLDER}/{self.get_name()}"
        os.makedirs(folder, exist_ok=True)
        with open(f"{folder}/keybindings_altitude.json", 'w') as file:
            file.write(json.dumps(self.shortcuts, indent=4))

    def get_name(self):
        return self.__class__.__name__

    def is_capable_of(self, action: Action):
        return action in self.commands and self.commands[action] is not None

class PyCharm(IDEKeymapInterface):
    commands = commands_pycharm

    def __init__(self, pycharm_settings_zipfile):
        FOLDER_SRC, self.name, ext = split_filename(pycharm_settings_zipfile)
        self.FOLDER_EXTRACTED = os.path.join(TMP_FOLDER, self.name)
        self.FOLDER_DST = os.path.join(BUILD_FOLDER, self.get_name(), self.name)

        with zipfile.ZipFile(pycharm_settings_zipfile, 'r') as zip_ref:
            zip_ref.extractall(self.FOLDER_EXTRACTED)

        self.KEYMAP_FILE = os.path.join(self.FOLDER_EXTRACTED, "keymaps", "Altitude.xml")

        self.shortcuts = PyCharm.load(self.KEYMAP_FILE)


    @staticmethod
    def load(pycharm_keymap_file):
        with open(pycharm_keymap_file, 'r') as file:
            pycharm_str = file.read()
        root = et.fromstring(pycharm_str)
        str1 = et.tostring(root).decode("cp1252")
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

        shortcut_str = shortcut_str.replace("é", "#10000e9")
        shortcut_str = shortcut_str.replace(",", "comma")
        shortcut_str = shortcut_str.replace(".", "period")

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
        cmd = self.commands[action]
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
                'tail': '\n',
                'text': '\n',
                'attrib': {'id': cmd},
                'children': []
            }
            self.shortcuts["children"].append(gen1)

        gen2 = {
            'tag': 'keyboard-shortcut',
            'tail': '\n',
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
        # print(et.tostring(dict2xml(t)).decode("cp1252"))

        root = dict2xml(self.shortcuts)
        shortcuts_str = et.tostring(root).decode("cp1252")
        shortcuts_str = xml.dom.minidom.parseString(shortcuts_str).toprettyxml(indent="  ")


        def ensure_single_space_before_closing_balisis(txt):
            N = len(txt)
            while True:
                txt = txt.replace(" />", "/>")
                if N == len(txt):
                    break
                N = len(txt)
            txt = txt.replace("/>", " />")
            return txt

        shortcuts_str = ensure_single_space_before_closing_balisis(shortcuts_str)

        def clean_spaces(txt):
            N = len(txt)
            while True:
                txt = txt.replace(" \n", "\n")
                txt = txt.replace("\t\n", "\n")
                txt = txt.replace("\n\n", "\n")
                if N == len(txt):
                    break
                N = len(txt)
            return txt

        shortcuts_str = clean_spaces(shortcuts_str)

        folder = os.path.dirname(self.KEYMAP_FILE)
        os.makedirs(folder, exist_ok=True)
        with open(self.KEYMAP_FILE, 'w') as file:
            file.write(shortcuts_str)

        shutil.make_archive(self.FOLDER_DST, 'zip', self.FOLDER_EXTRACTED)

        # with zipfile.ZipFile(self.FOLDER_DST, mode="w") as zf:
        #     for filename in os.listdir(self.FOLDER_EXTRACTED):
        #         file_src = os.path.join(self.FOLDER_EXTRACTED, filename)
        #         zf.write(file_src, filename, compress_type=zipfile.ZIP_DEFLATED)

    def get_name(self):
        return self.__class__.__name__

    def is_capable_of(self, action: Action):
        return action in self.commands and self.commands[action] is not None

class Shortcut:
    def __init__(self, ide_list: list[IDEKeymapInterface]):
        self.ide_list = ide_list
        self.items = []

    def add(self, action, shortcut_str):
        if shortcut_str is None:
            return
        self.items.append((action, shortcut_str))
        for ide in self.ide_list:
            ide.add(action, shortcut_str)

    def save(self):
        for ide in self.ide_list:
            ide.save()

    def generate_markdown_table(self):
        lines = []
        header = ["Keymap", "Action"] + [ide.get_name() for ide in self.ide_list]
        # lines.append(header)
        # lines.append("".join(["|" if c == "|" else "-" for c in header]))

        for action, shortcut_str in self.items:
            line = [shortcut_str, action.name]
            for ide in self.ide_list:
                line.append("X" if ide.is_capable_of(action) else " ")
            lines.append(line)

        max_len = 0
        for line in lines:
            for word in line:
                max_len = len(word) if max_len < len(word) else max_len

        sep_line = ["-"*max_len for _ in header]

        out = ""
        for line in [header, sep_line] + lines:
            for word in line:
                out += "|" + word + " "*(max_len-len(word))
            out += "|\n"
        return out




def main():
    # delete tmp folder
    try:
        shutil.rmtree(BUILD_FOLDER)
    except FileNotFoundError:
        pass
    os.mkdir(BUILD_FOLDER)
    os.mkdir(TMP_FOLDER)

    pycharm = PyCharm("models/PyCharm/pycharm_settings.zip")
    vscode = VSCode()
    visual_studio_2017 = VisualStudio("models/VisualStudio2017/Exported-2022-02-23.vssettings", suffix="2017")
    visual_studio_2022 = VisualStudio("models/VisualStudio2022/Exported-2024-12-19.vssettings", suffix="2022")

    shct = Shortcut([pycharm, vscode, visual_studio_2017, visual_studio_2022])
    shct.add(Action.LEFT                , "Alt+J               ")
    shct.add(Action.CTRL_LEFT           , "Ctrl+Alt+J          ")
    shct.add(Action.SHIFT_LEFT          , "Shift+Alt+J         ")
    shct.add(Action.CTRL_SHIFT_LEFT     , "Ctrl+Shift+Alt+J    ")
    shct.add(Action.RIGHT               , "Alt+L               ")
    shct.add(Action.CTRL_RIGHT          , "Ctrl+Alt+L          ")
    shct.add(Action.SHIFT_RIGHT         , "Shift+Alt+L         ")
    shct.add(Action.CTRL_SHIFT_RIGHT    , "Ctrl+Shift+Alt+L    ")
    shct.add(Action.UP                  , "Alt+I               ")
    shct.add(Action.SHIFT_UP            , "Shift+Alt+I         ")
    shct.add(Action.DOWN                , "Alt+K               ")
    shct.add(Action.SHIFT_DOWN          , "Shift+Alt+K         ")
    shct.add(Action.HOME                , "Alt+U               ")
    shct.add(Action.SHIFT_HOME          , "Shift+Alt+U         ")
    shct.add(Action.END                 , "Alt+O               ")
    shct.add(Action.SHIFT_END           , "Shift+Alt+O         ")
    shct.add(Action.BACKSPACE           , "Alt+N               ")
    shct.add(Action.SHIFT_BACKSPACE     , "Ctrl+Alt+N          ")
    shct.add(Action.DELETE              , "Shift+Alt+N         ")
    shct.add(Action.SHIFT_DELETE        , "Ctrl+Shift+Alt+N    ")
    shct.add(Action.DUPLICATE_LINE      , "Ctrl+D              ")
    shct.add(Action.DELETE_LINE         , "Ctrl+Y              ")
    shct.add(Action.ENTER               , "Alt+M               ")
    shct.add(Action.COMMENT             , "Ctrl+Num /          ")
    shct.add(Action.COMMENT             , "Alt+7               ")
    shct.add(Action.EDIT_NEXT_MATCH     , "Alt+W               ")
    shct.add(Action.EDIT_PREV_MATCH     , "Sift+Alt+W          ")
    shct.add(Action.NEW_CARET_ABOVE     , "Ctrl+Alt+I          ")
    shct.add(Action.NEW_CARET_BELOW     , "Ctrl+Alt+K          ")
    shct.add(Action.MOVE_LINE_UP        , "Alt+P               ")
    shct.add(Action.MOVE_LINE_DOWN      , "Alt+é               ")
    shct.add(Action.SCROLL_UP           , None)
    shct.add(Action.SCROLL_DOWN         , None)
    shct.add(Action.BACK                , "Alt+,               ")
    shct.add(Action.FORWARD             , "Alt+.               ")
    shct.add(Action.REVEAL_IN_EXPLORER  , "Alt+E               ")
    shct.add(Action.REFORMAT_CODE       , "Alt+S               ")
    shct.add(Action.COMPARE_SELECTION_WITH_CLIPBOARD, "Alt+C   ")
    shct.save()

    keymap_array: str = shct.generate_markdown_table()
    import generate_readme
    generate_readme.write(keymap_array)

    # try:
    #     shutil.rmtree(TMP_FOLDER)
    # except FileNotFoundError:
    #     pass

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

