# ZotCopy

## Win + Z to insert cite-keys from Zotero

ZotCopy is a shortcut key for Windows that automates the process of copying citations from Zotero Standalone and pasting them into any other program. This is ideal for people who work in LaTeX, Markdown, or any other plain-text mode.



## Requirements

- Zotero Standalone needs to be running.
  - The _Copy Selected Items to Clipboard_ action needs to be bound to `< Ctrl + Shift + C >`. This is its default setting. It can be changed in _Edit → Preferences → Advanced → Shortcuts_.
- ZotCopy needs to be running.



## How to use ZotCopy

1. Run ZotCopy and Zotero Standalone.
2. At the place in your document where you want to insert citations, press `< Win + z >` to invoke a ZotCopy search prompt.
3. Type a search query and hit `< Enter >`. It will be entered as a search in Zotero.
4. Select the sources that you want to cite. Select multiple source with `< Ctrl + Click >`.
5. To insert the citations, press `< Win + z >` again. They will be copied and inserted into your document.
6. To cancel insertion, press `< Escape >` to go back to your document.


| Key     | Context        | Action                                          |
|---------+----------------+-------------------------------------------------|
| Win + z | Outside Zotero | Invoke ZotCopy and enter a search query.        |
| Win + z | Within Zotero  | Paste the selected items into the invoking app. |
| Escape  | Within Zotero  | Escape to the invoking app (cancel).            |




## Customisation

### Citation format

You can change the quick citation style by going to _Edit → Preferences →
Export → Quick Copy Default Format_. I recommend installing Better BibTeX and
setting this to **Better BibTeX Citation Key Quick Copy**. This is a Pandoc-compatible key that `pandoc-citeproc` can use to build the bibliography automatically.



## Acknowledgements

Thanks to BlackVariant for the icon.  
<http://www.iconarchive.com/show/button-ui-requests-5-icons-by-blackvariant/Zotero-icon.html>

Thanks to berban for InputBox() code.  
<https://autohotkey.com/board/topic/70407-inputbox-easy-powerful-inputbox-implementation/>
