import enum
class TAGS(enum.IntEnum):
    KEYMAPS_ARRAY=enum.auto()

def write(keymaps_array: str):
    header = "_(This readme has been generated with generate_readme.py)_\n"
    with open("models/readme_model.md") as fd:
        MODEL = fd.read()

    text = header + MODEL
    text = text.replace(f"<<<{TAGS.KEYMAPS_ARRAY.name}>>>", keymaps_array)

    text = text.replace("](../images/", "](images/")
    text = text.replace("](..%2Fimages%2F", "](images%2F")

    with open("README.md", "w") as file:
        file.write(text)